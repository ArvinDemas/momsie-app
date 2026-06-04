import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class UserDataDiriPage extends StatelessWidget {
  const UserDataDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    final Rx<TextEditingController> nameController =
        TextEditingController().obs;
    final Rx<TextEditingController> emailController =
        TextEditingController().obs;

    nameController.value.text = userController.username.value;
    emailController.value.text = userController.email.value;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const AccountTopBar(
            isBackPage: true,
            isEditPage: true,
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Column(
                children: [
                  editTextField(nameController.value, "Nama Lengkap"),
                  const SizedBox(height: 30),
                  editTextField(emailController.value, "Email"),
                ],
              ),
            ),
          )
        ],
      ),
        ],
      ),
    );
  }

  Widget editTextField(TextEditingController controller, String hintText) {
    return TextField(
      enabled: false,
      controller: controller,
      style: const TextStyle(
        color: Colors.black54,
      ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
