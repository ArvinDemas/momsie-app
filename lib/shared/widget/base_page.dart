import 'package:douce/shared/widget/apotek_topbar.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.childWidget, this.isApotek = false});

  final Widget childWidget;
  final bool isApotek;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: childWidget,
        ),
        Positioned(
          top: 0,
          child: isApotek ? const ApotikTopBar() : const TopBar(),
        ),
      ],
    );
  }
}
