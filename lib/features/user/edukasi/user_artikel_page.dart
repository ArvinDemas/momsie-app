import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserArtikelPage extends StatelessWidget {
  const UserArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArtikelModel artikel = Get.arguments as ArtikelModel;

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top Custom App Bar
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
                            boxShadow: AppElevation.level1,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ColorDouce.douceBase,
                            size: 20,
                          ),
                        ),
                      ),
                      const Text(
                        "Edukasi Medis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDark,
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
                      // 1. Grand Hero Artwork Banner
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppElevation.level3,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl: artikel.thumbnail,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 220,
                              color: ColorDouce.veryLightPink,
                              child: const Center(
                                child: Icon(Icons.article_rounded, size: 64, color: Color(0xFFFF6972)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // 2. Category & Read Time Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ColorDouce.douceBase.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              artikel.category,
                              style: TextStyle(
                                color: ColorDouce.douceBase,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                artikel.readTime,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            artikel.pubDate,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 3. Article Title
                      Text(
                        artikel.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDark,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 5. Medical Source Citation Card (Bukti Ilmiah / Sumber)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4), // Light Emerald
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sumber Terverifikasi & Referensi Medis:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    artikel.sources,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF166534),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 6. Key Takeaways Box (Poin-Poin Ringkasan)
                      if (artikel.keyPoints.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppElevation.level1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_rounded, color: ColorDouce.douceBase, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Poin Penting (Key Takeaways)",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppSemanticColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...artikel.keyPoints.map(
                                (point) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppSemanticColors.textDarkSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 7. Full Article Body Content (Formatted Markdown)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppElevation.level2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildFormattedArticleBody(artikel.description),
                        ),
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

  /// Helper untuk memformat teks artikel yang kaya akan paragraf, heading, dan poin-poin medis
  List<Widget> _buildFormattedArticleBody(String rawText) {
    final List<Widget> widgets = [];
    final lines = rawText.split('\n');

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 10));
        continue;
      }

      if (trimmed.startsWith('### ')) {
        // Subheading Level 3
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text(
              trimmed.replaceFirst('### ', ''),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppSemanticColors.textDark,
                height: 1.3,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        // Bullet Point
        final content = trimmed.replaceFirst('- ', '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, size: 6, color: Color(0xFFFF6972)),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRichText(content),
                ),
              ],
            ),
          ),
        );
      } else {
        // Normal Paragraph
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRichText(trimmed),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildRichText(String text) {
    // Memproses **bold** sederhana
    final parts = text.split('**');
    if (parts.length == 1) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppSemanticColors.textDarkSecondary,
          height: 1.6,
        ),
      );
    }

    final List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        // Bold part
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppSemanticColors.textDark,
            ),
          ),
        );
      } else {
        // Normal part
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: AppSemanticColors.textDarkSecondary,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, height: 1.6),
        children: spans,
      ),
    );
  }
}
