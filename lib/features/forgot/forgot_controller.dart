import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final RxBool isSent = false.obs;

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.value.text.trim());
      Get.snackbar(
        "Reset Password",
        "Email sent to ${emailController.value.text}",
      );
      isSent.value = true;
    } catch (e) {
      Get.snackbar(
        "Failed",
        "Email for ${emailController.value.text} is not found",
      );
    }
  }
}
