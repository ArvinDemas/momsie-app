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

class MitraPekerjaanPage extends StatelessWidget {
  const MitraPekerjaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraPekerjaanController controller = Get.find<MitraPekerjaanController>();

    if (controller.isAnastasiaUser && controller.activeBookings.isEmpty && controller.pendingBookings.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.applyAnastasiaDemo();
      });
    }

    return BasePage(
      isDoula: true,
      childWidget: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Header Title & Subtitle (Ikut scroll ke atas saat list di-scroll)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daftar Pekerjaan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kelola pekerjaan aktif dan pantau riwayat pekerjaan selesai",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            // Sticky Compact TabBar (Menempel ramping di paling atas saat scroll)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    indicator: BoxDecoration(
                      color: ColorDouce.douceBase,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorDouce.douceBase.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppSemanticColors.textSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Pekerjaan Masuk"),
                            const SizedBox(width: 6),
                            Obx(() {
                              final count = controller.pendingBookings.length + controller.activeBookings.length;
                              if (count == 0) return const SizedBox();
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Riwayat Selesai"),
                            const SizedBox(width: 6),
                            Obx(() {
                              final count = controller.completedBookings.length;
                              if (count == 0) return const SizedBox();
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // TAB 1: Pekerjaan Masuk & Sedang Berjalan
              _PekerjaanMasukTab(controller: controller),

              // TAB 2: Riwayat Pekerjaan Selesai
              _RiwayatPekerjaanTab(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIVER TAB BAR DELEGATE
// ─────────────────────────────────────────────────────────────────────────────
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverTabBarDelegate(this.child);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: child,
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1: PEKERJAAN MASUK & SEDANG BERJALAN
// ─────────────────────────────────────────────────────────────────────────────
class _PekerjaanMasukTab extends StatelessWidget {
  final MitraPekerjaanController controller;
  const _PekerjaanMasukTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        // Section: Pekerjaan Masuk / Baru
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Pekerjaan Masuk",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppSemanticColors.textDarkSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.pendingBookings.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade500, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Belum ada pekerjaan baru yang masuk",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.pendingBookings
                      .map((pesanan) => _PendingJobCard(
                            pesanan: pesanan,
                            controller: controller,
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),

        // Section: Sedang Berjalan
        const Text(
          "Sedang Berjalan",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppSemanticColors.textDarkSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.activeBookings.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_outline, color: Colors.grey.shade500, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Tidak ada pekerjaan yang sedang berjalan",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.activeBookings
                      .map((pesanan) => _ActiveJobCard(
                            pesanan: pesanan,
                            controller: controller,
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2: RIWAYAT PEKERJAAN SELESAI
// ─────────────────────────────────────────────────────────────────────────────
class _RiwayatPekerjaanTab extends StatelessWidget {
  final MitraPekerjaanController controller;
  const _RiwayatPekerjaanTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        Row(
          children: [
            const Text(
              "Riwayat Pekerjaan Selesai",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppSemanticColors.textDarkSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => controller.completedBookings.isEmpty
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.completedBookings.length}',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
          () => controller.completedBookings.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
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
                      Icon(Icons.history, size: 54, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      const Text(
                        "Belum Ada Riwayat Selesai",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Pekerjaan yang telah diselesaikan (check out) akan tersimpan di sini.",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.completedBookings
                      .map((pesanan) => _CompletedJobCard(
                            pesanan: pesanan,
                            controller: controller,
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARDS & ACTIONS
// ─────────────────────────────────────────────────────────────────────────────

class _PendingJobCard extends StatelessWidget {
  final BookingModel pesanan;
  final MitraPekerjaanController controller;
  const _PendingJobCard({required this.pesanan, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.pendingBookings.firstWhereOrNull(
            (b) => b.id == pesanan.id,
          ) ??
          pesanan;
      final bool isConfirmed = current.status == 'confirmed';

      return GestureDetector(
        onTap: () => BookingDetailSheet.show(context, current, controller: controller),
        child: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: isConfirmed
                ? Border.all(color: ColorDouce.douceBase, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 42,
                    color: ColorDouce.douceBase,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.layanan,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          current.namaUser.isNotEmpty ? current.namaUser : 'Client Momsie',
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        if (isConfirmed)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorDouce.douceBase.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sudah Diklaim — Siap Mulai',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: ColorDouce.douceBase,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('Detail', style: TextStyle(fontSize: 12, color: ColorDouce.douceBase, fontWeight: FontWeight.bold)),
                      Icon(Icons.chevron_right, color: ColorDouce.douceBase),
                    ],
                  ),
                ],
              ),
              const Divider(height: 18, thickness: 0.5, color: Colors.black12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.date_range, size: 16),
                        const SizedBox(width: 6),
                        Text('${current.tanggal} (${current.day})',
                            style: const TextStyle(fontSize: 13)),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.wallet, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Rp ${NumberFormat('#,###', 'id_ID').format(current.doulaEarnings > 0 ? current.doulaEarnings : (current.hargaLayanan * 0.85).round())}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 6),
                        Text(current.jam, style: const TextStyle(fontSize: 13)),
                      ]),
                      const SizedBox(height: 6),
                      const Row(children: [
                        Icon(Icons.timelapse, size: 16),
                        SizedBox(width: 6),
                        Text('1 Jam', style: TextStyle(fontSize: 13)),
                      ]),
                      Obx(() {
                        final slots = controller.getSlotsForDate(current.tanggal);
                        final slot = slots.firstWhereOrNull((s) => s.jam == current.jam);
                        if (slot == null || slot.capacity <= 1) return const SizedBox.shrink();
                        final utilizationColor = slot.status == 'full'
                            ? Colors.red.shade700
                            : (slot.status == 'partial' ? Colors.orange.shade700 : Colors.grey);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.people_outline, size: 14, color: utilizationColor),
                              const SizedBox(width: 4),
                              Text(
                                '${slot.bookedCount}/${slot.capacity} tempat',
                                style: TextStyle(fontSize: 11, color: utilizationColor, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Tombol aksi utama
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed('/chat-page', arguments: {
                          'user': current.userId,
                          'doula': current.doulaUid,
                          'isDoula': true,
                        });
                      },
                      icon: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: ColorDouce.douceBase),
                      label: Text('Chat Client', style: TextStyle(color: ColorDouce.douceBase, fontSize: 13, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: ColorDouce.douceBase),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isConfirmed) {
                          controller.startJob(current);
                        } else {
                          controller.klaimPekerjaan(current);
                        }
                      },
                      icon: Icon(
                        isConfirmed ? Icons.play_arrow_rounded : Icons.assignment_turned_in_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text(
                        isConfirmed ? 'Mulai Kerja' : 'Klaim Kerja',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isConfirmed ? Colors.orange.shade700 : ColorDouce.douceBase,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    });
  }
}

class _ActiveJobCard extends StatelessWidget {
  final BookingModel pesanan;
  final MitraPekerjaanController controller;
  const _ActiveJobCard({required this.pesanan, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BookingDetailSheet.show(context, pesanan, controller: controller),
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.orange.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_information_outlined,
                    size: 42, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pesanan.layanan,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pesanan.namaUser.isNotEmpty ? pesanan.namaUser : 'Client Momsie',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🟠 Sedang Berjalan',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Detail', style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Colors.orange.shade800),
                  ],
                ),
              ],
            ),
            const Divider(height: 18, thickness: 0.5, color: Colors.black12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.date_range, size: 16),
                    const SizedBox(width: 6),
                    Text('${pesanan.tanggal} (${pesanan.day})',
                        style: const TextStyle(fontSize: 13)),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.wallet, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Rp ${NumberFormat('#,###', 'id_ID').format(pesanan.doulaEarnings > 0 ? pesanan.doulaEarnings : (pesanan.hargaLayanan * 0.85).round())}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ]),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 6),
                    Text(pesanan.jam, style: const TextStyle(fontSize: 13)),
                  ]),
                  const SizedBox(height: 6),
                  const Row(children: [
                    Icon(Icons.timelapse, size: 16),
                    SizedBox(width: 6),
                    Text('1 Jam', style: TextStyle(fontSize: 13)),
                  ]),
                  Obx(() {
                    final slots = controller.getSlotsForDate(pesanan.tanggal);
                    final slot = slots.firstWhereOrNull((s) => s.jam == pesanan.jam);
                    if (slot == null || slot.capacity <= 1) return const SizedBox.shrink();
                    final utilizationColor = slot.status == 'full'
                        ? Colors.red.shade700
                        : (slot.status == 'partial' ? Colors.orange.shade700 : Colors.grey);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline, size: 14, color: utilizationColor),
                          const SizedBox(width: 4),
                          Text(
                            '${slot.bookedCount}/${slot.capacity} tempat',
                            style: TextStyle(fontSize: 11, color: utilizationColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }),
                ]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed('/chat-page', arguments: {
                        'user': pesanan.userId,
                        'doula': pesanan.doulaUid,
                        'isDoula': true,
                      });
                    },
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: ColorDouce.douceBase),
                    label: Text('Chat Client', style: TextStyle(color: ColorDouce.douceBase, fontSize: 13, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorDouce.douceBase),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ConfirmDialog(
                          descText:
                              'Apakah Anda yakin telah selesai memberikan pelayanan dan ingin melakukan Check Out?',
                          onTap: () => controller.checkOut(pesanan),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                    label: const Text(
                      'Check Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

class _CompletedJobCard extends StatelessWidget {
  final BookingModel pesanan;
  final MitraPekerjaanController controller;
  const _CompletedJobCard({required this.pesanan, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BookingDetailSheet.show(context, pesanan, controller: null),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    size: 40, color: Colors.green.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pesanan.layanan,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pesanan.namaUser.isNotEmpty
                            ? pesanan.namaUser
                            : 'Client Momsie',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const Divider(height: 18, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.date_range, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('${pesanan.tanggal} (${pesanan.day})',
                      style: const TextStyle(fontSize: 13)),
                ]),
                Row(children: [
                  const Icon(Icons.wallet, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(pesanan.doulaEarnings > 0 ? pesanan.doulaEarnings : (pesanan.hargaLayanan * 0.85).round())}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
