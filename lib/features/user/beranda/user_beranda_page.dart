import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBerandaPage extends StatelessWidget {
  const UserBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const TopBar(),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/beranda.png"),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Doula",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    topDoulaContainer(),
                    const SizedBox(width: 15),
                    topDoulaContainer(),
                    const SizedBox(width: 15),
                    topDoulaContainer(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Rumah Sakit Terdekat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  rumahSakitContainer(),
                  const SizedBox(height: 10),
                  rumahSakitContainer(),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Rekomendasi Toko Bayi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    tokoBayiContainer(),
                    const SizedBox(width: 15),
                    tokoBayiContainer(),
                    const SizedBox(width: 15),
                    tokoBayiContainer(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Artikel Terkini",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              artikelTerkiniContainer(),
              const SizedBox(height: 10),
              artikelTerkiniContainer(),
            ],
          ),
        )
      ],
    );
  }

  Widget topDoulaContainer() {
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

  Widget rumahSakitContainer() {
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

  Widget tokoBayiContainer() {
    return InkWell(
      onTap: () => Get.toNamed("/detail-toko"),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        width: 175,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/toko.png',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Baby Shop Jogja",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Text(
              "Jl. Kesehatan No. 1, Sekip, Yogyakarta",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget artikelTerkiniContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/artikel.png',
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "By Lionel Messi",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Panduan Nutrisi yang penting",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Jun 12, 2024",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
