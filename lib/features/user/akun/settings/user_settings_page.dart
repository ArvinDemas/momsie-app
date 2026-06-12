import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
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
                    "Pengaturan",
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
                title: "Tema Aplikasi",
                icon: Icons.palette_outlined,
                onTap: () => Get.toNamed('/theme-picker'),
              ),
              MenuContainer(
                title: "Akun",
                icon: Icons.person,
                onTap: () => Get.toNamed('/user-setting-akun'),
              ),
              MenuContainer(
                title: "Notifikasi",
                icon: Icons.notifications,
                onTap: () => Get.toNamed('/user-setting-notifikasi'),
              ),
              MenuContainer(
                title: "Bahasa",
                icon: Icons.language,
                onTap: () => Get.toNamed('/user-setting-bahasa'),
              ),
              MenuContainer(
                title: "Bantuan",
                icon: Icons.help,
                onTap: () => Get.toNamed('/user-bantuan'),
              ),
              MenuContainer(
                title: "Tentang Doula",
                icon: Icons.info,
                onTap: () => Get.toNamed('/user-tentang-doula'),
              ),
              MenuContainer(
                title: "Kebijakan Privasi",
                icon: Icons.privacy_tip,
                onTap: () => Get.toNamed('/user-kebijakan-privasi'),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}
