import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:douce/shared/widget/menu_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MitraAkunPage extends StatelessWidget {
  const MitraAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F5),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 0, bottom: 60),
          children: [
            const AccountTopBar(isDoula: true, isBackPage: true),
            const SizedBox(height: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Get.toNamed("/mitra-data-diri"),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () {
                              String name = userController.doulaUsername.value;
                              if (name.isEmpty) {
                                name = userController.username.value;
                              }
                              if (name.isEmpty) {
                                name = 'Mitra Doula';
                              }
                              return Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppSemanticColors.textDarkSecondary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.edit_outlined, size: 20, color: ColorDouce.douceBase),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      userController.email.value.isNotEmpty
                          ? userController.email.value
                          : 'doula@momsie.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  MenuContainer(
                    title: "Data Diri Profil",
                    icon: Icons.badge_outlined,
                    onTap: () => Get.toNamed("/mitra-data-diri"),
                  ),
                  MenuContainer(
                    title: "Kelola Jadwal Kerja",
                    icon: Icons.edit_calendar_outlined,
                    onTap: () => Get.toNamed("/mitra-atur-jadwal"),
                  ),
                  MenuContainer(
                    title: "Pendapatan & Dompet",
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => Get.toNamed("/mitra-pendapatan"),
                  ),
                  MenuContainer(
                    title: "Switch ke Mode User / Bunda",
                    icon: Icons.swap_horiz_rounded,
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          descText: "Pindah ke Mode User / Bunda?",
                          onTap: () async {
                            final UserController userController =
                                Get.find<UserController>();
                            userController.isDoula.value = false;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('last_active_mode', 'user');
                            Get.offAllNamed('/user');
                          },
                        );
                      },
                    ),
                  ),
                  MenuContainer(
                    title: "Keluar Akun",
                    icon: Icons.logout_rounded,
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            "Keluar Akun",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Apakah Anda yakin ingin keluar dari akun Doula?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back();
                                await GoogleSignIn().signOut();
                                await GoogleSignIn().signIn();
                                Get.offAllNamed('/login');
                              },
                              child: Text(
                                "Switch Account",
                                style: TextStyle(color: ColorDouce.lightPink),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Get.back();
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                Get.offAllNamed('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorDouce.douceBase,
                              ),
                              child: const Text(
                                "Keluar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
