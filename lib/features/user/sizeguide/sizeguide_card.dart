import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/sizeguide/sizeguide_controller.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Hero Feature Card di Beranda (Apple Arcade Card Style)
/// Menampilkan teaser perkembangan janin tanpa emoji, mengarah ke SizeGuidePage
class SizeGuideCard extends StatefulWidget {
  const SizeGuideCard({super.key});

  @override
  State<SizeGuideCard> createState() => _SizeGuideCardState();
}

class _SizeGuideCardState extends State<SizeGuideCard> {
  late final SizeGuideController c;

  @override
  void initState() {
    super.initState();
    // Get.put hanya dipanggil SEKALI di initState — mencegah assertion error
    c = Get.isRegistered<SizeGuideController>()
        ? Get.find<SizeGuideController>()
        : Get.put(SizeGuideController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppElevation.level3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Artwork Image (User-Designed Perkembangan Janin Banner)
            Image.asset(
              'assets/images/banner_perkembangan_janin.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=800',
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorDouce.douceBase, const Color(0xFFFF9A9E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Subtle Dark Gradient Overlay for Contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Top Header Tag
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.child_care_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'PERKEMBANGAN JANIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Frosted Card Content
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => Text(
                              'Minggu Ke-${c.pregnancyWeek.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              'Seukuran ${c.fruitName.value} (${c.lengthMetric.value})',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Pristine White Pill Button
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/size-guide'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppSemanticColors.textDark,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LIHAT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 13),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
