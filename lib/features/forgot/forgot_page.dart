import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                  'Lupa Password ?',
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
                    "Masukkan email Anda, kami akan mengirimkan Anda kode knfirmasi",
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
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    Get.toNamed("/verification-forgot");
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
                          color: ColorDouce.lightPink.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Lanjut",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
