import 'package:douce/features/user/edukasi/user_edukasi_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEdukasiPage extends StatelessWidget {
  const UserEdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEdukasiController controller = Get.put(UserEdukasiController());

    return BasePage(
      isApotek: true,
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Image.asset('assets/images/edukasi.png'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.changeEdukasi("Artikel");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: controller.edukasi.value == "Artikel"
                                ? ColorDouce.douceBase
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Artikel",
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.edukasi.value == "Artikel"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.changeEdukasi("Program Kehamilan");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controller.edukasi.value == "Program Kehamilan"
                                    ? ColorDouce.douceBase
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Program Kehamilan",
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.edukasi.value ==
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
                  () => controller.edukasi.value == "Artikel"
                      ? artikelColumn(controller)
                      : programKehamilanColumn(controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget artikelColumn(UserEdukasiController controller) {
    return Obx(
      () => controller.isLoadingArtikel.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Wrap(
              spacing: 20,
              alignment: WrapAlignment.spaceAround,
              runSpacing: 20,
              children: controller.artikelList
                  .map((artikel) => ArtikelContainer(artikel: artikel))
                  .toList()),
    );
  }

  Widget programKehamilanColumn(UserEdukasiController controller) {
    return Obx(
      () => controller.isLoadingProgram.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: controller.programList
                  .map((program) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: programKehamilanContainer(program),
                      ))
                  .toList(),
            ),
    );
  }

  Widget programKehamilanContainer(ProgramModel program) {
    return InkWell(
      onTap: () => Get.toNamed('/user-detail-program', arguments: {
        'program': program,
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Program ${program.name}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: ColorDouce.douceBase,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Image.network(
              program.image,
              width: 75,
              height: 75,
            )
          ],
        ),
      ),
    );
  }
}
