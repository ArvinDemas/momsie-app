import 'package:douce/features/mitra/akun/mitra_riwayat_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraRiwayatPage extends StatelessWidget {
  const MitraRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mitraRiwayatController = Get.put(MitraRiwayatController());

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          mitraTopBar(context),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        mitraRiwayatController.changeRiwayat("Selanjutnya");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: mitraRiwayatController.riwayat.value ==
                                    "Selanjutnya"
                                ? ColorDouce.douceBase
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Selanjutnya",
                            style: TextStyle(
                              fontSize: 16,
                              color: mitraRiwayatController.riwayat.value ==
                                      "Selanjutnya"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        mitraRiwayatController.changeRiwayat("Sebelumnya");
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: mitraRiwayatController.riwayat.value ==
                                    "Sebelumnya"
                                ? ColorDouce.douceBase
                                : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: ColorDouce.douceBase,
                            ),
                          ),
                          child: Text(
                            "Sebelumnya",
                            style: TextStyle(
                              fontSize: 16,
                              color: mitraRiwayatController.riwayat.value ==
                                      "Sebelumnya"
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
                  () => mitraRiwayatController.riwayat.value == "Selanjutnya"
                      ? selanjutnyaColumn()
                      : sebelumnyaColumn(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selanjutnyaColumn() {
    return Column(
      children: [
        historyJobContainer(),
      ],
    );
  }

  Widget sebelumnyaColumn() {
    return Column(
      children: [
        historyJobContainer(),
        const SizedBox(height: 10),
        historyJobContainer(),
        const SizedBox(height: 10),
        historyJobContainer(),
      ],
    );
  }

  Widget historyJobContainer() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
                Icons.video_call,
                size: 60,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Panggilan Video",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Al Ikhsan Akbar Fatahillah",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorDouce.veryLightPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "SPK",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorDouce.douceBase,
                  ),
                ),
              )
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

  Widget mitraTopBar(context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: ColorDouce.douceBase,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Riwayat Kerja",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.transparent,
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 115,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                width: MediaQuery.of(context).size.width - 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Cari Kategori, Obat',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Open-Sans',
                      fontWeight: FontWeight.w300,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
