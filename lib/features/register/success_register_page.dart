import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessRegisterPage extends StatelessWidget {
  const SuccessRegisterPage({super.key});

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
                Image.asset(
                  'assets/images/check.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Open-Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "Akun Anda telah berhasil didaftarkan",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Open-Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
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
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/home');
                    },
                    child: const Text(
                      "Masuk",
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
