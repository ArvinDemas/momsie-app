import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminLoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool showPassword = false.obs;

  Future<void> tryAdminLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Kolom Kosong',
        'Silakan isi email dan password admin.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim().toLowerCase(), password: password);

      // Cek status role di Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();

      bool isAdmin = false;
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        isAdmin = data['role'] == 'admin';
      }

      if (isAdmin) {
        Get.offAllNamed('/admin-dashboard');
      } else {
        await FirebaseAuth.instance.signOut();
        Get.snackbar(
          'Akses Ditolak',
          'Akun Anda tidak memiliki hak akses Admin.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        'Email atau password salah / tidak terdaftar.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
