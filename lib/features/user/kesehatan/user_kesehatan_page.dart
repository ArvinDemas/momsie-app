import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKesehatanPage extends StatelessWidget {
  const UserKesehatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserKesehatanController userKesehatanController =
        Get.put(UserKesehatanController());

    final TextEditingController searchController = TextEditingController();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          searchTextField(searchController),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      "Rumah Sakit",
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
              const SizedBox(width: 20),
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
                        color: userKesehatanController.kesehatanType.value ==
                                "Doula"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Obx(
            () => userKesehatanController.kesehatanType.value == "Rumah Sakit"
                ? rumahSakitColum()
                : doulaColumn(),
          ),
        ],
      ),
    );
  }

  Widget searchTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          size: 26,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        hintText: "Cari Rumah Sakit atau Dokter",
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget rumahSakitColum() {
    return const Column(
      children: [
        Text("Gapunya API buat maps bwang :("),
      ],
    );
  }

  Widget doulaColumn() {
    return const Wrap(
      spacing: 10,
      runSpacing: 50,
      children: [
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
      ],
    );
  }
}
