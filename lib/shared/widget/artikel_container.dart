import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Card Artikel Bergaya Modern Sesuai Referensi Media 1786666491571
class ArtikelContainer extends StatelessWidget {
  const ArtikelContainer({
    super.key,
    required this.artikel,
  });

  final ArtikelModel artikel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/user-artikel', arguments: artikel),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Artwork Image Area with Floating Badges
              Stack(
                children: [
                  SizedBox(
                    height: 145,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: artikel.thumbnail,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: ColorDouce.veryLightPink,
                        child: const Center(
                          child: Icon(Icons.article_rounded, size: 48, color: Color(0xFFFF6972)),
                        ),
                      ),
                    ),
                  ),

                  // Floating Bottom-Right Pill Badge (Reading Time e.g. "6 MIN")
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule_rounded, color: Colors.white, size: 10),
                          const SizedBox(width: 4),
                          Text(
                            artikel.readTime.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Text Details Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artikel.category,
                      style: TextStyle(
                        color: ColorDouce.douceBase,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artikel.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      artikel.pubDate,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
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
}
