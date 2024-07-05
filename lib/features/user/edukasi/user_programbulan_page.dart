import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProgramBulanPage extends StatelessWidget {
  const UserProgramBulanPage({super.key});

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
                  "Bulan Ke - 1",
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
            const SizedBox(height: 30),
            bulanContainer(),
            const SizedBox(height: 20),
            bulanContainer(),
            const SizedBox(height: 20),
            bulanContainer(),
            const SizedBox(height: 20),
            bulanContainer(),
          ],
        ),
      ),
    );
  }

  Widget bulanContainer() {
    return InkWell(
      onTap: () => Get.toNamed('/user-program-minggu'),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorDouce.kindaRed,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Minggu Ke - 1",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Pengenalan Yoga Prenetal",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/yoga.png",
                  width: 75,
                  height: 75,
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.5,
              color: ColorDouce.douceBase,
              minHeight: 5,
            ),
          ],
        ),
      ),
    );
  }
}
