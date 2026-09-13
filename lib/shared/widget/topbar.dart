import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/feature_search_modal.dart';
import 'package:douce/shared/widget/job_search_modal.dart';
import 'package:douce/shared/widget/yoga_streak_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _getTimeGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Selamat Pagi';
  if (hour < 15) return 'Selamat Siang';
  if (hour < 18) return 'Selamat Sore';
  return 'Selamat Malam';
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.isDoula = false,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.showSearch = true,
    this.onAvatarTap,
  });

  final bool isDoula;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final bool showSearch;
  final VoidCallback? onAvatarTap;

  Widget _buildAvatar(String imagePath) {
    if (imagePath.isEmpty) {
      return Image.asset(
        'assets/images/blank-profile.png',
        width: 38,
        height: 38,
        fit: BoxFit.cover,
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: 38,
        height: 38,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 38,
          height: 38,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: 38,
        height: 38,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 38,
          height: 38,
          fit: BoxFit.cover,
        ),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 38,
        height: 38,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 38,
          height: 38,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/blank-profile.png',
      width: 38,
      height: 38,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double totalHeight = statusBarHeight + (showSearch ? 138.0 : 82.0);

    return Container(
      height: totalHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorDouce.douceBase,
            const Color(0xFFFF7B93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: AppElevation.level3,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Greeting & Profile Bar
          Positioned(
            top: statusBarHeight + 8,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onAvatarTap ??
                              () {
                                if (isDoula) {
                                  Get.toNamed('/mitra-akun');
                                } else {
                                  Get.toNamed('/user-akun');
                                }
                              },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Obx(
                              () => ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _buildAvatar(
                                  isDoula
                                      ? (userController.doulaImage.value.isNotEmpty
                                          ? userController.doulaImage.value
                                          : userController.image.value)
                                      : userController.image.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getTimeGreeting()}, ${isDoula ? 'Mitra' : 'Bunda'}!',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Obx(
                              () {
                                String displayName = '';
                                if (isDoula) {
                                  if (userController.doulaUsername.value.isNotEmpty) {
                                    displayName = userController.doulaUsername.value;
                                  } else if (userController.username.value.isNotEmpty) {
                                    displayName = userController.username.value;
                                  } else {
                                    displayName = 'Mitra Doula';
                                  }
                                } else {
                                  if (userController.username.value.isNotEmpty) {
                                    displayName = userController.username.value;
                                  } else {
                                    displayName = 'Bunda Momsie';
                                  }
                                }
                                return Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Live YogaStreakBadge (Only for User Mode)
                if (!isDoula) ...[
                  Obx(() => YogaStreakBadge(
                        streak: userController.yogaStreak.value,
                        compact: true,
                      )),
                  const SizedBox(width: 8),
                ],

                // Notification Icon Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.toNamed('/user-notification'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          if (showSearch)
            Positioned(
              top: statusBarHeight + 62,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (isDoula) {
                      JobSearchModal.show(context);
                    } else {
                      FeatureSearchModal.show(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: ColorDouce.douceBase,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            searchHint ?? (isDoula ? 'Cari pekerjaan, nama pemesan...' : 'Cari fitur, menu, atau obat...'),
                            style: TextStyle(
                              color: AppSemanticColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Cari',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ColorDouce.douceBase,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
