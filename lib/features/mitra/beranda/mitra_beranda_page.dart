import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraBerandaPage extends StatelessWidget {
  const MitraBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraPekerjaanController controller =
        Get.find<MitraPekerjaanController>();
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pekerjaan Aktif",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.active.isEmpty
                      ? Center(
                          child: Text(
                            "Belum Ada Pekerjaan Aktif",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorDouce.douceBase,
                            ),
                          ),
                        )
                      : Column(
                          children: controller.active
                              .map(
                                (active) => jobContainer(context, active),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget jobContainer(context, ActiveModel active) {
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
        ],
      ),
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
                    active.layanan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    active.namaUser,
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
                        "${active.tanggal} ${active.day}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text(active.harga.toString()),
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
                      Text(active.jam)
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
          Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed('/chat-page', arguments: {
                    "user": active.pemesan,
                    "doula": active.doula,
                    "isDoula": true,
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
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
                        "Chat",
                        style: TextStyle(
                          color: ColorDouce.douceBase,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          descText:
                              "Pastikan Kamu Sudah Selesai Memberikan Layanan Kepada User !",
                          onTap: () async {
                            await Get.find<MitraPekerjaanController>()
                                .checkOut(active);
                            Get.back();
                          },
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
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
                        "Check Out",
                        style: TextStyle(
                          color: ColorDouce.douceBase,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
