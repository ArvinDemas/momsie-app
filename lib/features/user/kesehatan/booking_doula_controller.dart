import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class BookingDoulaController extends GetxController {
  final RxInt harga = 0.obs;
  final RxString selectedTanggal = ''.obs;
  final RxString selectedDay = ''.obs;
  final RxString selectedJam = "".obs;
  final RxString selectedLayanan = "".obs;

  void setHarga(int value) {
    harga.value = value;
  }

  void setSelectedTanggal(String value) {
    selectedTanggal.value = value;
  }

  void setSelectedDay(String value) {
    selectedDay.value = value;
  }

  void setSelectedJam(String value) {
    selectedJam.value = value;
  }

  void setSelectedLayanan(String value) {
    selectedLayanan.value = value;
  }

  Future<void> createBooking() async {
    final UserController userController = Get.find<UserController>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("booking").add({
      'id': generateRandomCode(16),
      "tanggal": selectedTanggal.value,
      "day": selectedDay.value,
      "jam": selectedJam.value,
      "layanan": selectedLayanan.value,
      "harga": generateRandomHarga(),
      "user": userController.uid.value,
      'status': 'pending',
    });
  }

  int generateRandomHarga() {
    return harga.value + 2000 + Random().nextInt(1000);
  }

  String generateRandomCode(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  List<DateTime> dates =
      List.generate(6, (i) => DateTime.now().add(Duration(days: i + 2)));
}
