import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/features/mitra/status/mitra_status_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraStatusPage extends StatelessWidget {
  const MitraStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraStatusController mitraStatusController =
        Get.put(MitraStatusController());

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        mitraStatusController.changeStatus("Berjalan");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                mitraStatusController.status.value == "Berjalan"
                                    ? ColorDouce.douceBase
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Berjalan",
                            style: TextStyle(
                              fontSize: 16,
                              color: mitraStatusController.status.value ==
                                      "Berjalan"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        mitraStatusController.changeStatus("Terkonfirmasi");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: mitraStatusController.status.value ==
                                    "Terkonfirmasi"
                                ? ColorDouce.douceBase
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Terkonfirmasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: mitraStatusController.status.value ==
                                      "Terkonfirmasi"
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
                  () => mitraStatusController.status.value == "Berjalan"
                      ? berjalanColumn(context)
                      : terkonfirmasiColumn(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget berjalanColumn(context) {
    return Wrap(
      runSpacing: 20,
      children: Get.find<MitraPekerjaanController>()
          .active
          .map(
            (active) => jobContainer(context, active),
          )
          .toList(),
    );
  }

  Widget terkonfirmasiColumn() {
    return Wrap(
      runSpacing: 20,
      children: Get.find<MitraPekerjaanController>()
          .riwayat
          .map(
            (riwayat) => terkonfirmasiJobContainer(riwayat),
          )
          .toList(),
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
                          onTap: () {
                            Get.find<MitraPekerjaanController>()
                                .checkOut(active);
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

  Widget terkonfirmasiJobContainer(ActiveModel riwayat) {
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
                    riwayat.layanan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    riwayat.namaUser,
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
              const Text("Tanggal:"),
              Text("${riwayat.tanggal} ${riwayat.day}"),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Harga:"),
              Text(riwayat.harga.toString()),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Waktu:"),
              Text(riwayat.jam),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Durasi:"),
              Text("1 Jam"),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lokasi:"),
              Text("-"),
            ],
          ),
        ],
      ),
    );
  }
}
