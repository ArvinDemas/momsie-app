import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/yoga_streak_badge.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserDetailProgramPage extends StatelessWidget {
  const UserDetailProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgramModel program = Get.arguments['program'];
    final UserController userController = Get.find<UserController>();
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const Text(
                  "Detail Program",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Live Yoga Daily Streak Badge Header
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status Streak Yoga',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userController.yogaStreak.value == 0
                                  ? 'Yuk mulai sesi yoga hari ini!'
                                  : 'Rutinitas latihan terawat!',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      YogaStreakBadge(streak: userController.yogaStreak.value),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            programKehamilanContainer(program),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              program.desc,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Program ${program.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: program.months
                  .map((bulan) => monthContainer(bulan, program))
                  .toList(),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget programKehamilanContainer(ProgramModel program) {
    final String yogaHeaderImage = (program.image.isNotEmpty && !program.image.contains('flowers'))
        ? program.image
        : 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=500&auto=format&fit=crop&q=80';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: yogaHeaderImage,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 75,
                height: 75,
                color: Colors.pink.shade50,
                child: Icon(Icons.self_improvement_rounded, size: 36, color: ColorDouce.douceBase),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget monthContainer(Month bulan, ProgramModel program) {
    return InkWell(
      onTap: () => Get.toNamed('/user-program-bulan', arguments: {
        'month': bulan,
        'program': program,
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bulan ke - ${bulan.month}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
