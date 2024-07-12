import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRiwayatPage extends StatelessWidget {
  const UserRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;
    String jenisRiwayat = arguments["jenisRiwayat"];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  Text(
                    "Riwayat $jenisRiwayat",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              jenisRiwayat == "Konsultasi Doula"
                  ? doulaColumn()
                  : jenisRiwayat == "Layanan Kesehatan"
                      ? layananColumn()
                      : jenisRiwayat == "Artikel"
                          ? artikelColumn()
                          : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget doulaColumn() {
    return const Wrap(
      spacing: 20,
      runSpacing: 50,
      alignment: WrapAlignment.spaceAround,
      children: [
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
        DoulaContainer(),
      ],
    );
  }

  Widget layananColumn() {
    return const Column(
      children: [
        // RumahSakitContainer(),
        SizedBox(height: 20),
        // RumahSakitContainer(),
      ],
    );
  }

  Widget artikelColumn() {
    return const Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 20,
      runSpacing: 20,
      children: [
        // ArtikelContainer(),
        // ArtikelContainer(),
        // ArtikelContainer(),
        // ArtikelContainer(),
      ],
    );
  }
}
