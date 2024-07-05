import 'package:douce/features/user/edukasi/user_edukasi_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEdukasiPage extends StatelessWidget {
  const UserEdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEdukasiController userEdukasiController =
        Get.put(UserEdukasiController());

    return BasePage(
      isApotek: true,
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset('assets/images/edukasi.png'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        userEdukasiController.changeEdukasi("Artikel");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                userEdukasiController.edukasi.value == "Artikel"
                                    ? ColorDouce.douceBase
                                    : ColorDouce.grayBackground,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Artikel",
                            style: TextStyle(
                              fontSize: 16,
                              color: userEdukasiController.edukasi.value ==
                                      "Artikel"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        userEdukasiController
                            .changeEdukasi("Program Kehamilan");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: userEdukasiController.edukasi.value ==
                                    "Program Kehamilan"
                                ? ColorDouce.douceBase
                                : ColorDouce.grayBackground,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Program Kehamilan",
                            style: TextStyle(
                              fontSize: 16,
                              color: userEdukasiController.edukasi.value ==
                                      "Program Kehamilan"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => userEdukasiController.edukasi.value == "Artikel"
                      ? artikelColumn()
                      : programKehamilanColumn(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget artikelColumn() {
    return const Wrap(
      spacing: 20,
      alignment: WrapAlignment.spaceAround,
      runSpacing: 20,
      children: [
        ArtikelContainer(),
        ArtikelContainer(),
        ArtikelContainer(),
        ArtikelContainer(),
      ],
    );
  }

  Widget programKehamilanColumn() {
    return Column(
      children: [
        programKehamilanContainer(),
        const SizedBox(height: 20),
        programKehamilanContainer(),
        const SizedBox(height: 20),
        programKehamilanContainer(),
        const SizedBox(height: 20),
        programKehamilanContainer(),
      ],
    );
  }

  Widget programKehamilanContainer() {
    return InkWell(
      onTap: () => Get.toNamed('/user-detail-program'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(
              "Program Yogya",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: ColorDouce.douceBase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
