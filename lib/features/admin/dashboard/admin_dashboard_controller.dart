import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:douce/shared/util/helper/file_helper.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AdminDashboardController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  StreamSubscription<List<TransaksiModel>>? _subscription;

  // Realtime lists
  final RxList<TransaksiModel> allTransactions = <TransaksiModel>[].obs;
  final RxList<TransaksiModel> filteredTransactions = <TransaksiModel>[].obs;

  // Filters state
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'Semua'.obs; // 'Semua', 'pending', 'paid', 'cancelled'
  final RxString selectedCategory = 'Semua'.obs; // 'Semua', 'Doula', 'Obat', 'Tema', 'Diary'
  final RxString selectedDateFilter = 'Semua'.obs; // 'Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'

  // KPI stats
  final RxInt totalRevenue = 0.obs;
  final RxInt totalCount = 0.obs;
  final RxInt paidCount = 0.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt monthlyRevenue = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _startListening() {
    _subscription = _paymentService.streamAllTransaksi().listen((txList) {
      allTransactions.value = txList;
      _calculateStats();
      applyFilters();
    });
  }

  void _calculateStats() {
    int revenue = 0;
    int success = 0;
    int pending = 0;
    int monthlyRev = 0;
    final now = DateTime.now();

    for (var tx in allTransactions) {
      if (tx.status == 'paid') {
        revenue += tx.nominal;
        success++;

        if (tx.createdAt.month == now.month && tx.createdAt.year == now.year) {
          monthlyRev += tx.nominal;
        }
      } else if (tx.status == 'pending') {
        pending++;
      }
    }

    totalRevenue.value = revenue;
    totalCount.value = allTransactions.length;
    paidCount.value = success;
    pendingCount.value = pending;
    monthlyRevenue.value = monthlyRev;
  }

  void applyFilters() {
    final now = DateTime.now();
    filteredTransactions.value = allTransactions.where((tx) {
      // 1. Search Query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final match = tx.id.toLowerCase().contains(query) ||
            tx.namaUser.toLowerCase().contains(query) ||
            tx.deskripsi.toLowerCase().contains(query);
        if (!match) return false;
      }

      // 2. Status
      if (selectedStatus.value != 'Semua') {
        if (tx.status.toLowerCase() != selectedStatus.value.toLowerCase()) {
          return false;
        }
      }

      // 3. Category
      if (selectedCategory.value != 'Semua') {
        final Map<String, String> catMap = {
          'Doula': 'doula',
          'Obat': 'obat',
          'Tema': 'tema',
          'Diary': 'diary_premium',
        };
        final target = catMap[selectedCategory.value] ?? selectedCategory.value.toLowerCase();
        if (tx.jenisLayanan != target) return false;
      }

      // 4. Date Filter
      if (selectedDateFilter.value != 'Semua') {
        final diff = now.difference(tx.createdAt);
        if (selectedDateFilter.value == 'Hari Ini') {
          if (tx.createdAt.year != now.year ||
              tx.createdAt.month != now.month ||
              tx.createdAt.day != now.day) {
            return false;
          }
        } else if (selectedDateFilter.value == 'Minggu Ini') {
          if (diff.inDays > 7) return false;
        } else if (selectedDateFilter.value == 'Bulan Ini') {
          if (tx.createdAt.year != now.year || tx.createdAt.month != now.month) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  Future<void> verifyTransaction(String id) async {
    try {
      await _paymentService.updateStatus(id, 'paid');
      Get.snackbar(
        'Transaksi Terverifikasi',
        'Pembayaran untuk transaksi $id berhasil dikonfirmasi.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Verifikasi',
        'Terjadi kesalahan saat mengupdate status transaksi.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> cancelTransaction(String id) async {
    try {
      await _paymentService.updateStatus(id, 'cancelled');
      Get.snackbar(
        'Transaksi Dibatalkan',
        'Transaksi $id berhasil dibatalkan.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Membatalkan',
        'Terjadi kesalahan saat membatalkan transaksi.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> logoutAdmin() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> exportToCSV() async {
    try {
      final List<List<dynamic>> rows = [];
      rows.add([
        'ID Transaksi',
        'Tanggal',
        'Nama Pengguna',
        'Jenis Layanan',
        'Deskripsi',
        'Nominal',
        'Metode Pembayaran',
        'Status'
      ]);

      for (var tx in filteredTransactions) {
        rows.add([
          tx.id,
          DateFormat('yyyy-MM-dd HH:mm').format(tx.createdAt),
          tx.namaUser,
          tx.jenisLayanan,
          tx.deskripsi,
          tx.nominal,
          tx.metodePembayaran,
          tx.status
        ]);
      }

      final csvContent = const ListToCsvConverter(fieldDelimiter: ',').convert(rows);
      final bytes = utf8.encode(csvContent);

      final String filename = 'Momsie_Sales_Report_${DateTime.now().millisecondsSinceEpoch}.csv';
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename: filename,
        mimeType: 'text/csv',
      );
      Get.snackbar(
        'Ekspor Berhasil',
        'Laporan CSV berhasil diunduh.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Ekspor',
        'Gagal mengekspor laporan CSV: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> exportToPDF() async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

      int totalNominalFiltered = 0;
      int pendingCountFiltered = 0;
      int paidCountFiltered = 0;
      for (var tx in filteredTransactions) {
        if (tx.status == 'paid') {
          totalNominalFiltered += tx.nominal;
          paidCountFiltered++;
        } else if (tx.status == 'pending') {
          pendingCountFiltered++;
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('MOMSIE SALES REPORT',
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#ff6972'))),
                        pw.Text('Laporan Transaksi dan Penjualan Aplikasi Momsie',
                            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Tanggal Cetak:', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(dateFormat.format(now),
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Text('Ringkasan Laporan (Data Terfilter)',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildPdfKpiCard('Total Penjualan', currencyFormat.format(totalNominalFiltered)),
                  _buildPdfKpiCard('Paid Transaksi', '$paidCountFiltered'),
                  _buildPdfKpiCard('Pending Transaksi', '$pendingCountFiltered'),
                  _buildPdfKpiCard('Jumlah Item', '${filteredTransactions.length}'),
                ],
              ),
              pw.SizedBox(height: 24),

              pw.Text('Rincian Transaksi',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2.5),
                  2: const pw.FlexColumnWidth(2.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(2),
                  5: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _buildPdfTableCell('ID Transaksi', isHeader: true),
                      _buildPdfTableCell('Tanggal', isHeader: true),
                      _buildPdfTableCell('Pengguna', isHeader: true),
                      _buildPdfTableCell('Layanan', isHeader: true),
                      _buildPdfTableCell('Nominal', isHeader: true),
                      _buildPdfTableCell('Status', isHeader: true),
                    ],
                  ),
                  ...filteredTransactions.map((tx) {
                    return pw.TableRow(
                      children: [
                        _buildPdfTableCell(tx.id),
                        _buildPdfTableCell(dateFormat.format(tx.createdAt)),
                        _buildPdfTableCell(tx.namaUser),
                        _buildPdfTableCell(tx.jenisLayanan.toUpperCase()),
                        _buildPdfTableCell(currencyFormat.format(tx.nominal)),
                        _buildPdfTableCell(tx.status.toUpperCase()),
                      ],
                    );
                  }),
                ],
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      final String filename = 'Momsie_Sales_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename: filename,
        mimeType: 'application/pdf',
      );
      Get.snackbar(
        'Ekspor Berhasil',
        'Laporan PDF berhasil diunduh.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Ekspor',
        'Gagal mengekspor laporan PDF: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  pw.Widget _buildPdfKpiCard(String label, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
