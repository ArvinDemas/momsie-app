import 'package:cloud_firestore/cloud_firestore.dart';
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
                title: "Pengaturan",
                icon: Icons.settings,
                onTap: () => Get.toNamed('/user-settings'),
              ),
              MenuContainer(
                title: "Pesanan Aktif",
                icon: Icons.online_prediction_sharp,
                onTap: () => Get.toNamed('/user-pesanan'),
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
                      onTap: () async {
                        final FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        final UserController userController =
                            Get.find<UserController>();

                        final DocumentSnapshot checkRegister = await firestore
                            .collection("register")
                            .doc(userController.uid.value)
                            .get();

                        final DocumentSnapshot checkUser = await firestore
                            .collection("user")
                            .doc(userController.uid.value)
                            .get();

                        Map<String, dynamic>? userData =
                            checkUser.data() as Map<String, dynamic>?;

                        userController.updateUser(
                          userData?['username'],
                          userData?['isDoula'],
                          userData?['image'],
                        );

                        if (checkRegister.exists) {
                          final bool registerConfirmed =
                              checkRegister['registerConfirmed'];
                          final int payment = checkRegister['payment'];
                          if (!registerConfirmed) {
                            Get.offNamed('/confirm-register', arguments: {
                              'payment': payment,
                            });
                            return;
                          }
                        }

                        if (userController.isDoula.value) {
                          final DocumentSnapshot mitraData = await firestore
                              .collection('mitra')
                              .doc(userController.uid.value)
                              .get();
                          userController.setDoula(
                            mitraData['name'],
                            mitraData['alamat'],
                            mitraData['kotaProvinsi'],
                            mitraData['biografi'],
                            mitraData['image'],
                            mitraData['jenisKelamin'],
                            mitraData['nik'],
                          );

                          Get.offAllNamed('/mitra');
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
