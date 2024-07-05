import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:douce/shared/widget/obat_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailRumahSakitPage extends StatelessWidget {
  const DetailRumahSakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
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
                  const Text(
                    "Detail Rumah Sakit",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.heart_broken_rounded,
                    color: ColorDouce.douceBase,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/rs.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "RSUP Dr. Sardjito",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Jl. Kaliurang KM 5,5 Yogyakarta",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Row(children: [
                            Icon(Icons.star, color: Colors.orange),
                            Text(
                              "4.9",
                              style: TextStyle(fontSize: 14),
                            )
                          ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                height: 10,
                thickness: 0.7,
              ),
              const SizedBox(height: 20),
              const Text(
                "Layanan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Pemeriksaan Kehamilan Rutin, blablabla"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Doula",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
              const SizedBox(height: 40),
              const SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DoulaContainer(),
                    DoulaContainer(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Obat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
              const ObatContainer(),
              const ObatContainer(),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Get.toNamed('/chat-page'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Hubungi Kami",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
