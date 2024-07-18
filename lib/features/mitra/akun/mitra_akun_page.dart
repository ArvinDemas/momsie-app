import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraAkunPage extends StatelessWidget {
  const MitraAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const AccountTopBar(isDoula: true),
        const SizedBox(height: 75),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Obx(
                () => Text(
                  userController.doulaUsername.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MenuContainer(
                title: "Data Diri",
                icon: Icons.person,
                onTap: () => Get.toNamed("/mitra-data-diri"),
              ),
              MenuContainer(
                title: "Pendapatan",
                icon: Icons.settings,
                onTap: () => Get.toNamed("/mitra-pendapatan"),
              ),
              MenuContainer(
                title: "Kembali",
                icon: Icons.logout,
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      descText: "Kembali Ke Halaman User ?",
                      onTap: () {
                        Get.offAllNamed('/user');
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
