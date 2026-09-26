import 'package:douce/features/user/pesanan/user_pesanan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:douce/shared/widget/payment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPesananPage extends StatelessWidget {
  const UserPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserPesananController controller = Get.put(UserPesananController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const Text(
                  "Pesanan",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      controller.changeSelectedPesanan("Aktif");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: controller.selectedPesanan.value == "Aktif"
                            ? ColorDouce.douceBase
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorDouce.douceBase),
                      ),
                      child: Center(
                        child: Text(
                          "Aktif",
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.selectedPesanan.value == "Aktif"
                                ? Colors.white
                                : ColorDouce.douceBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      controller.changeSelectedPesanan("Riwayat");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: controller.selectedPesanan.value == "Riwayat"
                            ? ColorDouce.douceBase
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorDouce.douceBase),
                      ),
                      child: Center(
                        child: Text(
                          "Riwayat",
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.selectedPesanan.value == "Riwayat"
                                ? Colors.white
                                : ColorDouce.douceBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Obx(
              () => controller.selectedPesanan.value == "Aktif"
                  ? aktifColumn(controller, context)
                  : riwayatColumn(controller, context),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget aktifColumn(UserPesananController controller, BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      }
      final list = controller.activeBookings;
      if (list.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Belum ada pesanan aktif",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }
      return Column(
        children: list.map((b) => _buildBookingCard(b, context)).toList(),
      );
    });
  }

  Widget riwayatColumn(UserPesananController controller, BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      }
      final list = controller.riwayatBookings;
      if (list.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Belum ada riwayat pesanan",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }
      return Column(
        children: list.map((b) => _buildBookingCard(b, context)).toList(),
      );
    });
  }

  Widget _buildBookingCard(BookingModel booking, BuildContext context) {
    Color badgeColor;
    String statusText;

    switch (booking.status) {
      case 'pending':
        badgeColor = Colors.orange;
        statusText = 'Belum Bayar';
        break;
      case 'paid':
        badgeColor = Colors.blue;
        statusText = 'Sudah Bayar';
        break;
      case 'confirmed':
        badgeColor = Colors.teal;
        statusText = 'Dikonfirmasi Doula';
        break;
      case 'ongoing':
        badgeColor = Colors.green;
        statusText = 'Sedang Berjalan';
        break;
      case 'completed':
        badgeColor = Colors.grey;
        statusText = 'Selesai';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        statusText = 'Dibatalkan';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = booking.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
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
              Icon(
                Icons.medical_information_outlined,
                size: 48,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (booking.layanan.isEmpty ||
                              booking.layanan.toLowerCase().contains('arvin') ||
                              booking.layanan.toLowerCase().contains('demas'))
                          ? 'Konsultasi Gentle Birth & Persalinan'
                          : booking.layanan,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (booking.doulaName.isNotEmpty &&
                              !booking.doulaName.toLowerCase().contains('arvin') &&
                              booking.doulaName != 'Mitra Doula')
                          ? booking.doulaName
                          : 'Doula Dewi Sartika, S.Keb',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        '${booking.tanggal} (${booking.day})',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.wallet, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Rp ${booking.totalBayar.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        booking.jam,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (booking.status == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showPaymentSheet(
                        context,
                        jenisLayanan: 'doula',
                        deskripsi: 'Booking Doula – ${booking.layanan}',
                        nominal: booking.totalBayar,
                        booking: booking,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showCancelDialog(booking, context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      "Batal",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (['paid', 'confirmed', 'ongoing'].contains(booking.status)) ...[
            const SizedBox(height: 16),
            _buildStatusActions(booking, context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusActions(BookingModel booking, BuildContext context) {
    final isScheduled = !booking.isOnDemand;
    final hasZoomLink = booking.zoomLink != null && booking.zoomLink!.isNotEmpty;

    final secondaryActions = <Widget>[];

    // Zoom / WhatsApp fallback button (only for scheduled services)
    if (isScheduled) {
      if (hasZoomLink) {
        secondaryActions.add(
          Expanded(
            child: InkWell(
              onTap: () => _launchUrl(booking.zoomLink!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F9D58).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F9D58).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_rounded, size: 16, color: Color(0xFF0F9D58)),
                    SizedBox(width: 6),
                    Text(
                      "Join Zoom",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F9D58),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        secondaryActions.add(
          Expanded(
            child: InkWell(
              onTap: () => _launchUrl('https://wa.me/6281234567890?text=${Uri.encodeComponent('Halo Admin Momsie, saya ${booking.namaUser} ingin bergabung di sesi ${booking.layanan} (Booking ID: ${booking.id}). Mohon infonya. Terima kasih.')}'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent_rounded, size: 16, color: Color(0xFFF59E0B)),
                    SizedBox(width: 6),
                    Text(
                      "Hubungi Admin",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    if (secondaryActions.isNotEmpty) {
      secondaryActions.add(const SizedBox(width: 10));
    }

    // View payment proof button
    secondaryActions.add(
      Expanded(
        child: InkWell(
          onTap: () {
            Get.toNamed('/payment-success', arguments: {
              'transactionId': booking.transactionId.isNotEmpty ? booking.transactionId : booking.id,
              'bookingId': booking.id,
              'nominal': booking.totalBayar,
              'layanan': 'Booking ${booking.doulaName.isNotEmpty ? booking.doulaName : "Doula Dewi Sartika, S.Keb"} – ${booking.layanan.isNotEmpty ? booking.layanan : "Konsultasi Persalinan"}',
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_rounded, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 6),
                const Text(
                  "Bukti Bayar",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      children: [
        // Primary Action: Full-width Chat Konsultasi Doula
        InkWell(
          onTap: () {
            Get.toNamed('/chat-page', arguments: {
              "doula": (booking.doulaUid.isNotEmpty && booking.doulaUid != 'doula_id_1')
                  ? booking.doulaUid
                  : "doula_dewi",
              "user": booking.userId.isNotEmpty ? booking.userId : "user_arvin",
              "isDoula": false,
              "bookingId": booking.id,
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: ColorDouce.douceBase,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorDouce.douceBase.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_rounded, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Mulai Chat Konsultasi",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(children: secondaryActions),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (Get.context != null) {
        Get.snackbar('Error', 'Tidak dapat membuka $url');
      }
    }
  }

  void _showCancelDialog(BookingModel booking, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Batalkan Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Yakin ingin membatalkan "${booking.layanan}" pada ${booking.tanggal} jam ${booking.jam}? Slot akan dikembalikan ke jadwal.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tetap Lanjut"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await PaymentService().updateStatus(booking.id, 'cancelled');
              if (booking.doulaUid.isNotEmpty && booking.tanggal.isNotEmpty && booking.jam.isNotEmpty) {
                await BookingSlotService().decrementBookedCount(
                  doulaId: booking.doulaUid,
                  tanggal: booking.tanggal,
                  time: booking.jam,
                );
              }
              Get.snackbar(
                'Pesanan Dibatalkan',
                'Status pesanan berhasil diubah. Slot telah dikembalikan.',
                backgroundColor: Colors.white,
                colorText: Colors.black87,
                snackPosition: SnackPosition.BOTTOM,
                icon: const Icon(Icons.check_circle, color: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Ya, Batalkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
