import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card Rumah Sakit Hero Gede 1 Per Baris
class RumahSakitContainer extends StatelessWidget {
  const RumahSakitContainer({
    super.key,
    this.fullWidth = true,
    this.onTap,
    required this.rumahSakit,
  });

  final bool fullWidth;
  final Function? onTap;
  final RumahSakitModel rumahSakit;

  Future<void> _openGoogleMaps() async {
    final query = Uri.encodeComponent('${rumahSakit.nama} ${rumahSakit.alamat}');
    final String url = rumahSakit.mapUrl.isNotEmpty
        ? rumahSakit.mapUrl
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.toNamed("/detail-rumah-sakit", arguments: rumahSakit);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: fullWidth ? double.infinity : 310,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppElevation.level2,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Image High Hero Area (170px Height)
              Stack(
                children: [
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: _buildImageWidget(rumahSakit.image),
                  ),

                  // Gradient overlay on bottom of image for contrast
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Top Left Badge ("RUMAH SAKIT")
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_hospital_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'RUMAH SAKIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top Right Rating Badge
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rumahSakit.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Info Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rumahSakit.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            rumahSakit.alamat,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppSemanticColors.textDarkSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (rumahSakit.layanan.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: ColorDouce.veryLightPink,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          rumahSakit.layanan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    // Action CTA Row with Prominent Google Maps Button (Arrow Circle Removed)
                    InkWell(
                      onTap: _openGoogleMaps,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA4335).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEA4335).withValues(alpha: 0.25)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_rounded, size: 18, color: Color(0xFFEA4335)),
                            SizedBox(width: 6),
                            Text(
                              'Buka di Google Maps',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA4335),
                              ),
                            ),
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

  static final Map<String, String> _localAssetMap = {
    'rskia sadewa': 'assets/images/rskia_sadewa.jpg',
    'rskia rachmi': 'assets/images/rskia_rachmi.jpg',
    'rsu sakina idaman': 'assets/images/rsu_sakina_idaman.jpg',
    'rskia permata bunda': 'assets/images/rskia_permata_bunda.jpg',
    'rskia pku muhammadiyah kotagede': 'assets/images/rskia_pku_kotagede.jpg',
    'rsia arvita bunda': 'assets/images/rsia_arvita_bunda.webp',
    'rumah bersalin khadijah': 'assets/images/rumah_bersalin_khadijah.jpg',
    'hermina hospital yogya': 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=600&auto=format&fit=crop&q=80',
    'rumah sakit jih': 'assets/images/rumah_sakit_jih.webp',
    'siloam hospitals yogyakarta': 'assets/images/siloam_hospitals.jpg',
    'rumah sakit bethesda yogyakarta': 'assets/images/rs_bethesda.jpg',
    'rumah sakit panti rapih': 'assets/images/rs_panti_rapih.jpg',
    'rs happy land medical centre': 'assets/images/rs_happy_land.jpg',
    'rsi hidayatullah': 'assets/images/rsi_hidayatullah.jpg',
  };

  String _resolveLocalAsset(String nama) {
    final key = nama.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    if (_localAssetMap.containsKey(key)) {
      return _localAssetMap[key]!;
    }
    for (var entry in _localAssetMap.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) {
        return entry.value;
      }
    }
    return '';
  }

  Widget _buildImageWidget(String imagePath) {
    final cleanPath = imagePath.trim();
    if (cleanPath.startsWith('assets/')) {
      return Image.asset(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackForHospital(),
      );
    }
    if (cleanPath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: cleanPath,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _fallbackForHospital(),
      );
    }
    return _fallbackForHospital();
  }

  Widget _fallbackForHospital() {
    final assetOrUrl = _resolveLocalAsset(rumahSakit.nama);
    if (assetOrUrl.isNotEmpty) {
      if (assetOrUrl.startsWith('assets/')) {
        return Image.asset(
          assetOrUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }
      if (assetOrUrl.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: assetOrUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _buildFallback(),
        );
      }
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      color: ColorDouce.veryLightPink,
      child: const Center(
        child: Icon(Icons.local_hospital_rounded, size: 54, color: Color(0xFFFF6972)),
      ),
    );
  }
}
