import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraPekerjaanPage extends StatelessWidget {
  const MitraPekerjaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraPekerjaanController controller =
        Get.find<MitraPekerjaanController>();
    final UserController userController = Get.find<UserController>();
    return BasePage(
      isDoula: true,
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${controller.currentMonth} ${controller.currentYear}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.dates
                        .map(
                          (date) => calendarContainer(
                            DateFormat('E').format(date),
                            date.day.toString(),
                            controller,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Pekerjaan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.pekerjaan
                        .where((element) =>
                            element.tanggal == controller.selectedTanggal.value)
                        .where((element) =>
                            element.namaUser != userController.username.value)
                        .map((pesanan) => jobContainer(pesanan))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget calendarContainer(
    String day,
    String date,
    MitraPekerjaanController controller,
  ) {
    return InkWell(
      onTap: () {
        controller.selectedTanggal.value = date;
      },
      child: Container(
        decoration: BoxDecoration(
          color: controller.selectedTanggal.value == date
              ? ColorDouce.douceBase
              : ColorDouce.kindaRed,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 16,
                color: controller.selectedTanggal.value == date
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 24,
                color: controller.selectedTanggal.value == date
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget jobContainer(PesananModel pesanan) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                size: 60,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pesanan.layanan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pesanan.namaUser,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 0.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 15),
                      Text(
                        "${pesanan.tanggal} ${pesanan.day}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text(
                        pesanan.harga,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 15),
                      Text(pesanan.jam),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.timelapse),
                      SizedBox(width: 15),
                      Text("1 Jam")
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () =>
                Get.find<MitraPekerjaanController>().klaimPekerjaan(pesanan),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorDouce.douceBase,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Klaim",
                    style: TextStyle(
                      color: ColorDouce.douceBase,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
