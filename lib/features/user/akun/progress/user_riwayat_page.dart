import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/artikel_container.dart';
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
      backgroundColor: ColorDouce.grayBackground,
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
    return Column(
      children: [
        layananContainer(),
        const SizedBox(height: 20),
        layananContainer(),
      ],
    );
  }

  Widget artikelColumn() {
    return const Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 20,
      runSpacing: 20,
      children: [
        ArtikelContainer(),
        ArtikelContainer(),
        ArtikelContainer(),
        ArtikelContainer(),
      ],
    );
  }

  Widget layananContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              'assets/images/rs.png',
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RSUP Dr. Sardjito",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 20,
                    color: Colors.orange,
                  ),
                  Text(
                    "4.9",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    " | 400m",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Text(
            "Jl. Kesehatan No. 1, Sekip, Yogyakarta",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
