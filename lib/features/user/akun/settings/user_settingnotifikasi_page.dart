import 'package:douce/features/user/akun/settings/user_settingnotifikasi_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSettingNotifikasiPage extends StatelessWidget {
  const UserSettingNotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserSettingNotifikasiController notifikasiController =
        Get.put(UserSettingNotifikasiController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
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
                    "Notifikasi",
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
                () => Column(
                  children: [
                    toggleCheckBox(
                      "Update Aplikasi",
                      notifikasiController.toggleUpdateApplikasi.value,
                      (value) {
                        notifikasiController.updateToggleUpdateApplikasi(value);
                      },
                    ),
                    toggleCheckBox(
                      "Tagihan",
                      notifikasiController.toggleTagihan.value,
                      (value) {
                        notifikasiController.updateToggleTagihan(value);
                      },
                    ),
                    toggleCheckBox(
                      "Diskon",
                      notifikasiController.toggleDiskon.value,
                      (value) {
                        notifikasiController.updateToggleDiskon(value);
                      },
                    ),
                    toggleCheckBox(
                      "Layanan Terbaru",
                      notifikasiController.toggleLayananTerbaru.value,
                      (value) {
                        notifikasiController.updateToggleLayananTerbaru(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleCheckBox(
    String title,
    bool isToggle,
    void Function(bool) onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.6,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Switch(
            value: isToggle,
            onChanged: onTap,
            activeColor: ColorDouce.douceBase,
          ),
        ],
      ),
    );
  }
}
