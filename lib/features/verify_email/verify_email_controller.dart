import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyEmailController extends GetxController with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _userCtrl = Get.find<UserController>();
  final PinAuthService _pinService = Get.find<PinAuthService>();

  final RxBool isEmailVerified = false.obs;
  final RxBool isLoading = false.obs;
  final RxString lastSentTime = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkVerification();
    _pollVerification();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Saat pengguna kembali ke aplikasi dari email client/browser
      _checkVerification();
    }
  }

  void _checkVerification() {
    final user = _auth.currentUser;
    if (user != null) {
      user.reload().then((_) {
        if (_auth.currentUser?.emailVerified == true) {
          _onVerified();
        }
      }).catchError((e) {
        debugPrint('reload error: $e');
      });
    }
  }

  /// Poll setiap 2 detik secara otomatis di background
  void _pollVerification() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (isEmailVerified.value) {
        timer.cancel();
        return;
      }
      try {
        await _auth.currentUser?.reload();
        if (_auth.currentUser?.emailVerified == true) {
          timer.cancel();
          _onVerified();
        }
      } catch (e) {
        debugPrint("error: $e");
      }
    });
  }

  void _onVerified() {
    if (isEmailVerified.value) return;
    isEmailVerified.value = true;
    _timer?.cancel();
    lastSentTime.value = '';
    // Setelah verifikasi, arahkan langsung secara otomatis ke dashboard
    _navigateAfterVerified();
  }

  Future<void> _navigateAfterVerified() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!Get.context!.mounted) return;

    final user = _auth.currentUser;
    if (user == null) return;

    // Cek role user
    final userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .get();

    final isDoula = userDoc.data()?['isDoula'] ?? false;

    if (isDoula) {
      Get.offAllNamed('/mitra');
    } else {
      Get.offAllNamed('/user');
    }
  }

  /// Kirim ulang link verifikasi ke email pengguna
  Future<void> resendVerification() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      isLoading.value = true;
      try {
        await user.sendEmailVerification();
      } catch (e) {
        // Fallback jika menggunakan custom ActionCodeSettings
        await user.sendEmailVerification(
          ActionCodeSettings(
            url: 'https://momsie.app/verify-email',
            handleCodeInApp: true,
            androidPackageName: 'com.momsie.mobile',
          ),
        );
      }
      lastSentTime.value = DateTime.now().toString();
      Get.snackbar(
        'Email Terkirim! 📧',
        'Link verifikasi baru telah dikirim ke ${user.email}. Pastikan cek folder Inbox & Spam/Junk!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Kirim Ulang Gagal',
        'Mohon tunggu beberapa saat sebelum mencoba kirim ulang lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Buka link verifikasi di browser (fallback untuk device tanpa app)
  Future<void> openVerificationLink() async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Verifikasi Email'),
        content: const Text(
          'Buka email kamu dan klik link verifikasi. Setelah diverifikasi, kembali ke aplikasi ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  /// Handle email verification link dari deep link / URL handler
  Future<bool> handleEmailLink(String link) async {
    if (link.contains('o/oauth2')) return false;
    if (!link.contains('verifyEmail') && !link.contains('emailAction')) return false;

    try {
      final actionCodeSettings = ActionCodeSettings(
        url: link,
        handleCodeInApp: true,
      );

      await _auth.applyActionCode(link.split('?').first);
      {
        Get.snackbar(
          'Berhasil!',
          'Email kamu telah terverifikasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
        );
        return true;
      }
    } catch (e) {
      debugPrint('Email link error: $e');
    }
    return false;
  }

  /// Force check - refresh
  Future<void> checkNow() async {
    try {
      isLoading.value = true;
      await _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified == true) {
        _onVerified();
      } else {
        Get.snackbar(
          'Belum Terverifikasi',
          'Email belum terverifikasi. Buka inbox/spam di email kamu dan klik link verifikasinya.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber.shade800,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint("error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
