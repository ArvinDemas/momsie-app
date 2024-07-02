import 'package:douce/features/user/akun/settings/user_bantuan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBantuanPage extends StatelessWidget {
  const UserBantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBantuanController userBantuanController =
        Get.put(UserBantuanController());

    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Bantuan",
                    style: TextStyle(
                      fontSize: 24,
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
                () => helpContainer(
                  "Bagaimana cara konsultasi dengan dokter",
                  "Cara konsultasi dengan dokter dengan booking dokter tersebut dan memilih layanan",
                  userBantuanController.konsultasiDokter.value,
                  () => userBantuanController.updateKonsultasiDokter(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userBantuanController.konsultasiDokter.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => helpContainer(
                  "Apa konsultasi bayarnya mahal ?",
                  "Tidak",
                  userBantuanController.konsultasiMahal.value,
                  () => userBantuanController.updateKonsultasiMahal(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userBantuanController.konsultasiMahal.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => helpContainer(
                  "Layanannya bagus gak ?",
                  "Bagus Banget",
                  userBantuanController.layananBagus.value,
                  () => userBantuanController.updateLayananBagus(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => userBantuanController.layananBagus.value
                    ? const SizedBox(height: 40)
                    : const SizedBox(),
              ),
              Obx(
                () => helpContainer(
                  "Lupa Password ?",
                  "Mantep",
                  userBantuanController.lupaPassword.value,
                  () => userBantuanController.updateLupaPassword(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget helpContainer(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
