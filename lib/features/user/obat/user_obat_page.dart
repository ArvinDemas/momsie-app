import 'package:douce/features/user/obat/user_obat_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/obat_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserObatPage extends StatelessWidget {
  const UserObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserObatController controller = Get.put(UserObatController());
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
                Image.asset('assets/images/obat.png'),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Obat",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.isObatLoading.value
                            ? () {}
                            : Get.toNamed(
                                '/see-more',
                                arguments: {
                                  'title': 'Obat',
                                  'obat': controller.obatList,
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
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.isObatLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Wrap(
                          runSpacing: 20,
                          children: controller.obatList
                              .map(
                                (obat) => ObatContainer(
                                  obat: obat,
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
