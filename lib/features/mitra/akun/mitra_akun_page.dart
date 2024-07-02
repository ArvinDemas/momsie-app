import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraAkunPage extends StatelessWidget {
  const MitraAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const AccountTopBar(),
        const SizedBox(height: 75),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Text(
                "Miranda",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MenuContainer(
                title: "Data Diri",
                icon: Icons.person,
                onTap: () => Get.toNamed("/mitra-data-diri"),
              ),
              MenuContainer(
                title: "Riwayat Kerja",
                icon: Icons.done_rounded,
                onTap: () => Get.toNamed("/mitra-riwayat"),
              ),
              MenuContainer(
                title: "Pendapatan",
                icon: Icons.settings,
                onTap: () => Get.toNamed("/mitra-pendapatan"),
              ),
              MenuContainer(
                title: "Kembali",
                icon: Icons.logout,
                onTap: () => Get.toNamed("/user"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
