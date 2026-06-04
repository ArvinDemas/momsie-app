import 'package:douce/features/mitra/akun/mitra_datadiri_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class MitraDataDiriPage extends StatelessWidget {
  const MitraDataDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final MitraDataDiriController controller =
        Get.put(MitraDataDiriController());

    controller.nameController.value.text = userController.doulaUsername.value;
    controller.nikController.value.text = userController.doulaNIK.value;
    controller.alamatController.value.text = userController.doulaAlamat.value;
    controller.biografiController.value.text =
        userController.doulaBiografi.value;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          ListView(
        padding: const EdgeInsets.all(0),
        children: [
          AccountTopBar(
            isEditPage: true,
            isBackPage: true,
            isDoula: true,
            onTap: () {
              controller.pickImage();
            },
            additionalImage: controller.currentImage,
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Column(
                children: [
                  editTextField(
                    controller.nameController.value,
                    "Nama Lengkap",
                    true,
                    1,
                  ),
                  const SizedBox(height: 30),
                  editTextField(
                    controller.nikController.value,
                    "NIK",
                    false,
                    1,
                  ),
                  const SizedBox(height: 30),
                  editTextField(
                      controller.alamatController.value, "Alamat", true, 1),
                  const SizedBox(height: 30),
                  editTextField(
                      controller.biografiController.value, "Biografi", true, 5),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      controller.updateDoula();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: const Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }

  Widget editTextField(
    TextEditingController controller,
    String hintText,
    bool isEnable,
    int lineLimit,
  ) {
    return TextField(
      controller: controller,
      enabled: isEnable,
      style: isEnable
          ? const TextStyle(color: Colors.black)
          : const TextStyle(color: Colors.black54),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      maxLines: lineLimit,
    );
  }
}
