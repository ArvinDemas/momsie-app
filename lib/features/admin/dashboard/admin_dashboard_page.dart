import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/admin/dashboard/admin_dashboard_controller.dart';
import 'package:douce/features/admin/dashboard/widgets/category_bar_chart.dart';
import 'package:douce/features/admin/dashboard/widgets/kpi_card.dart';
import 'package:douce/features/admin/dashboard/widgets/sales_line_chart.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController controller = Get.put(AdminDashboardController());
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Momsie Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: ColorDouce.douceBase,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => controller.logoutAdmin(),
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 900 ? _buildSidebar(context, controller) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar untuk Desktop (lebar >= 900)
          if (MediaQuery.of(context).size.width >= 900)
            SizedBox(
              width: 250,
              child: _buildSidebar(context, controller),
            ),
          // Konten Utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Utama & Tombol Ekspor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dashboard Penjualan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pantau transaksi masuk Momsie App secara realtime',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                      // Tombol Export Sesi 5
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => controller.exportToCSV(),
                            icon: const Icon(Icons.file_download_outlined, size: 18),
                            label: const Text('CSV'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.teal[700],
                              side: BorderSide(color: Colors.teal[600]!, width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => controller.exportToPDF(),
                            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                            label: const Text('PDF Report'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red[700],
                              side: BorderSide(color: Colors.red[200]!, width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // KPI Cards Grid (Responsive)
                  Obx(() {
                    final double screenWidth = MediaQuery.of(context).size.width;
                    int crossAxisCount = 4;
                    if (screenWidth < 600) {
                      crossAxisCount = 1;
                    } else if (screenWidth < 1100) {
                      crossAxisCount = 2;
                    }

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: screenWidth < 600 ? 4 : 2.2,
                      children: [
                        KpiCard(
                          title: 'Total Pendapatan',
                          value: currencyFormat.format(controller.totalRevenue.value),
                          icon: Icons.monetization_on_outlined,
                          color: Colors.teal,
                        ),
                        KpiCard(
                          title: 'Bulan Ini',
                          value: currencyFormat.format(controller.monthlyRevenue.value),
                          icon: Icons.calendar_today_outlined,
                          color: Colors.indigo,
                        ),
                        KpiCard(
                          title: 'Pending Verifikasi',
                          value: '${controller.pendingCount.value} Transaksi',
                          icon: Icons.hourglass_empty_rounded,
                          color: Colors.amber[700]!,
                        ),
                        KpiCard(
                          title: 'Total Transaksi',
                          value: '${controller.totalCount.value}',
                          icon: Icons.shopping_bag_outlined,
                          color: ColorDouce.douceBase,
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 28),

                  // Section Charts (Responsive Row/Column)
                  Obx(() {
                    final double screenWidth = MediaQuery.of(context).size.width;
                    final chartList = [
                      Expanded(
                        flex: screenWidth >= 1100 ? 1 : 0,
                        child: SalesLineChart(transactions: controller.allTransactions),
                      ),
                      if (screenWidth < 1100) const SizedBox(height: 16),
                      Expanded(
                        flex: screenWidth >= 1100 ? 1 : 0,
                        child: CategoryBarChart(transactions: controller.allTransactions),
                      ),
                    ];

                    return screenWidth >= 1100
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              chartList[0],
                              const SizedBox(width: 16),
                              chartList[2],
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(width: double.infinity, child: chartList[0]),
                              const SizedBox(height: 16),
                              SizedBox(width: double.infinity, child: chartList[2]),
                            ],
                          );
                  }),
                  const SizedBox(height: 28),

                  // Filter & Search Panel
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter & Pencarian',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double width = constraints.maxWidth;
                              final isMobile = width < 700;

                              final searchField = TextField(
                                onChanged: (val) {
                                  controller.searchQuery.value = val;
                                  controller.applyFilters();
                                },
                                decoration: InputDecoration(
                                  hintText: 'Cari ID, Nama, Deskripsi...',
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );

                              final filterRow = [
                                _buildDropdownFilter(
                                  label: 'Status',
                                  value: controller.selectedStatus,
                                  items: ['Semua', 'Pending', 'Paid', 'Cancelled'],
                                  onChanged: controller.applyFilters,
                                ),
                                const SizedBox(width: 12),
                                _buildDropdownFilter(
                                  label: 'Kategori',
                                  value: controller.selectedCategory,
                                  items: ['Semua', 'Doula', 'Obat', 'Tema', 'Diary'],
                                  onChanged: controller.applyFilters,
                                ),
                                const SizedBox(width: 12),
                                _buildDropdownFilter(
                                  label: 'Waktu',
                                  value: controller.selectedDateFilter,
                                  items: ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'],
                                  onChanged: controller.applyFilters,
                                ),
                              ];

                              return isMobile
                                  ? Column(
                                      children: [
                                        searchField,
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(child: filterRow[0]),
                                            const SizedBox(width: 8),
                                            Expanded(child: filterRow[2]),
                                            const SizedBox(width: 8),
                                            Expanded(child: filterRow[4]),
                                          ],
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(flex: 3, child: searchField),
                                        const SizedBox(width: 16),
                                        Expanded(flex: 2, child: filterRow[0]),
                                        const SizedBox(width: 12),
                                        Expanded(flex: 2, child: filterRow[2]),
                                        const SizedBox(width: 12),
                                        Expanded(flex: 2, child: filterRow[4]),
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Data Table Transaksi
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Daftar Transaksi Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              Obx(() => Text(
                                    'Menampilkan ${controller.filteredTransactions.length} item',
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(() {
                            if (controller.filteredTransactions.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Text('Tidak ada data transaksi yang cocok.'),
                                ),
                              );
                            }

                            return Scrollbar(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(label: Text('ID Transaksi', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Pengguna', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Layanan', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Nominal', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Metode', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Bukti', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                  rows: controller.filteredTransactions.map((tx) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(tx.id, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.w600))),
                                        DataCell(Text(dateFormat.format(tx.createdAt), style: const TextStyle(fontSize: 12))),
                                        DataCell(Text(tx.namaUser)),
                                        DataCell(Chip(
                                          label: Text(_getLayananName(tx.jenisLayanan), style: const TextStyle(fontSize: 11, color: Colors.white)),
                                          backgroundColor: _getLayananColor(tx.jenisLayanan),
                                          padding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                        )),
                                        DataCell(Text(tx.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(currencyFormat.format(tx.nominal), style: const TextStyle(fontWeight: FontWeight.w600))),
                                        DataCell(Text(tx.metodePembayaran.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontSize: 12))),
                                        DataCell(_buildBuktiCell(context, tx)),
                                        DataCell(_buildStatusChip(tx.status)),
                                        DataCell(_buildActionCell(tx, controller)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AdminDashboardController controller) {
    return Container(
      color: const Color(0xFF1E293B),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Momsie Admin',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Sales Panel', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 20),
          _buildSidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Monitoring',
            selected: true,
          ),
          const Spacer(),
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text('Keluar Aplikasi', style: TextStyle(color: Colors.redAccent)),
            onTap: () => controller.logoutAdmin(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String title, required bool selected}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? ColorDouce.douceBase.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? ColorDouce.douceBase : Colors.grey[400]),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[400],
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required RxString value,
    required List<String> items,
    required VoidCallback onChanged,
  }) {
    return Obx(() => DropdownButtonFormField<String>(
          value: value.value,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              value.value = val;
              onChanged();
            }
          },
        ));
  }

  String _getLayananName(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'doula':
        return 'Doula';
      case 'obat':
        return 'Obat';
      case 'tema':
        return 'Tema';
      case 'diary_premium':
        return 'Diary';
      default:
        return jenis.toUpperCase();
    }
  }

  Color _getLayananColor(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'doula':
        return ColorDouce.douceBase;
      case 'obat':
        return const Color(0xFF6C63FF);
      case 'tema':
        return const Color(0xFFFFB74D);
      case 'diary_premium':
        return const Color(0xFF4CAF50);
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    String label = status.toUpperCase();

    if (status == 'paid') {
      color = Colors.green;
      label = 'PAID';
    } else if (status == 'pending') {
      color = Colors.orange;
      label = 'PENDING';
    } else if (status == 'cancelled') {
      color = Colors.red;
      label = 'CANCELLED';
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildBuktiCell(BuildContext context, TransaksiModel tx) {
    if (tx.buktiPembayaran == null || tx.buktiPembayaran!.isEmpty) {
      return const Text('-', style: TextStyle(color: Colors.grey));
    }

    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bukti Bayar - ${tx.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: tx.buktiPembayaran!,
                      placeholder: (context, url) => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const SizedBox(
                        height: 100,
                        child: Center(child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey)),
                      ),
                      fit: BoxFit.contain,
                      maxHeightDiskCache: 800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: const Icon(Icons.image_search_rounded, size: 16),
      label: const Text('Lihat Struk', style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildActionCell(TransaksiModel tx, AdminDashboardController controller) {
    if (tx.status != 'pending') {
      return const Text('-', style: TextStyle(color: Colors.grey));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.green),
          tooltip: 'Verifikasi Pembayaran',
          onPressed: () => controller.verifyTransaction(tx.id),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          tooltip: 'Batalkan Transaksi',
          onPressed: () => controller.cancelTransaction(tx.id),
        ),
      ],
    );
  }
}
