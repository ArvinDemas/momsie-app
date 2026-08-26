import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/edukasi/user_edukasi_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/widget/yoga_streak_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEdukasiPage extends StatelessWidget {
  const UserEdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEdukasiController controller = Get.put(UserEdukasiController());

    return BasePage(
      onAvatarTap: () {
        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController());
        }
        Get.toNamed(AppRoutes.userAkun);
      },
      searchHint: 'Cari Artikel & Edukasi Kehamilan...',
      childWidget: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Modern 3D Edukasi Banner Card
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: ColorDouce.douceBase.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/edukasi_banner_3d.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [ColorDouce.douceBase, const Color(0xFFFF9A9E)],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          top: 20,
                          bottom: 20,
                          width: 210,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'EDUKASI IBU & JANIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Kuasai Informasi Penting Kemenkes & WHO!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Apple-Style Premium Segmented Tab Selector (Comfortable Full Height Pill)
                Container(
                  height: 52,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Obx(
                    () {
                      final isProgram = controller.edukasi.value == "Program Kehamilan";
                      return Row(
                        children: [
                          // Tab 1: Program Yoga (Icons.self_improvement_rounded)
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.changeEdukasi("Program Kehamilan"),
                              borderRadius: BorderRadius.circular(23),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isProgram
                                      ? LinearGradient(
                                          colors: [ColorDouce.douceBase, const Color(0xFFFF7B93)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : null,
                                  color: isProgram ? null : Colors.transparent,
                                  borderRadius: BorderRadius.circular(23),
                                  boxShadow: isProgram
                                      ? [
                                          BoxShadow(
                                            color: ColorDouce.douceBase.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.self_improvement_rounded,
                                      size: 22,
                                      color: isProgram ? Colors.white : const Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Program Yoga",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isProgram ? FontWeight.bold : FontWeight.w600,
                                        color: isProgram ? Colors.white : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Tab 2: Artikel Edukasi
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.changeEdukasi("Artikel"),
                              borderRadius: BorderRadius.circular(23),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: !isProgram
                                      ? LinearGradient(
                                          colors: [ColorDouce.douceBase, const Color(0xFFFF7B93)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : null,
                                  color: !isProgram ? null : Colors.transparent,
                                  borderRadius: BorderRadius.circular(23),
                                  boxShadow: !isProgram
                                      ? [
                                          BoxShadow(
                                            color: ColorDouce.douceBase.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_rounded,
                                      size: 20,
                                      color: !isProgram ? Colors.white : const Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Artikel Edukasi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: !isProgram ? FontWeight.bold : FontWeight.w600,
                                        color: !isProgram ? Colors.white : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
    final UserController userController = Get.find<UserController>();

    return InkWell(
      onTap: () => Get.toNamed('/user-detail-program', arguments: {
        'program': program,
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Program ${program.name}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ),
                Obx(() => YogaStreakBadge(streak: userController.yogaStreak.value, compact: true)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    program.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: program.image,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 65,
                      height: 65,
                      color: Colors.pink.shade50,
                      child: Icon(Icons.self_improvement_rounded, color: ColorDouce.douceBase),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
