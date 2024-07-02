import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKebijakanPrivasiPage extends StatelessWidget {
  const UserKebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Kebijakan Privasi",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Doula adalah aplikasi yang membantu ibu hamil dalam mempersiapkan kehamilan dan persalinan. Doula memberikan informasi yang akurat dan terpercaya untuk membantu ibu hamil dalam mempersiapkan kehamilan dan persalinan.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
