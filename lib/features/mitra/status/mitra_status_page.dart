import 'package:douce/features/mitra/status/mitra_status_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraStatusPage extends StatelessWidget {
  const MitraStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mitraStatusController = Get.put(MitraStatusController());

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const TopBar(),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
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
                                  : ColorDouce.grayBackground,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: ColorDouce.douceBase,
                          ),
                        ),
                        child: Text(
                          "Berjalan",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                mitraStatusController.status.value == "Berjalan"
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
                              : ColorDouce.grayBackground,
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
                    ? berjalanColumn()
                    : terkonfirmasiColumn(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget berjalanColumn() {
    return Column(
      children: [
        berjalanJobContainer(),
        const SizedBox(height: 20),
        berjalanJobContainer(),
        const SizedBox(height: 20),
        berjalanJobContainer(),
      ],
    );
  }

  Widget terkonfirmasiColumn() {
    return Column(
      children: [
        terkonfirmasiJobContainer(),
        const SizedBox(height: 20),
        terkonfirmasiJobContainer(),
        const SizedBox(height: 20),
        terkonfirmasiJobContainer(),
      ],
    );
  }

  Widget berjalanJobContainer() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.video_call,
                size: 60,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Panggilan Video",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Al Ikhsan Akbar Fatahillah",
                    style: TextStyle(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(width: 15),
                      Text(
                        "21 Maret 2024",
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(width: 15),
                      Text("Rp. 50.000")
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 15),
                      Text("02.00 PM")
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
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
                      "Check In",
                      style: TextStyle(
                        color: ColorDouce.douceBase,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
            ],
          )
        ],
      ),
    );
  }

  Widget terkonfirmasiJobContainer() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.video_call,
                size: 60,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Panggilan Video",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Al Ikhsan Akbar Fatahillah",
                    style: TextStyle(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tanggal:"),
              Text("9 Januari 2024"),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Harga:"),
              Text("Rp 70.000"),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Waktu:"),
              Text("02.00 PM"),
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
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pengajuan:"),
              Text("8 Januari 2024"),
            ],
          )
        ],
      ),
    );
  }
}
