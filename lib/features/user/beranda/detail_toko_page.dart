import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTokoPage extends StatelessWidget {
  const DetailTokoPage({super.key});

  Future<void> _openGoogleMaps(TokoBayiModel toko) async {
    final query = Uri.encodeComponent('${toko.nama} ${toko.alamat}');
    final String url = toko.mapUrl.isNotEmpty
        ? toko.mapUrl
        : 'https://www.google.com/maps/search/?api=1&query=$query';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildFallback();
    }
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _buildFallback(),
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }
    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: double.infinity,
      height: 240,
      color: ColorDouce.veryLightPink,
      child: const Center(
        child: Icon(Icons.storefront_rounded, size: 64, color: Color(0xFFFF6972)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Null-Safe Argument Extraction
    TokoBayiModel? tokoBayi;
    final rawArgs = Get.arguments;
    if (rawArgs is TokoBayiModel) {
      tokoBayi = rawArgs;
    }
    tokoBayi ??= DummyData.tokoBayis.first;

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Custom Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
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
                        "Detail Toko Bayi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 36),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // 1. Big Hero Photo Banner (Gedein Gambar biar tidak kecil & tidak kosong)
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
                          child: _buildImageWidget(tokoBayi.image),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // 2. Profile Info Card (Nama, Rating, Alamat)
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
                                    tokoBayi.nama,
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
                                        tokoBayi.rating,
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
                                    tokoBayi.alamat,
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

                      // 3. Google Maps Action Button (Merah Khas Pin Google Maps)
                      ElevatedButton(
                        onPressed: () => _openGoogleMaps(tokoBayi!),
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

                      // 4. Deskripsi Toko Card
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
                                Icon(Icons.storefront_rounded, color: Color(0xFFFF6972), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Informasi & Jam Operasional",
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
                              tokoBayi.desc,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Kategori Produk Unggulan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (tokoBayi.product.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Perlengkapan Bayi Newborn, Baju Hamil, Stroller, & Baby Care",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: tokoBayi.product
                              .map<Widget>((product) => _productChip(product))
                              .toList(),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productChip(String product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_rounded, color: ColorDouce.douceBase, size: 18),
          const SizedBox(width: 8),
          Text(
            product,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
