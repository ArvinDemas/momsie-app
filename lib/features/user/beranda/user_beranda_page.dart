import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:douce/shared/widget/rumah_sakit_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBerandaPage extends StatelessWidget {
  const UserBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      childWidget: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      DoulaContainer(),
                      SizedBox(width: 15),
                      DoulaContainer(),
                      SizedBox(width: 15),
                      DoulaContainer(),
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
                const Column(
                  children: [
                    RumahSakitContainer(),
                    SizedBox(height: 10),
                    RumahSakitContainer(),
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
    return InkWell(
      onTap: () => Get.toNamed("/detail-artikel"),
      child: Container(
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
      ),
    );
  }
}
