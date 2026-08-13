import 'dart:io';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class DetailDoulaPage extends StatelessWidget {
  const DetailDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DoulaModel doula = Get.arguments["doula"];

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
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
                                Icons.arrow_back_ios_new_rounded,
                                color: ColorDouce.douceBase,
                              ),
                            ),
                            const Text(
                              "Detail Doula",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: doula.image.startsWith('http')
                                    ? Image.network(
                                        doula.image,
                                        width: 120,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(doula.image),
                                        width: 120,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 120,
                                          height: 140,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.person, size: 60, color: Colors.grey),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doula.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black90,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doula.job,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: ColorDouce.douceBase,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            doula.alamat,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black12, thickness: 1),
                        const SizedBox(height: 15),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          children: [
                            informationCircle(doula.jenisKelamin, Icons.female_rounded),
                            informationCircle("Bersertifikasi", Icons.verified_user_rounded),
                            informationCircle(doula.job, Icons.medical_services_rounded),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Biografi & Kualifikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          doula.biografi,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky Booking Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/confirm-booking', arguments: {'doula': doula});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.vertical(14),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Pesan / Booking Doula Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget informationCircle(String title, IconData icon) {
    return SizedBox(
      width: 85,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorDouce.kindaRed,
            ),
            padding: const EdgeInsets.all(14),
            child: Icon(
              icon,
              color: ColorDouce.douceBase,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorDouce.douceBase,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
