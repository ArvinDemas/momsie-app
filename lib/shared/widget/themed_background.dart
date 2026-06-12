import 'package:douce/shared/theme/theme_service.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Convenience wrapper: menggunakan AnimatedGradientBackground
/// dengan warna dari ThemeService yang aktif secara reaktif.
class ThemedBackground extends StatelessWidget {
  const ThemedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = Get.find<ThemeService>();
    return Obx(() => AnimatedGradientBackground(
          orbColors: ts.orbColors,
          bgBase: ts.bgBase,
        ));
  }
}
