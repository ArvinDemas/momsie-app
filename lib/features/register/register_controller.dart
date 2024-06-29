import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isSetuju = false.obs;

  void goToLogin() {
    Get.toNamed('/login');
  }

  void onCheckBox() {
    isSetuju.value = !isSetuju.value;
  }

  void successRegister() {
    Get.toNamed('/register-success');
  }
}
