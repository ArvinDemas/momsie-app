import 'dart:io';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.isDoula = false,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.showSearch = true,
  });

  final bool isDoula;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final bool showSearch;

  Widget _buildAvatar(String imagePath) {
    if (imagePath.isEmpty) {
      return Image.asset(
        'assets/images/blank-profile.png',
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      );
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/blank-profile.png',
      width: 32,
      height: 32,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final double height = showSearch ? 150.0 : 100.0;

    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Text(
                            'Halo, ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              fontFamily: 'Open-Sans',
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              () => Text(
                                isDoula
                                    ? userController.doulaUsername.value
                                    : userController.username.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFamily: 'Open-Sans',
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed('/user-notification'),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _buildAvatar(
                              isDoula
                                  ? userController.doulaImage.value
                                  : userController.image.value,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showSearch)
            Positioned(
              top: 115,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 3,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: searchHint ?? (isDoula
                          ? 'Cari Pesanan | Pekerjaan'
                          : 'Cari Kategori, Obat'),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Open-Sans',
                        fontWeight: FontWeight.w300,
                      ),
                      enabled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onChanged: onSearchChanged,
                    onFieldSubmitted: onSearchSubmitted ?? (value) {
                      if (value.isNotEmpty) {
                        if (isDoula) {
                          Get.snackbar(
                            'Pencarian',
                            'Fitur pencarian untuk mitra sedang dalam pengembangan.',
                            snackPosition: SnackPosition.TOP,
                          );
                        } else {
                          Get.toNamed('/user-search', arguments: value);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
