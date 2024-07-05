import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProgressPage extends StatelessWidget {
  const UserProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: ListView(
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
                    "Progress Saya",
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
              MenuContainer(
                title: "Program Kehailan",
                icon: Icons.abc,
                onTap: () => Get.toNamed('/user-program'),
              ),
              MenuContainer(
                title: "Riwayat Konsultasi",
                icon: Icons.abc,
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Konsultasi Doula",
                  },
                ),
              ),
              MenuContainer(
                title: "Riwayat Layanan Kesehatan",
                icon: Icons.abc,
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Layanan Kesehatan",
                  },
                ),
              ),
              MenuContainer(
                title: "Riwayat Artikel",
                icon: Icons.abc,
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Artikel",
                  },
                ),
              ),
              MenuContainer(
                title: "Disimpan",
                icon: Icons.abc,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
