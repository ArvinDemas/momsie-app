import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class DetailDoulaPage extends StatelessWidget {
  const DetailDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Null-Safe Argument Extraction
    DoulaModel? doula;
    final rawArgs = Get.arguments;
    if (rawArgs is Map && rawArgs.containsKey("doula")) {
      doula = rawArgs["doula"] as DoulaModel?;
    } else if (rawArgs is DoulaModel) {
      doula = rawArgs;
    }
    doula ??= DummyData.doulas.first;

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppSemanticColors.textDark),
                        onPressed: Get.back,
                      ),
                      const Text(
                        "Detail Doula",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // 1. Foto Doula Besar (Large Hero Photo Card)
                      Container(
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppElevation.level2,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: _buildImageWidget(doula.image),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 2. Profile Info Container (Di bawah foto)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppElevation.level2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Lengkap
                            Text(
                              doula.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textDark,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Background
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ColorDouce.douceBase.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Background: ${doula.job}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorDouce.douceBase,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Domisili (Daerah Istimewa Yogyakarta)
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 18, color: Color(0xFFF43F5E)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    doula.alamat,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppSemanticColors.textDarkSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 14),

                            // Sertifikasi & Jenis Kelamin Pills
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _infoPill(
                                    doula.sertifikasi,
                                    doula.sertifikasi.contains('Certified')
                                        ? Icons.verified_rounded
                                        : Icons.workspace_premium_rounded,
                                  ),
                                  const SizedBox(width: 8),
                                  _infoPill(doula.jenisKelamin, Icons.female_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. Background & Kualifikasi Card (Biografi)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppElevation.level1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Background & Kualifikasi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              doula.biografi,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: AppSemanticColors.textDarkSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Sticky Bottom Booking CTA
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: AppElevation.level2,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/booking-doula', arguments: {'doula': doula});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Pesan / Booking Doula Sekarang',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
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

  Widget _buildFallbackAvatar() {
    return Container(
      width: 110,
      height: 130,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.person_rounded, size: 54, color: Colors.grey),
      ),
    );
  }

  Widget _infoPill(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.2)),
        boxShadow: AppElevation.level1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ColorDouce.douceBase, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: ColorDouce.douceBase,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildFallbackAvatar();
    }
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _buildFallbackAvatar(),
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackAvatar(),
      );
    }
    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackAvatar(),
    );
  }
}
