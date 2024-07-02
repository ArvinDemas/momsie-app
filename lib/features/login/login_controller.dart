import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool showPassword = false.obs;

  void goToRegister() {
    Get.toNamed('/register');
  }

  void loginSuccess() {
    Get.toNamed('/user');
  }

  void forgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void onShowPassword() {
    showPassword.value = !showPassword.value;
  }
}
