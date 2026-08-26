import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isSent = false.obs;
  final RxString resetEmail = ''.obs;

  void resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Masukkan email terlebih dahulu.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      resetEmail.value = email;
      isSent.value = true;
      Get.snackbar(
        "Reset Password",
        "Email reset password telah dikirim ke $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Email tidak ditemukan: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToVerification() {
    Get.toNamed('/verification-forgot');
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
