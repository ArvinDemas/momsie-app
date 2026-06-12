import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/features/user/sizeguide/sizeguide_card.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/doula_container.dart';
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
          const SizedBox(height: 20),
          // ── Hero Card: Ukuran Bayi Minggu Ini ──────────────────────
          const SizeGuideCard(),
          const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                // ── Quick Access: Fitur Baru (2×2) ───────────────────
                Row(
                  children: [
                    Expanded(
                      child: _quickAccessCard(
                        icon: '🧳',
                        label: 'Hospital Bag',
                        color: const Color(0xFFFF6972),
                        onTap: () => Get.toNamed('/checklist'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAccessCard(
                        icon: '📋',
                        label: 'Birth Plan',
                        color: const Color(0xFF9C6BFF),
                        onTap: () => Get.toNamed('/birth-plan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _quickAccessCard(
                        icon: '📖',
                        label: 'Diary',
                        color: const Color(0xFFFF8C69),
                        onTap: () => Get.toNamed('/diary'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAccessCard(
                        icon: '✨',
                        label: 'Nama Bayi',
                        color: const Color(0xFF6C63FF),
                        onTap: () => Get.toNamed('/baby-names'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _quickAccessCard(
                        icon: '💬',
                        label: 'Momsie AI Chatbot (Tanya AI)',
                        color: const Color(0xFF00B4D8),
                        onTap: () => Get.toNamed('/ai-chat'),
                      ),
                    ),
                  ],
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

  Widget _quickAccessCard({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.78)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ],
        ),
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
              color: Colors.grey.withValues(alpha: 0.3),
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
