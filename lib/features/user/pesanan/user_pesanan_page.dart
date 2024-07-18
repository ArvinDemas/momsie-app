import 'package:douce/features/user/pesanan/user_pesanan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPesananPage extends StatelessWidget {
  const UserPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserPesananController controller = Get.put(UserPesananController());

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const Text(
                  "Pesanan",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      controller.changeSelectedPesanan("Aktif");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: controller.selectedPesanan.value == "Aktif"
                            ? ColorDouce.douceBase
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorDouce.douceBase),
                      ),
                      child: Center(
                        child: Text(
                          "Aktif",
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.selectedPesanan.value == "Aktif"
                                ? Colors.white
                                : ColorDouce.douceBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      controller.changeSelectedPesanan("Riwayat");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: controller.selectedPesanan.value == "Riwayat"
                            ? ColorDouce.douceBase
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColorDouce.douceBase),
                      ),
                      child: Center(
                        child: Text(
                          "Riwayat",
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.selectedPesanan.value == "Riwayat"
                                ? Colors.white
                                : ColorDouce.douceBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Obx(
              () => controller.selectedPesanan.value == "Aktif"
                  ? aktifColumn(controller)
                  : riwayatColumn(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget aktifColumn(UserPesananController controller) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        Obx(
          () => controller.pesanan.isEmpty &&
                  controller.pekerjaan.isEmpty &&
                  controller.active.isEmpty
              ? const Center(child: Text("Tidak ada pesanan"))
              : Column(
                  children: [
                    ...controller.active
                        .map((active) => activeContainer(active)),
                    ...controller.pekerjaan
                        .map((pesanan) => pekerjaanContainer(pesanan)),
                    ...controller.pesanan
                        .map((pesanan) => bookingContainer(pesanan)),
                  ],
                ),
        ),
      ],
    );
  }

  Widget riwayatColumn(UserPesananController controller) {
    return Wrap(
      children: [
        Obx(
          () => controller.riwayat.isEmpty
              ? const Center(child: Text("Tidak ada riwayat pesanan"))
              : Column(
                  children: controller.riwayat
                      .map((pesanan) => riwayatContainer(pesanan))
                      .toList()),
        ),
      ],
    );
  }

  Widget bookingContainer(PesananModel pesanan) {
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                      Text(pesanan.tanggal),
                      Text(" - ${pesanan.day}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text("Rp ${pesanan.harga}")
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
                      Text(pesanan.jam)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.timelapse),
                      SizedBox(width: 15),
                      Text("Pending"),
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
                  Get.toNamed("/confirm-register", arguments: {
                    "payment": int.parse(pesanan.harga),
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Cara Bayar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ColorDouce.douceBase),
                  ),
                  child: Center(
                    child: Text(
                      "Batalkan Pesanan",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorDouce.douceBase,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pekerjaanContainer(PesananModel pesanan) {
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                      Text(pesanan.tanggal),
                      Text(" - ${pesanan.day}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text("Rp ${pesanan.harga}")
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
                      Text(pesanan.jam)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.timelapse),
                      SizedBox(width: 15),
                      Text("Confirmed"),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ColorDouce.douceBase,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Pesanan Kamu Sudah Terkonfirmasi! Sedang Mencari Doula Untukmu",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget activeContainer(ActiveModel active) {
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
                    active.namaDoula,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                      Text(active.tanggal),
                      Text(" - ${active.day}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text("Rp ${active.harga}")
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
                      Text("Ongoing"),
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
                onTap: () => Get.toNamed('/chat-page', arguments: {
                  "doula": active.doula,
                  "user": active.pemesan,
                  "isDoula": false,
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Hubungi Doula",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget riwayatContainer(ActiveModel active) {
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
                    active.namaDoula,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                      Text(active.tanggal),
                      Text(" - ${active.day}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 15),
                      Text("Rp ${active.harga}")
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
                      Text("Finished"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
