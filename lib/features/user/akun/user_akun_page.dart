import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAkunPage extends StatelessWidget {
  const UserAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const AccountTopBar(),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Obx(
                () => Text(
                  userController.username.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                        bool isMitra = true;
                        if (isMitra) {
                          Get.offAllNamed('/mitra');
                          // ignore: dead_code
                        } else {
                          Get.offNamed('/mitra-register');
                        }
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
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
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
