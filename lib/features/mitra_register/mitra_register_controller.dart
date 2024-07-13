import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraRegisterController extends GetxController {
  final RxInt currentPage = 0.obs;
  final RxString jobSelect = ''.obs;
  final RxString educationSelect = ''.obs;
  final RxString religionSelect = ''.obs;
  final RxString genderSelect = ''.obs;

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> nikController = TextEditingController().obs;
  final Rx<TextEditingController> alamatController =
      TextEditingController().obs;
  final Rx<TextEditingController> kotaProvinsiController =
      TextEditingController().obs;
  final Rx<TextEditingController> biografiController =
      TextEditingController().obs;

  void changePage(int page) {
    currentPage.value = page;
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
