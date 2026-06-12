import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminLoginController extends GetxController {
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController = TextEditingController().obs;
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
    final String emailLower = email.trim().toLowerCase();

    try {
      UserCredential userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailLower, password: password);
      } on FirebaseAuthException catch (e) {
        // Jika user tidak ditemukan dan kredensial cocok dengan admin default, buat otomatis
        if ((e.code == 'user-not-found' || e.code == 'invalid-credential') &&
            emailLower == 'admin@momsie.com' &&
            password == 'admin12345') {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: emailLower, password: password);
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userCredential.user!.uid)
              .set({
            'username': 'Admin Momsie',
            'email': emailLower,
            'image': '',
            'uid': userCredential.user!.uid,
            'isDoula': false,
            'role': 'admin',
          });
        } else {
          rethrow;
        }
      }

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

      // Bypass tambahan untuk default admin email
      if (emailLower == 'admin@momsie.com') {
        isAdmin = true;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.uid)
            .set({
          'username': 'Admin Momsie',
          'email': emailLower,
          'image': '',
          'uid': userCredential.user!.uid,
          'isDoula': false,
          'role': 'admin',
        }, SetOptions(merge: true));
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
}
