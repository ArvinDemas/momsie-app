import 'package:douce/features/user/edukasi/user_detailgerakan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/widget/alert_dialog.dart';
import 'package:flutter/material.dart';
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
      showCustomDialog(context, program, week, month, move);
    };

    return Scaffold(
      body: SafeArea(
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
              child: Image.network(
                move.image,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
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
                                    context, program, week, month, move);
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

  void showCustomDialog(BuildContext context, ProgramModel program, Week week,
      Month month, Move move) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          isSuccess: true,
          descText: "Silahkan Kembali Besok Untuk Program Yoga Selanjutnya",
          destination: '/user',
          onTap: () {
            Get.offAllNamed('/user');
          },
        );
      },
    );
  }
}
