import 'package:douce/features/mitra/main_mitra.dart';
import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/booking_detail_sheet.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraBerandaPage extends StatelessWidget {
  const MitraBerandaPage({super.key});

  String _formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final MitraPekerjaanController controller = Get.find<MitraPekerjaanController>();

    return BasePage(
      isDoula: true,
      childWidget: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),

          // Ringkasan Kinerja Mitra (KPI Cards Header)
          Obx(() {
            final int pendingCount = controller.pendingBookings.length;
            final int activeCount = controller.activeBookings.length;
            final int completedCount = controller.completedBookings.length;

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorDouce.douceBase,
                    const Color(0xFFFF7B93),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorDouce.douceBase.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ringkasan Aktivitas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.dashboard_rounded, color: Colors.white70, size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _kpiBadge(
                          label: 'Masuk',
                          val: '$pendingCount',
                          icon: Icons.assignment_late_rounded,
                          bgColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _kpiBadge(
                          label: 'Berjalan',
                          val: '$activeCount',
                          icon: Icons.play_circle_fill_rounded,
                          bgColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _kpiBadge(
                          label: 'Selesai',
                          val: '$completedCount',
                          icon: Icons.check_circle_rounded,
                          bgColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Header Section Pekerjaan Aktif & Dikonfirmasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pekerjaan Aktif & Dikonfirmasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppSemanticColors.textDarkSecondary,
                ),
              ),
              Obx(() {
                final totalActive = controller.pendingBookings.length + controller.activeBookings.length;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalActive Tugas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // List Pekerjaan Aktif & Confirmed
          Obx(() {
            final List<BookingModel> combinedJobs = [
              ...controller.activeBookings,
              ...controller.pendingBookings,
            ];

            if (combinedJobs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.work_outline_rounded, size: 54, color: Colors.pink.shade100),
                    const SizedBox(height: 14),
                    const Text(
                      'Belum Ada Pekerjaan Aktif Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pekerjaan baru yang dikonfirmasi oleh pengguna akan muncul di sini.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.find<MainMitraController>().onItemTapped(1);
                      },
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('Lihat Daftar Pekerjaan Masuk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: combinedJobs.map((job) => jobCard(context, job, controller)).toList(),
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _kpiBadge({
    required String label,
    required String val,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                val,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget jobCard(BuildContext context, BookingModel job, MitraPekerjaanController controller) {
    final bool isOngoing = job.status == 'ongoing';

    return GestureDetector(
      onTap: () => BookingDetailSheet.show(context, job, controller: controller),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isOngoing
              ? Border.all(color: ColorDouce.douceBase, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.medical_information_outlined,
                    size: 32,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.layanan,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.namaUser.isNotEmpty ? job.namaUser : 'Client Momsie',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOngoing ? Colors.orange.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isOngoing ? Colors.orange.shade200 : Colors.green.shade200,
                        ),
                      ),
                      child: Text(
                        isOngoing ? 'Sedang Berjalan' : 'Siap Berjalan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isOngoing ? Colors.orange.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorDouce.douceBase,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: ColorDouce.douceBase,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24, thickness: 0.5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.date_range_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${job.tanggal} (${job.day})',
                      style: TextStyle(fontSize: 13, color: AppSemanticColors.textDarkSecondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      job.jam,
                      style: TextStyle(fontSize: 13, color: AppSemanticColors.textDarkSecondary),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  _formatRupiah(job.doulaEarnings > 0 ? job.doulaEarnings : (job.hargaLayanan * 0.85).round()),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppSemanticColors.textDarkSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed('/chat-page', arguments: {
                        'user': job.userId,
                        'doula': job.doulaUid,
                        'isDoula': true,
                      });
                    },
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: ColorDouce.douceBase),
                    label: Text('Chat Client', style: TextStyle(color: ColorDouce.douceBase, fontSize: 13, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorDouce.douceBase),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isOngoing) {
                        showDialog(
                          context: context,
                          builder: (ctx) => ConfirmDialog(
                            descText: 'Pastikan Anda telah selesai memberikan pelayanan kepada pengguna!',
                            onTap: () {
                              controller.checkOut(job);
                            },
                          ),
                        );
                      } else {
                        controller.startJob(job);
                      }
                    },
                    icon: Icon(isOngoing ? Icons.check_circle_outline_rounded : Icons.play_arrow_rounded, size: 18, color: Colors.white),
                    label: Text(
                      isOngoing ? 'Check Out' : 'Mulai Kerja',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOngoing ? Colors.orange.shade700 : ColorDouce.douceBase,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
