import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraPendapatanController extends GetxController {
  final RxInt total = 0.obs;

  final Rx<TextEditingController> tarikController = TextEditingController().obs;
  final Rx<TextEditingController> viaController = TextEditingController().obs;

  @override
  void onInit() {
    getPendapatan();
    super.onInit();
  }

  Future<void> getPendapatan() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserController userController = Get.find<UserController>();
    await firestore
        .collection('mitra')
        .doc(userController.uid.value)
        .get()
        .then((value) {
      total.value = value['saldo'];
    });
  }

  Future<void> tarikPendapatan() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserController userController = Get.find<UserController>();

    if (tarikController.value.text.isEmpty ||
        viaController.value.text.isEmpty) {
      Get.snackbar('Gagal', 'Isi semua form');
      return;
    }

    if (int.tryParse(tarikController.value.text) == null ||
        int.parse(tarikController.value.text) > total.value) {
      Get.snackbar('Gagal', 'Mohon masukkan nominal yang valid');
      return;
    }
    await firestore
        .collection('mitra')
        .doc(userController.uid.value)
        .update({'saldo': total.value - int.parse(tarikController.value.text)});

    await firestore.collection('tarik').add({
      'uid': userController.uid.value,
      'jumlah': int.parse(tarikController.value.text),
      'via': viaController.value.text,
    });

    tarikController.value.clear();
    viaController.value.clear();

    Get.snackbar(
        'Berhasil', 'Pendapatan berhasil ditarik, harap tunggu 1 x 24 jam');
    getPendapatan();
  }
}
