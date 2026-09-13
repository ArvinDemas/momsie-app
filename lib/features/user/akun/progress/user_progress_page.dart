import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserProgressPage extends StatelessWidget {
  const UserProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
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
                title: "Program Kehamilan",
                image: 'kehamilan.png',
                icon: Icons.abc,
                onTap: () => Get.toNamed('/user-program'),
              ),
              MenuContainer(
                title: "Riwayat Konsultasi",
                icon: Icons.abc,
                image: 'konsultasi.png',
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Konsultasi Doula",
                  },
                ),
              ),
              MenuContainer(
                title: "Riwayat Layanan Kesehatan",
                icon: Icons.local_hospital,
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Layanan Kesehatan",
                  },
                ),
              ),
              MenuContainer(
                title: "Riwayat Artikel",
                icon: Icons.notes,
                onTap: () => Get.toNamed(
                  '/user-riwayat',
                  arguments: {
                    "jenisRiwayat": "Artikel",
                  },
                ),
              ),
              MenuContainer(
                title: "Disimpan",
                icon: Icons.bookmark_border,
                onTap: () => _showSavedDialog(context),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }

  void _showSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Bookmark Tersimpan"),
        content: const Text(
          "Fitur bookmark sedang dalam pengembangan. Anda dapat melihat semua pesanan di menu Pesanan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/user-pesanan');
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Lihat Pesanan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
