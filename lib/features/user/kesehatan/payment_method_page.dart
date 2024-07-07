import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "Metode Pembayaran",
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
            const SizedBox(height: 20),
            const Text("Masih mikir ni gimana payment nya"),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => showCustomDialog(context),
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
              "Pembayaran anda telah berhasil. Sekarang anda sudah bisa konsultasi dengan dokter",
          destination: '/chat-page',
          onTap: () {
            Get.offAllNamed('/user');
            Get.toNamed('/detail-doula');
            Get.toNamed('/chat-page');
          },
        );
      },
    );
  }
}
