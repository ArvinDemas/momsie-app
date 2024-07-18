import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingAkunPage extends StatelessWidget {
  const UserSettingAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final UserSettingAkunController controller =
        Get.put(UserSettingAkunController());

    controller.nameController.value.text = userController.username.value;
    controller.emailController.value.text = userController.email.value;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          AccountTopBar(
            isEditPage: true,
            isBackPage: true,
            onTap: () {
              controller.pickImage();
            },
            additionalImage: controller.currentImage,
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                editTextField(
                  controller.nameController.value,
                  "Nama Lengkap",
                  true,
                ),
                const SizedBox(height: 30),
                editTextField(
                  controller.emailController.value,
                  "Email",
                  false,
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    controller.updateUser();
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
  final RxString downloadUrl = ''.obs;
  final Rx<File?> currentImage = Rx<File?>(null);

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;

  Future<void> updateUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    UserController userController = Get.find<UserController>();

    if (currentImage.value != null) {
      var uploadTask = await storage
          .ref('user/${userController.uid.value}/profile.jpg')
          .putFile(currentImage.value!);

      downloadUrl.value = await uploadTask.ref.getDownloadURL();
    }

    await firestore.collection('user').doc(userController.uid.value).update({
      'username': nameController.value.text,
      'image': downloadUrl.value,
    });

    userController.updateUser(
      nameController.value.text,
      userController.isDoula.value,
      downloadUrl.value.isEmpty
          ? userController.image.value
          : downloadUrl.value,
    );

    Get.back();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      currentImage.value = File(image.path);
    }
  }
}
