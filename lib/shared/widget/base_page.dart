import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:douce/shared/widget/apotek_topbar.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage(
      {super.key,
      required this.childWidget,
      this.isApotek = false,
      this.isDoula = false});

  final Widget childWidget;
  final bool isApotek;
  final bool isDoula;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated orb background
          const AnimatedGradientBackground(),
          // Main content + top bar
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: childWidget,
          ),
          Positioned(
            top: 0,
            child: isApotek
                ? const ApotikTopBar()
                : TopBar(
                    isDoula: isDoula,
                  ),
          ),
        ],
      ),
    );
  }
}
