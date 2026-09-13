import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'verify_email_controller.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyEmailController controller = Get.put(VerifyEmailController());
    final String email = Get.find<UserController>().email.value ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: controller.isEmailVerified.value
                      ? Colors.green.shade50
                      : ColorDouce.douceBase.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isEmailVerified.value
                      ? Icons.check_circle
                      : Icons.email_outlined,
                  size: 64,
                  color: controller.isEmailVerified.value
                      ? Colors.green
                      : ColorDouce.douceBase,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                controller.isEmailVerified.value ? 'Email Terverifikasi!' : 'Verifikasi Email',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppSemanticColors.textDarkSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                controller.isEmailVerified.value
                    ? 'Selamat! Akun Momsiemu sudah aktif.\nAkan segera mengarahkan ke halaman utama...'
                    : 'Kami telah mengirim link verifikasi ke\n$email',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              if (!controller.isEmailVerified.value) ...[
                // Steps
                _buildStep(context, 1, 'Buka inbox / folder spam email kamu'),
                const SizedBox(height: 8),
                _buildStep(context, 2, 'Klik link verifikasi yang dikirimkan Momsie'),
                const SizedBox(height: 8),
                _buildStep(context, 3, 'Buka aplikasi ini kembali, kamu akan otomatis masuk!'),
                const SizedBox(height: 24),

                // Automatic Detection Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: ColorDouce.douceBase,
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Mendeteksi status verifikasi otomatis...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resend button
                OutlinedButton(
                  onPressed: controller.isLoading.value ? null : controller.resendVerification,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorDouce.douceBase,
                    side: BorderSide(color: ColorDouce.douceBase.withValues(alpha: 0.5)),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.mark_email_unread_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Belum terima email? Kirim Ulang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorDouce.douceBase,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.info, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Cek juga folder Spam atau Junk di email kamu. Link akan kedaluwarsa dalam 1 jam.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Success animation indicator
                const SizedBox(height: 24),
                CircularProgressIndicator(color: ColorDouce.douceBase),
                const SizedBox(height: 16),
                const Text('Mengarahkan...', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],

              const Spacer(),

              // Back to login
              TextButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: const Text('Kembali ke Login', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int step, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: ColorDouce.douceBase,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: AppSemanticColors.textDarkSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
