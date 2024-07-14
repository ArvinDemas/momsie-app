import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSettingAkunPage extends StatelessWidget {
  const UserSettingAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final UserSettingAkunController controller =
        Get.put(UserSettingAkunController());

    final Rx<TextEditingController> nameController =
        TextEditingController().obs;
    final Rx<TextEditingController> emailController =
        TextEditingController().obs;

    nameController.value.text = userController.username.value;
    emailController.value.text = userController.email.value;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const AccountTopBar(
            isEditPage: true,
            isBackPage: true,
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                editTextField(
                  nameController.value,
                  "Nama Lengkap",
                  true,
                ),
                const SizedBox(height: 30),
                editTextField(
                  emailController.value,
                  "Email",
                  false,
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    controller.updateData(
                      userController.uid.value,
                      nameController.value.text,
                    );
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
          )
        ],
      ),
    );
  }

  Widget editTextField(
    TextEditingController controller,
    String hintText,
    bool isEnable,
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
    );
  }
}

class UserSettingAkunController extends GetxController {
  Future<void> updateData(String uid, String username) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('user').doc(uid).update({
        'username': username,
      });
      UserController userController = Get.find<UserController>();
      userController.updateUser(username);
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Something Went Wrong");
    }
  }
}
