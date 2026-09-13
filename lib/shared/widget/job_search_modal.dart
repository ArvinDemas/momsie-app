import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobSearchModal extends StatefulWidget {
  const JobSearchModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JobSearchModal(),
    );
  }

  @override
  State<JobSearchModal> createState() => _JobSearchModalState();
}

class _JobSearchModalState extends State<JobSearchModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MitraPekerjaanController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Cari Pekerjaan / Pemesan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppSemanticColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            controller: _searchCtrl,
            autofocus: true,
            onChanged: (val) => setState(() => _query = val.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Cari nama pemesan, layanan, atau tanggal...',
              prefixIcon: Icon(Icons.search_rounded, color: ColorDouce.douceBase),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Search Results List
          Expanded(
            child: Obx(() {
              final allJobs = <BookingModel>[
                ...controller.pendingBookings,
                ...controller.activeBookings,
                ...controller.completedBookings,
              ];

              // Deduplicate by ID
              final uniqueJobs = <String, BookingModel>{};
              for (var j in allJobs) {
                uniqueJobs[j.id] = j;
              }
              final jobs = uniqueJobs.values.toList();

              final filtered = _query.isEmpty
                  ? jobs
                  : jobs.where((b) {
                      final name = b.namaUser.toLowerCase();
                      final service = b.layanan.toLowerCase();
                      final date = b.tanggal.toLowerCase();
                      final day = b.day.toLowerCase();
                      final status = b.status.toLowerCase();
                      return name.contains(_query) ||
                          service.contains(_query) ||
                          date.contains(_query) ||
                          day.contains(_query) ||
                          status.contains(_query);
                    }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        _query.isEmpty
                            ? 'Belum ada data pekerjaan'
                            : 'Pekerjaan "$_query" tidak ditemukan',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final item = filtered[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_rounded, color: ColorDouce.douceBase, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaUser.isNotEmpty ? item.namaUser : 'Client Momsie',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.layanan} · ${item.tanggal} (${item.day})',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusBg(item.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusLabel(item.status),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getStatusText(item.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getStatusBg(String status) {
    switch (status) {
      case 'paid':
      case 'confirmed':
        return Colors.blue.shade50;
      case 'ongoing':
        return Colors.orange.shade50;
      case 'completed':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusText(String status) {
    switch (status) {
      case 'paid':
      case 'confirmed':
        return Colors.blue.shade700;
      case 'ongoing':
        return Colors.orange.shade700;
      case 'completed':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending': return 'Menunggu';
      case 'paid': return 'Dibayar';
      case 'confirmed': return 'Diklaim';
      case 'ongoing': return 'Berjalan';
      case 'completed': return 'Selesai';
      default: return status;
    }
  }
}
