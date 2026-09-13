import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryDetailPage extends StatelessWidget {
  const DiaryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DiaryModel entry = Get.arguments as DiaryModel;
    final DiaryController c = Get.find<DiaryController>();

    final dateStr =
        '${entry.createdAt.day.toString().padLeft(2, '0')}/'
        '${entry.createdAt.month.toString().padLeft(2, '0')}/'
        '${entry.createdAt.year} '
        '${entry.createdAt.hour.toString().padLeft(2, '0')}:'
        '${entry.createdAt.minute.toString().padLeft(2, '0')} WIB';

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // SliverAppBar with photo carousel as header
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: entry.photoUrls.isNotEmpty ? 280 : 0,
                  pinned: true,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      onPressed: () {
                        c.initForm(entry: entry);
                        Get.toNamed('/diary-form', arguments: entry);
                      },
                    ),
                  ],
                  flexibleSpace: entry.photoUrls.isNotEmpty
                      ? FlexibleSpaceBar(
                          background: _PhotoCarousel(urls: entry.photoUrls),
                        )
                      : null,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges Row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorDouce.kindaRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(entry.moodEmoji, style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    entry.moodLabel,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppSemanticColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorDouce.veryLightPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                entry.isBabyBorn ? '👶 ${entry.ageLabel}' : '🤱 Usia Kehamilan: ${entry.ageLabel}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppSemanticColors.textDark,
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Date Tag
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              dateStr,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),

                        if (entry.content.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              entry.content,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.7,
                                color: AppSemanticColors.textDarkSecondary,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 40),
                      ],
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
}

class _PhotoCarousel extends StatefulWidget {
  final List<String> urls;
  const _PhotoCarousel({required this.urls});

  @override
  State<_PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<_PhotoCarousel> {
  int _current = 0;
  final PageController _pc = PageController();

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget _buildPhotoItem(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorWidget: (_, __, ___) => _photoFallback(),
      );
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _photoFallback(),
      );
    }
    return _photoFallback();
  }

  Widget _photoFallback() {
    return Container(
      color: ColorDouce.veryLightPink,
      width: double.infinity,
      child: const Center(
        child: Icon(Icons.photo_rounded, size: 48, color: Color(0xFFFF6972)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pc,
          onPageChanged: (i) => setState(() => _current = i),
          itemCount: widget.urls.length,
          itemBuilder: (_, i) => _buildPhotoItem(widget.urls[i]),
        ),
        if (widget.urls.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.urls.asMap().entries.map((e) {
                return Container(
                  width: _current == e.key ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _current == e.key
                        ? Colors.white
                        : Colors.white60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
