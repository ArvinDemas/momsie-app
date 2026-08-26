import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/app/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isSetuju = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> tryRegister() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Kolom Kosong',
        'Mohon isi semua field yang tersedia',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      Get.snackbar(
        'Email Tidak Valid',
        'Format email tidak sesuai, periksa kembali',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (!isSetuju.value) {
      Get.snackbar(
        'Persetujuan Diperlukan',
        'Anda harus menyetujui syarat dan ketentuan yang berlaku',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (password.length < 8) {
      Get.snackbar(
        'Password Terlalu Pendek',
        'Password minimal 8 karakter',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(password)) {
      Get.snackbar(
        'Password Lemah',
        'Password harus mengandung huruf dan angka',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Map<String, dynamic> userData = {
        'username': usernameController.text,
        'email': emailController.text,
        'uid': userCredential.user!.uid,
        'image': '',
        'isDoula': false,
      };

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set(userData);

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        usernameController.text,
        emailController.text,
        userCredential.user!.uid,
        '',
        false,
      );

      // Kirim link verifikasi email secara aman
      try {
        await userCredential.user!.sendEmailVerification();
      } catch (err) {
        debugPrint('Send email verification error: $err');
      }
      Get.toNamed(AppRoutes.verifyEmail);
    } catch (e) {
      String msg = 'Terjadi kesalahan. Silakan coba lagi.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            msg = 'Password terlalu lemah (minimal 6 karakter)';
            break;
          case 'email-already-in-use':
            msg = 'Email sudah terdaftar';
            break;
          case 'invalid-email':
            msg = 'Format email tidak valid';
            break;
          default:
            msg = 'Terjadi kesalahan. Silakan coba lagi.';
        }
      }
      Get.snackbar('Registrasi Gagal', msg, snackPosition: SnackPosition.TOP);
      return;
    }
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void onCheckBox() {
    isSetuju.value = !isSetuju.value;
  }
}
