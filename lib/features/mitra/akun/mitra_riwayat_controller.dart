import 'package:get/get.dart';

class MitraRiwayatController extends GetxController {
  final riwayat = "Selanjutnya".obs;

  void changeRiwayat(String newRiwayat) {
    riwayat.value = newRiwayat;
  }
}
