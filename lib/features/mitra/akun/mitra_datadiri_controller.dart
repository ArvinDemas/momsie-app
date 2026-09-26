import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MitraDataDiriController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController biografiController = TextEditingController();
  final RxString downloadUrl = ''.obs;
  final Rx<File?> currentImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    final userController = Get.find<UserController>();
    nameController.text = userController.doulaUsername.value.isNotEmpty
        ? userController.doulaUsername.value
        : userController.username.value;
    nikController.text = userController.doulaNIK.value;
    alamatController.text = userController.doulaAlamat.value;
    biografiController.text = userController.doulaBiografi.value;
  }

  Future<void> updateDoula() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    UserController userController = Get.find<UserController>();

    if (currentImage.value != null) {
      try {
        var uploadTask = await storage
            .ref('mitra/${userController.uid.value}/profile.jpg')
            .putFile(currentImage.value!);

        downloadUrl.value = await uploadTask.ref.getDownloadURL();
      } catch (e) {
        debugPrint('Error uploading mitra profile image: $e');
      }
    }

    final newName = nameController.value.text.trim();
    if (newName.isNotEmpty) {
      await userController.updateUsername(newName);
    }

    final targetUid = userController.uid.value;
    if (targetUid.isNotEmpty) {
      try {
        await firestore.collection('mitra').doc(targetUid).set({
          'name': newName,
          'alamat': alamatController.value.text,
          'biografi': biografiController.value.text,
          'image': downloadUrl.value.isEmpty
              ? userController.doulaImage.value
              : downloadUrl.value,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error saving mitra to firestore: $e');
      }
    }

    userController.updateMitra(
      newName,
      alamatController.value.text,
      biografiController.value.text,
      downloadUrl.value.isEmpty
          ? userController.doulaImage.value
          : downloadUrl.value,
    );

    Get.back();
    Get.snackbar(
      'Profil Berhasil Disimpan',
      'Data diri mitra berhasil diperbarui',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    nikController.dispose();
    alamatController.dispose();
    biografiController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      currentImage.value = File(image.path);
    }
  }
}
