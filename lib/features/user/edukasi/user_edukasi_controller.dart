import 'package:get/get.dart';

class UserEdukasiController extends GetxController {
  final RxString edukasi = "Artikel".obs;

  void changeEdukasi(String value) {
    edukasi.value = value;
  }
}
