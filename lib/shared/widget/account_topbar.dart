import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTopBar extends StatelessWidget {
  const AccountTopBar({super.key, this.isEditPage = false});

  final bool isEditPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      decoration: BoxDecoration(
        color: ColorDouce.douceBase,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/profile.png',
              width: 150,
              height: 150,
            ),
          ),
          isEditPage
              ? Positioned(
                  top: 50,
                  left: 30,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                )
              : const SizedBox(),
          isEditPage
              ? const Positioned(
                  top: 160,
                  left: 265,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
