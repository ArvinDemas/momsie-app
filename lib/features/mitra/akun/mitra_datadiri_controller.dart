import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MitraDataDiriController extends GetxController {
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> nikController = TextEditingController().obs;
  final Rx<TextEditingController> alamatController =
      TextEditingController().obs;
  final Rx<TextEditingController> biografiController =
      TextEditingController().obs;
  final RxString downloadUrl = ''.obs;
  final Rx<File?> currentImage = Rx<File?>(null);

  Future<void> updateDoula() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    UserController userController = Get.find<UserController>();

    if (currentImage.value != null) {
      var uploadTask = await storage
          .ref('mitra/${userController.uid.value}/profile.jpg')
          .putFile(currentImage.value!);

      downloadUrl.value = await uploadTask.ref.getDownloadURL();
    }

    await firestore.collection('mitra').doc(userController.uid.value).update({
      'name': nameController.value.text,
      'alamat': alamatController.value.text,
      'biografi': biografiController.value.text,
      'image': downloadUrl.value.isEmpty
          ? userController.doulaImage.value
          : downloadUrl.value,
    });

    userController.updateMitra(
      nameController.value.text,
      alamatController.value.text,
      biografiController.value.text,
      downloadUrl.value.isEmpty
          ? userController.doulaImage.value
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
