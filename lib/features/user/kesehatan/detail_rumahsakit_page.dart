import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/animated_gradient_background.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRumahSakitPage extends StatelessWidget {
  const DetailRumahSakitPage({super.key});

  Future<void> _openGoogleMaps(RumahSakitModel rs) async {
    final query = Uri.encodeComponent('${rs.nama} ${rs.alamat}');
    final String url = rs.mapUrl.isNotEmpty
        ? rs.mapUrl
        : 'https://www.google.com/maps/search/?api=1&query=$query';
    final Uri uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  Future<void> _openWhatsApp(RumahSakitModel rs) async {
    final String text = Uri.encodeComponent(
      'Halo ${rs.nama}, saya ingin berkonsultasi mengenai informasi layanan persalinan & kebidanan di ${rs.nama}.',
    );
    final String waUrl = 'https://wa.me/6281234567890?text=$text';
    final Uri uri = Uri.parse(waUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildFallbackImage();
    }
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _buildFallbackImage(),
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }
    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackImage(),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 240,
      color: ColorDouce.veryLightPink,
      child: const Center(
        child: Icon(Icons.local_hospital_rounded, size: 64, color: Color(0xFFFF6972)),
      ),
    );
  }

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
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ColorDouce.douceBase,
                            size: 20,
                          ),
                        ),
                      ),
                      const Text(
                        "Detail Rumah Sakit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 36),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 1. Big Hero Photo Card (Gedein Gambar biar ga kosong)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _buildImageWidget(rumahSakit.image),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Profile Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                rumahSakit.nama,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade700,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    rumahSakit.rating,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_rounded, size: 18, color: Colors.redAccent),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                rumahSakit.alamat,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF475569),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Google Maps Action Button (Merah Khas Google Maps Pin)
                  ElevatedButton(
                    onPressed: () => _openGoogleMaps(rumahSakit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA4335), // Signature Google Red / Pin Red
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Petunjuk Arah di Google Maps",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. Layanan & Fasilitas Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.medical_services_rounded, color: Color(0xFFFF6972), size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Layanan & Fasilitas Utama",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          rumahSakit.layanan,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5. WhatsApp Contact Button
                  ElevatedButton(
                    onPressed: () => _openWhatsApp(rumahSakit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Hubungi RS via WhatsApp",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
