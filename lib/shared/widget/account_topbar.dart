import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/avatar_picker_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTopBar extends StatelessWidget {
  const AccountTopBar({
    super.key,
    this.isEditPage = false,
    this.isBackPage = false,
    this.isDoula = false,
    this.onTap,
    this.additionalImage,
  });

  final bool isEditPage;
  final bool isBackPage;
  final bool isDoula;
  final Function? onTap;
  final Rx<File?>? additionalImage;

  /// Build profile image from URL or local file path
  Widget _buildProfileImage(String imagePath, double size) {
    if (imagePath.isEmpty) {
      return Image.asset(
        'assets/images/blank-profile.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    // Local file path
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/blank-profile.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

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
          Obx(
            () => Positioned(
              top: 75,
              left: MediaQuery.of(context).size.width * 0.5 - 75,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (onTap != null) {
                      onTap!();
                    } else {
                      AvatarPickerModal.show(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(1000),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: additionalImage?.value != null
                          ? Image.file(
                              additionalImage!.value!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : isDoula
                              ? _buildProfileImage(
                                  userController.doulaImage.value.isNotEmpty
                                      ? userController.doulaImage.value
                                      : userController.image.value,
                                  150,
                                )
                              : userController.image.value.isEmpty
                                  ? Image.asset(
                                      'assets/images/blank-profile.png',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : _buildProfileImage(
                                      userController.image.value,
                                      150,
                                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isBackPage)
            Positioned(
              top: 50,
              left: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Get.back();
                    } else {
                      Get.offAllNamed('/mitra');
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 160,
            left: MediaQuery.of(context).size.width * 0.625,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  } else {
                    AvatarPickerModal.show(context);
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: AppElevation.level2,
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    Icons.edit,
                    color: ColorDouce.douceBase,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
