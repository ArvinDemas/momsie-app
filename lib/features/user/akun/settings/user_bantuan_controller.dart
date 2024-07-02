import 'package:get/get.dart';

class UserBantuanController extends GetxController {
  final RxBool konsultasiDokter = false.obs;
  final RxBool konsultasiMahal = false.obs;
  final RxBool layananBagus = false.obs;
  final RxBool lupaPassword = false.obs;

  void updateKonsultasiDokter() {
    konsultasiDokter.value = !konsultasiDokter.value;
  }

  void updateKonsultasiMahal() {
    konsultasiMahal.value = !konsultasiMahal.value;
  }

  void updateLayananBagus() {
    layananBagus.value = !layananBagus.value;
  }

  void updateLupaPassword() {
    lupaPassword.value = !lupaPassword.value;
  }
}
