import 'package:douce/shared/theme/color.dart';
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
    return Wrap(
      spacing: 20,
      runSpacing: 50,
      children: [
        doulaContainer(),
        doulaContainer(),
        doulaContainer(),
        doulaContainer(),
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
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        artikelContainer(),
        artikelContainer(),
        artikelContainer(),
        artikelContainer(),
      ],
    );
  }

  Widget doulaContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: Image.asset(
                    "assets/images/topdoula.png",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, 125),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ColorDouce.douceBase,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dr. Zahra",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                  ],
                )
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Text(
              "Ahli Gizi",
              style: TextStyle(
                color: ColorDouce.douceBase,
              ),
            ),
          ),
        ],
      ),
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

  Widget artikelContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 175,
      decoration: BoxDecoration(
        color: ColorDouce.douceBase,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/artikel.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "By Lionel Messi",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const Text(
            "Tips dan Trik untuk Ibu Hamil",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "10 Agustus 2021",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
