import 'package:douce/features/user/kesehatan/booking_doula_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmBookingPage extends StatelessWidget {
  const ConfirmBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingDoulaController controller =
        Get.find<BookingDoulaController>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
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
                const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    fontSize: 24,
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tanggal",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Text(
                    "Ubah",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: ColorDouce.douceBase,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Text(
                  "${controller.selectedTanggal.value} ${controller.selectedDay} | ${controller.selectedJam.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Layanan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Text(
                    "Ubah",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.task,
                  color: ColorDouce.douceBase,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Text(
                  controller.selectedLayanan.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedLayanan.value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Rp ${controller.harga.value}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Biaya Admin",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Rp 2000",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp ${controller.harga.value + 2000}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorDouce.douceBase,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                controller.createBooking();
                showCustomDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorDouce.douceBase,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Booking",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          isSuccess: true,
          descText:
              "Pembuatan Booking Telah Berhasil, Silahkan Lakukan Pembayaran dan Tunggu Konfirmasi dari Doula",
          destination: '/chat-page',
          onTap: () {
            Get.offAllNamed('/user');
          },
        );
      },
    );
  }
}
