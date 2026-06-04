import 'package:douce/features/forgot/verification_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final verificationController = Get.put(VerificationController());

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
            child: Column(
              children: [
                const Text(
                  'Masukkan Kode Verifikasi',
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
                    "Masukkan kode yang telah kami kirimkan ke email anda",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customInputBox(verificationController.firstController),
                    const SizedBox(width: 20),
                    customInputBox(verificationController.secondController),
                    const SizedBox(width: 20),
                    customInputBox(verificationController.thirdController),
                    const SizedBox(width: 20),
                    customInputBox(verificationController.fourthController),
                  ],
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Get.toNamed('/create-password');
                  },
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
                    child: const Text(
                      "Verifikasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum mendapatkan kode? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Kirim ulang",
                      style: TextStyle(
                        color: ColorDouce.douceBase,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }

  Container customInputBox(TextEditingController controller) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: controller.text.isEmpty
            ? Colors.transparent
            : ColorDouce.veryLightPink,
        borderRadius: BorderRadius.circular(8),
        border: controller.text.isEmpty
            ? Border.all(
                color: Colors.black38,
                width: 0.5,
              )
            : null,
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          color: ColorDouce.douceBase,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          if (value.length > 1) {
            controller.text = value.substring(1, 2);
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
