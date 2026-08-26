import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/edukasi/user_detailgerakan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserDetailGerakanPage extends StatelessWidget {
  const UserDetailGerakanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserDetailGerakanController gerakanController =
        Get.put(UserDetailGerakanController());

    final ProgramModel program = Get.arguments['program'];
    final Week week = Get.arguments['week'];
    final Month month = Get.arguments['month'];
    final Move move = Get.arguments['move'];

    gerakanController.timerSecond.value = move.time;
    gerakanController.onTimeEnd = () {
      showCustomDialog(context, program, week, month, move, gerakanController);
    };

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
                    gerakanController.explanationState.value
                        ? Get.back()
                        : gerakanController.changeExplanationState();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const Text(
                  "Detail Gerakan",
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: move.image,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                move.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Column(
                children: [
                  gerakanController.explanationState.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Petunjuk",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              move.petunjuk,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 20),
                            buttonContainer(
                              "Mulai",
                              () => gerakanController.changeExplanationState(),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "${move.time / 60} Menit",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: CircularProgressIndicator(
                                    value: gerakanController.timerSecond.value /
                                        move.time,
                                    color: ColorDouce.douceBase,
                                    backgroundColor: ColorDouce.kindaRed,
                                    strokeWidth: 10,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Text(
                                  gerakanController.timerString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: () => gerakanController.timerClick(),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorDouce.douceBase,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Icon(
                                  gerakanController.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            buttonContainer(
                              "Selesai",
                              () {
                                showCustomDialog(
                                    context, program, week, month, move, gerakanController);
                              },
                            )
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget buttonContainer(String descButton, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorDouce.douceBase,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            descButton,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCustomDialog(
      BuildContext context,
      ProgramModel program,
      Week week,
      Month month,
      Move move,
      UserDetailGerakanController controller) async {
    final int newStreak = await controller.recordYogaCompletion();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B8B).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF6B8B),
                    size: 54,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Yoga Selesai! 🎉',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    '🔥 $newStreak Hari Streak Yoga Berturut-turut!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Luar biasa Bunda! Latihan pernapasan & kelenturan panggul hari ini telah berhasil diselesaikan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed('/user'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorDouce.douceBase,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
