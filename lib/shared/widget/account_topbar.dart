import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTopBar extends StatelessWidget {
  const AccountTopBar({
    super.key,
    this.isEditPage = false,
    this.isBackPage = false,
  });

  final bool isEditPage;
  final bool isBackPage;

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
              child: SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: userController.image.value.isEmpty
                      ? Image.asset(
                          'assets/images/blank-profile.png',
                          width: 150,
                          height: 150,
                        )
                      : Image.network(
                          userController.image.value,
                          width: 150,
                          height: 150,
                        ),
                ),
              ),
            ),
          ),
          isBackPage
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
              ? Positioned(
                  top: 160,
                  left: MediaQuery.of(context).size.width * 0.625,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Icon(
                      Icons.edit,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
