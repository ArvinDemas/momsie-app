import 'package:get/get.dart';

class UserSettingNotifikasiController extends GetxController {
  final RxBool toggleUpdateApplikasi = false.obs;
  final RxBool toggleTagihan = false.obs;
  final RxBool toggleDiskon = false.obs;
  final RxBool toggleLayananTerbaru = false.obs;

  void updateToggleUpdateApplikasi(bool value) {
    toggleUpdateApplikasi.value = value;
  }

  void updateToggleTagihan(bool value) {
    toggleTagihan.value = value;
  }

  void updateToggleDiskon(bool value) {
    toggleDiskon.value = value;
  }

  void updateToggleLayananTerbaru(bool value) {
    toggleLayananTerbaru.value = value;
  }
}
