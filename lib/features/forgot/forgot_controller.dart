import 'package:douce/app/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isSent = false.obs;
  final RxString resetEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt resendCountdown = 0.obs;
  final RxBool canResend = true.obs;

  void startResendCooldown() {
    resendCountdown.value = 60;
    canResend.value = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      resendCountdown.value--;
      return resendCountdown.value > 0;
    }).whenComplete(() {
      canResend.value = true;
      resendCountdown.value = 0;
    });
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Masukkan email terlebih dahulu.");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Format alamat email tidak valid.");
      return;
    }
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      resetEmail.value = email;
      isSent.value = true;
      startResendCooldown();
      Get.snackbar(
        "Reset Password",
        "Link reset password telah dikirim ke $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun dengan email ini tidak terdaftar.';
          break;
        case 'invalid-email':
          message = 'Format alamat email tidak valid.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak permintaan. Silakan tunggu beberapa saat.';
          break;
        default:
          message = 'Gagal mengirim link reset: ${e.message}';
      }
      Get.snackbar("Gagal", message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendEmail() async {
    final email = resetEmail.value;
    if (email.isEmpty || !canResend.value) return;
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      startResendCooldown();
      Get.snackbar(
        "Reset Password",
        "Link reset password telah dikirim ulang ke $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'too-many-requests':
          message = 'Terlalu banyak permintaan. Silakan tunggu beberapa saat.';
          break;
        default:
          message = 'Gagal mengirim link reset: ${e.message}';
      }
      Get.snackbar("Gagal", message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openEmailApp() async {
    final url = Uri.parse('mailto:');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Tidak bisa membuka aplikasi email.');
    }
  }

  void goBackToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
