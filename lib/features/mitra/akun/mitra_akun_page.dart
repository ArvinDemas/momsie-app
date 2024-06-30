import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/account_topbar.dart';
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
              menuContainer(
                "Data Diri",
                Icons.person,
                () => Get.toNamed("mitra-data-diri"),
              ),
              menuContainer(
                "Riwayat Kerja",
                Icons.done_rounded,
                () => Get.toNamed("mitra-riwayat"),
              ),
              menuContainer(
                "Pendapatan",
                Icons.settings,
                () => Get.toNamed("mitra-pendapatan"),
              ),
              menuContainer(
                "Kembali",
                Icons.logout,
                () => {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuContainer(String title, IconData icon, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: ColorDouce.douceBase,
              size: 32,
            ),
            const SizedBox(width: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
