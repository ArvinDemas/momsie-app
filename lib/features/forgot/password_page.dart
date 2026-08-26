import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/alert_dialog.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:douce/features/forgot/verification_controller.dart';
import 'package:get/get.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final RxBool _isLoading = false.obs;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const CustomAlertDialog(
          isSuccess: true,
          descText: "Password Berhasil diubah",
          destination: '/login',
        );
      },
    );
  }

  Future<void> _updatePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Kolom Kosong', 'Isi semua kolom password.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar('Password Terlalu Pendek', 'Password minimal 6 karakter.');
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('Password Tidak Cocok', 'Konfirmasi password tidak cocok.');
      return;
    }

    // Retrieve the verification code stored by VerificationController
    final verificationController = Get.find<VerificationController>();
    final resetCode = verificationController.storedCode;

    if (resetCode == null || resetCode.isEmpty) {
      Get.snackbar('Error', 'Kode verifikasi tidak ditemukan. Silakan ulangi dari awal.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _isLoading.value = true;
    try {
      // confirmPasswordReset validates the OOB code AND sets the new password in one call
      await FirebaseAuth.instance.confirmPasswordReset(
        code: resetCode,
        newPassword: newPassword,
      );
      if (mounted) {
        _showSuccessAndNavigate();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengubah password.';
      if (e.code == 'invalid-action-code') message = 'Kode reset tidak valid atau sudah digunakan.';
      if (e.code == 'user-disabled') message = 'Akun Anda telah dinonaktifkan.';
      if (e.code == 'user-not-found') message = 'Akun tidak ditemukan.';
      if (e.code == 'weak-password') message = 'Password terlalu lemah.';
      if (mounted) {
        Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Gagal', 'Terjadi kesalahan: $e', snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const AnimatedGradientBackground(),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 75,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Buat Password Baru',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: Text(
                          "Buat kata sandi baru anda untuk login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Password Baru",
                        iconImage: const Icon(Icons.lock_outline),
                        isPassword: true,
                        controller: _newPasswordController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Konfirmasi Password",
                        iconImage: const Icon(Icons.lock_outline),
                        isPassword: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 50),
                      Obx(
                        () => InkWell(
                          onTap: _isLoading.value ? null : _updatePassword,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: ColorDouce.douceBase,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorDouce.lightPink.withValues(alpha: 0.7),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isLoading.value)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (_isLoading.value) const SizedBox(width: 8),
                                const Text(
                                  "Lanjut",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
