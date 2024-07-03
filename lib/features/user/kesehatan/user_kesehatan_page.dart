import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKesehatanPage extends StatelessWidget {
  const UserKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserKesehatanController userKesehatanController =
        Get.put(UserKesehatanController());

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                userKesehatanController.changeType("Rumah Sakit");
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: userKesehatanController.kesehatanType.value ==
                            "Rumah Sakit"
                        ? ColorDouce.douceBase
                        : ColorDouce.grayBackground,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  child: Text(
                    "Selanjutnya",
                    style: TextStyle(
                      fontSize: 16,
                      color: userKesehatanController.kesehatanType.value ==
                              "Rumah Sakit"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                userKesehatanController.changeType("Doula");
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color:
                        userKesehatanController.kesehatanType.value == "Doula"
                            ? ColorDouce.douceBase
                            : ColorDouce.grayBackground,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  child: Text(
                    "Doula",
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          userKesehatanController.kesehatanType.value == "Doula"
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
          () => userKesehatanController.kesehatanType.value == "Rumah Sakit"
              ? rumahSakitColum()
              : doulaColumn(),
        ),
      ],
    );
  }

  Widget rumahSakitColum() {
    return Column();
  }

  Widget doulaColumn() {
    return Column();
  }
}
