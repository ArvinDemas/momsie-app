import 'package:get/get.dart';

class UserBantuanController extends GetxController {
  final RxBool bookingDoula = false.obs;
  final RxBool lupaPassword = false.obs;
  final RxBool ubahTema = false.obs;
  final RxBool catatanKehamilan = false.obs;
  final RxBool geminiApiKey = false.obs;

  void toggleBookingDoula() => bookingDoula.value = !bookingDoula.value;
  void toggleLupaPassword() => lupaPassword.value = !lupaPassword.value;
  void toggleUbahTema() => ubahTema.value = !ubahTema.value;
  void toggleCatatanKehamilan() => catatanKehamilan.value = !catatanKehamilan.value;
  void toggleGeminiApiKey() => geminiApiKey.value = !geminiApiKey.value;
}
