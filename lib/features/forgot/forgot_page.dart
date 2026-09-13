import 'package:douce/features/forgot/forgot_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotController controller = Get.put(ForgotController());

    return Scaffold(
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
                child: Obx(
                  () => controller.isSent.value
                      ? _buildSuccessCard(controller)
                      : _buildEmailForm(controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm(ForgotController controller) {
    return Column(
      children: [
        const Text(
          'Lupa Password ?',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Masukkan email Anda, kami akan mengirimkan link reset password",
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
          hintText: "Email",
          iconImage: const Icon(Icons.email_outlined),
          isPassword: false,
          controller: controller.emailController,
        ),
        const SizedBox(height: 30),
        Obx(
          () => InkWell(
            onTap: controller.isLoading.value ? null : controller.resetPassword,
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
                  if (controller.isLoading.value)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  if (controller.isLoading.value) const SizedBox(width: 8),
                  Text(
                    controller.isLoading.value ? 'Mengirim...' : 'Kirim Link Reset',
                    style: const TextStyle(
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
    );
  }

  Widget _buildSuccessCard(ForgotController controller) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: ColorDouce.douceBase.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: 40,
            color: ColorDouce.douceBase,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Tautan Reset Telah Dikirim!",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Kami telah mengirimkan link reset password ke ${controller.resetEmail.value}. Silakan periksa inbox/spam email Anda dan klik link tersebut untuk membuat kata sandi baru.",
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        InkWell(
          onTap: controller.openEmailApp,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
            child: const Text(
              "Buka Aplikasi Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => InkWell(
            onTap: controller.canResend.value ? controller.resendEmail : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: ColorDouce.douceBase),
              ),
              child: Text(
                controller.canResend.value
                    ? "Kirim Ulang Email"
                    : "Kirim Ulang (${controller.resendCountdown.value}s)",
                style: TextStyle(
                  color: controller.canResend.value
                      ? ColorDouce.douceBase
                      : Colors.grey,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: controller.goBackToLogin,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: ColorDouce.douceBase),
            ),
            child: Text(
              "Kembali ke Login",
              style: TextStyle(
                color: ColorDouce.douceBase,
                fontSize: 16,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
