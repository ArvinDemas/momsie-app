import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:douce/shared/widget/rumah_sakit_container.dart';
import 'package:douce/shared/widget/tokobayi_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBerandaPage extends StatelessWidget {
  const UserBerandaPage({
    super.key,
    required this.changeNavigation,
  });

  final Function(String) changeNavigation;

  @override
  Widget build(BuildContext context) {
    final UserBerandaController controller = Get.put(UserBerandaController());

    return BasePage(
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed('booking-doula');
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/images/beranda.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Top Doula",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        changeNavigation("Doula");
                      },
                      child: Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorDouce.douceBase,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Obx(
                  () => SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 15,
                      children: controller.getRandomDoula().map((doula) {
                        return DoulaContainer(
                          doula: doula,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rumah Sakit Mitra",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        changeNavigation("Rumah Sakit");
                      },
                      child: Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorDouce.douceBase,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.isRumahSakitLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Wrap(
                          runSpacing: 15,
                          children: controller
                              .getRandomRumahSakit()
                              .map((rumahSakit) => RumahSakitContainer(
                                    rumahSakit: rumahSakit,
                                  ))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rekomendasi Toko Bayi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: controller.isArtikelLoading.value
                            ? () {}
                            : () {
                                Get.toNamed(
                                  '/see-more',
                                  arguments: {
                                    'title': 'Toko Bayi',
                                    'tokoBayi': controller.tokoBayiList,
                                  },
                                );
                              },
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.isTokoBayiLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 20,
                            children: controller
                                .getRandomTokoBayi()
                                .map(
                                  (tokoBayi) => TokoBayiContainer(
                                    tokoBayi: tokoBayi,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Artikel Terkini",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: controller.isArtikelLoading.value
                            ? () {}
                            : () {
                                Get.toNamed(
                                  '/see-more',
                                  arguments: {
                                    'title': 'Artikel',
                                    'artikel': controller.artikelList,
                                  },
                                );
                              },
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.isArtikelLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                          runSpacing: 10,
                          children: controller
                              .getRandomArtikel()
                              .map(
                                  (artikel) => artikelTerkiniContainer(artikel))
                              .toList(),
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget artikelTerkiniContainer(ArtikelModel artikel) {
    return InkWell(
      onTap: () => Get.toNamed("/user-artikel", arguments: artikel),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  artikel.thumbnail,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artikel.pubDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
