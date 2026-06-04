import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';

class DetailRumahSakitPage extends StatelessWidget {
  const DetailRumahSakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RumahSakitModel rumahSakit = Get.arguments;
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
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
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(
                          rumahSakit.image,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rumahSakit.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            rumahSakit.alamat,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange),
                              Text(
                                "4.9",
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          )
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
              Text(rumahSakit.layanan),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       "Doula",
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.black,
              //       ),
              //     ),
              //     Text(
              //       "Lihat Semua",
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: ColorDouce.douceBase,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 40),
              // const SingleChildScrollView(
              //   clipBehavior: Clip.none,
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       DoulaContainer(),
              //       DoulaContainer(),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 40),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       "Obat",
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.black,
              //       ),
              //     ),
              //     Text(
              //       "Lihat Semua",
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: ColorDouce.douceBase,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
              // const ObatContainer(),
              // const ObatContainer(),
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
        ],
      ),
    );
  }
}
