import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProgramMingguPage extends StatelessWidget {
  const UserProgramMingguPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
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
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const Text(
                  "Minggu Ke - 1",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Pengenalan Yoga Prenetal",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            gerakanContainer(),
            const SizedBox(height: 10),
            gerakanContainer(),
            const SizedBox(height: 10),
            gerakanContainer(),
            const SizedBox(height: 10),
            gerakanContainer(),
            const SizedBox(height: 10),
            gerakanContainer(),
            const SizedBox(height: 10),
            gerakanContainer(),
          ],
        ),
      ),
    );
  }

  Widget gerakanContainer() {
    return InkWell(
      onTap: () => Get.toNamed("/user-detail-gerakan"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Pose Sukhsana + Pernapasan Dalam",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
