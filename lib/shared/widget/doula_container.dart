import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Card Doula Rombakan Total Bergaya Apple Arcade Card
/// Sesuai Gambar Referensi: Top Artwork 65% + Bottom Frosted Gradient Overlay + Pristine White Pill CTA
class DoulaContainer extends StatelessWidget {
  const DoulaContainer({
    super.key,
    required this.doula,
  });

  final DoulaModel doula;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed("/detail-doula", arguments: {
        "doula": doula,
      }),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 245,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Top Artwork Image (65% Height Area)
              _buildImageWidget(doula.image),

              // 2. Dark Gradient Overlay for High Contrast Text
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),

              // 3. Top Sub-Tag ("MOMSIE DOULA")
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_rounded, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        doula.sertifikasi.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Bottom Frosted Content Overlay & White Pill CTA
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      doula.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      doula.job,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Pristine White Pill Button ("PESAN")
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed("/detail-doula", arguments: {
                          "doula": doula,
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          elevation: 2,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PESAN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorDouce.douceBase, const Color(0xFFFF9A9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 54, color: Colors.white),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildFallbackImage();
    }
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _buildFallbackImage(),
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackImage(),
    );
  }
}
