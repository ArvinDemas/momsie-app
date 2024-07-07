import 'package:douce/features/splash/splash_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorDouce.douceBase,
        body: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
      ),
    );
  }
}
