import 'package:douce/features/user/pesanan/user_pesanan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserRiwayatPage extends StatelessWidget {
  const UserRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    String jenisRiwayat = arguments?["jenisRiwayat"] ?? "Konsultasi Doula";

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: Get.back,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ColorDouce.douceBase,
                        ),
                      ),
                      Text(
                        "Riwayat $jenisRiwayat",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.heart_broken_rounded,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildContent(jenisRiwayat)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String jenis) {
    final controller = Get.put(UserPesananController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final allBookings = controller.activeBookings + controller.riwayatBookings;

      if (allBookings.isEmpty) {
        return _buildEmptyState(jenis);
      }

      List<BookingModel> filtered;
      switch (jenis) {
        case "Konsultasi Doula":
          filtered = allBookings.where((b) => b.layanan.contains('Doula') || b.layanan.contains('chat')).toList();
          break;
        case "Layanan Kesehatan":
          filtered = allBookings.where((b) => b.status == 'completed' || b.status == 'cancelled').toList();
          break;
        case "Artikel":
          filtered = [];
          break;
        default:
          filtered = allBookings;
      }

      if (filtered.isEmpty) {
        return _buildEmptyState(jenis);
      }

      return ListView(
        children: filtered.map((b) => _buildBookingCard(b)).toList(),
      );
    });
  }

  Widget _buildEmptyState(String jenis) {
    IconData icon;
    String title;
    String subtitle;

    switch (jenis) {
      case "Konsultasi Doula":
        icon = Icons.chat_outlined;
        title = "Belum Ada Riwayat Konsultasi";
        subtitle = "Konsultasi doula Anda akan muncul di sini setelah melakukan pemesanan.";
        break;
      case "Layanan Kesehatan":
        icon = Icons.local_hospital_outlined;
        title = "Belum Ada Riwayat Layanan";
        subtitle = "Layanan kesehatan yang telah diselesaikan akan ditampilkan di sini.";
        break;
      case "Artikel":
        icon = Icons.article_outlined;
        title = "Belum Ada Artikel";
        subtitle = "Artikel yang Anda baca akan muncul di sini.";
        break;
      default:
        icon = Icons.history_outlined;
        title = "Belum Ada Riwayat";
        subtitle = "Riwayat aktivitas Anda akan muncul di sini.";
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: ColorDouce.douceBase.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
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
        statusText = 'Dikonfirmasi';
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
      case 'expired':
        badgeColor = Colors.deepOrange;
        statusText = 'Kadaluarsa';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = booking.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorDouce.douceBase.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medical_information_outlined, color: ColorDouce.douceBase, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.layanan,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.tanggal} • ${booking.jam}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              statusText,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }
}
