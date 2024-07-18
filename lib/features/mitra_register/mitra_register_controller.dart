import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MitraRegisterController extends GetxController {
  final RxInt currentPage = 0.obs;
  final RxString jobSelect = ''.obs;
  final RxString educationSelect = ''.obs;
  final RxString religionSelect = ''.obs;
  final RxString genderSelect = ''.obs;

  final Rx<File?> currentImage = Rx<File?>(null);

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> nikController = TextEditingController().obs;
  final Rx<TextEditingController> nohpController = TextEditingController().obs;
  final Rx<TextEditingController> kotaProvinsiController =
      TextEditingController().obs;
  final Rx<TextEditingController> biografiController =
      TextEditingController().obs;

  void changePage(int page) {
    currentPage.value = page;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (currentImage.value != null) {
        currentImage.value = null;
      }
      currentImage.value = File(pickedFile.path);
    }
  }

  Future<void> submitRegister() async {
    try {
      if (jobSelect.value.isEmpty ||
          educationSelect.value.isEmpty ||
          religionSelect.value.isEmpty ||
          genderSelect.value.isEmpty ||
          currentImage.value == null ||
          nameController.value.text.isEmpty ||
          nikController.value.text.isEmpty ||
          nohpController.value.text.isEmpty ||
          kotaProvinsiController.value.text.isEmpty ||
          biografiController.value.text.isEmpty) {
        Get.snackbar('Error', 'Data tidak boleh kosong');
      } else {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final UserController userController = Get.find<UserController>();

        String filePath = 'mitra/${userController.uid.value}';
        await storage.ref(filePath).putFile(currentImage.value!);
        String downloadUrl = await storage.ref(filePath).getDownloadURL();

        await firestore.collection('mitra').doc(userController.uid.value).set({
          'name': nameController.value.text,
          'nik': nikController.value.text,
          'nohp': nohpController.value.text,
          'biografi': biografiController.value.text,
          'pekerjaan': jobSelect.value,
          'pendidikan': educationSelect.value,
          'jenisKelamin': genderSelect.value,
          'image': downloadUrl,
          'rating': 5.0,
          'saldo': 0,
        });

        final int randomNumber = getRandomNumber();

        await firestore
            .collection('register')
            .doc(userController.uid.value)
            .set({
          'registerConfirmed': false,
          'payment': randomNumber,
        });

        // await firestore
        //     .collection('user')
        //     .doc(userController.uid.value)
        //     .update({
        //   'isDoula': true,
        // });

        // userController.updateUser(
        //   userController.username.value,
        //   true,
        //   userController.image.value,
        // );

        // userController.setDoula(
        //   nameController.value.text,
        //   nohpController.value.text,
        //   kotaProvinsiController.value.text,
        //   biografiController.value.text,
        //   downloadUrl,
        //   genderSelect.value,
        //   nikController.value.text,
        // );

        Get.offAllNamed('/user');
        Get.toNamed('/confirm-register', arguments: {
          'payment': randomNumber,
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  int getRandomNumber() {
    return 50000 + DateTime.now().millisecondsSinceEpoch % 1000;
  }

  Rx<List<String>> genderList = Rx<List<String>>([
    'Laki-laki',
    'Perempuan',
  ]);
  Rx<List<String>> religionList = Rx<List<String>>([
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu',
  ]);
  Rx<List<String>> educationList = Rx<List<String>>([
    'SD',
    'SMP',
    'SMA',
    'D3',
    'S1',
    'S2',
    'S3',
  ]);
  Rx<List<String>> jobList = Rx<List<String>>([
    'Dokter',
    'Perawat',
    'PNS',
    'TNI',
    'POLRI',
    'Pegawai Swasta',
    'Wiraswasta',
    'Petani',
    'Nelayan',
    'Buruh',
    'Lainnya',
  ]);
}
