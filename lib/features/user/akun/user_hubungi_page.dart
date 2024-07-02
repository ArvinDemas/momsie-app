import 'package:douce/features/user/akun/user_hubungi_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class UserHubungiPage extends StatelessWidget {
  const UserHubungiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserHubungiController userHubungiController =
        Get.put(UserHubungiController());

    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 15,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Hubungi Kami",
                    style: TextStyle(
                      fontSize: 22,
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
              Obx(
                () => contactContainer(
                  "Customer Service",
                  "(620) 555 - 1036",
                  userHubungiController.customerServiceToggle.value,
                  () => userHubungiController.toggleCustomerService(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userHubungiController.customerServiceToggle.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => contactContainer(
                  "WhatsApp",
                  "(620) 555 - 1036",
                  userHubungiController.whatsAppToggle.value,
                  () => userHubungiController.toggleWhatsApp(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userHubungiController.whatsAppToggle.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => contactContainer(
                  "Website",
                  "www.doula.id",
                  userHubungiController.websiteToggle.value,
                  () => userHubungiController.toggleWebsite(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userHubungiController.websiteToggle.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => contactContainer(
                  "Facebook",
                  "Doula Indonesia",
                  userHubungiController.facebookToggle.value,
                  () => userHubungiController.toggleFacebook(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userHubungiController.facebookToggle.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => contactContainer(
                  "Instagram",
                  "@doula.id",
                  userHubungiController.instagramToggle.value,
                  () => userHubungiController.toggleInstagram(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget contactContainer(
    String title,
    String subtitle,
    bool isToggle,
    Function onTap,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        isToggle
            ? Positioned(
                left: 0,
                right: 0,
                bottom: -50,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorDouce.douceBase,
              width: 1.2,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.call,
                size: 32,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => onTap(),
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                  color: ColorDouce.douceBase,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
