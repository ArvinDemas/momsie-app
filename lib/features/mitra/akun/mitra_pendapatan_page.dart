import 'package:douce/features/mitra/akun/mitra_pendapatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class MitraPendapatanPage extends StatelessWidget {
  const MitraPendapatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraPendapatanController controller =
        Get.put(MitraPendapatanController());
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          ListView(
        padding: const EdgeInsets.all(0),
        children: [
          pendapatanTopBar(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Total : ",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => Text(
                          "Rp. ${controller.total.value}",
                          style: TextStyle(
                            color: ColorDouce.douceBase,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 0.5,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tarik Pendapatan",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Via / Norek",
                    iconImage: const Icon(Icons.wallet),
                    isPassword: false,
                    controller: controller.viaController.value,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Nominal",
                    iconImage: const Icon(Icons.money),
                    isPassword: false,
                    controller: controller.tarikController.value,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      controller.tarikPendapatan();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Tarik",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
        ],
      ),
    );
  }

  Widget calendarContainer(String day, String date, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? ColorDouce.douceBase : ColorDouce.kindaRed,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 24,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget pendapatanTopBar() {
    return Container(
      height: 150,
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
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Pendapatan",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.transparent,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
