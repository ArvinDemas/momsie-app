import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAkunPage extends StatelessWidget {
  const UserAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const AccountTopBar(),
        const SizedBox(height: 75),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                title: "My Profile",
                icon: Icons.person,
                onTap: () => Get.toNamed('/user-data-diri'),
              ),
              MenuContainer(
                title: "My Progress",
                icon: Icons.done_rounded,
                onTap: () => Get.toNamed('/user-progress'),
              ),
              MenuContainer(
                title: "Pengaturan",
                icon: Icons.settings,
                onTap: () => Get.toNamed('/user-settings'),
              ),
              MenuContainer(
                title: "Hubungi Kami",
                icon: Icons.call,
                onTap: () => Get.toNamed('/user-hubungi'),
              ),
              MenuContainer(
                title: "My Doula",
                icon: Icons.abc,
                image: "small-logo.png",
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      descText: "Masuk Ke Halaman Doula ?",
                      onTap: () {
                        Get.offAllNamed('/mitra');
                      },
                    );
                  },
                ),
              ),
              MenuContainer(
                title: "Keluar",
                icon: Icons.logout,
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      descText: "Keluar Dari Akun ?",
                      onTap: () {
                        Get.offAllNamed('/login');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
