import 'package:douce/features/user/diary/diary_controller.dart';
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
        '${entry.createdAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // SliverAppBar with photo as header
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: entry.photoUrls.isNotEmpty ? 260 : 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: Icon(Icons.edit_rounded,
                            color: Colors.white, size: 18),
                      ),
                      onPressed: () {
                        c.initForm(entry: entry);
                        Get.toNamed('/diary-form', arguments: entry);
                      },
                    ),
                  ],
                  flexibleSpace: entry.photoUrls.isNotEmpty
                      ? FlexibleSpaceBar(
                          background: _PhotoCarousel(
                              urls: entry.photoUrls),
                        )
                      : null,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorDouce.kindaRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${entry.moodEmoji} ${entry.moodLabel}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorDouce.veryLightPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '🤱 Minggu ${entry.pregnancyWeek}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Title
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Date
                        Text(
                          dateStr,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),

                        if (entry.content.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            entry.content,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pc,
          onPageChanged: (i) => setState(() => _current = i),
          itemCount: widget.urls.length,
          itemBuilder: (_, i) => Image.network(
            widget.urls[i],
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFFEEEEEE),
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        if (widget.urls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.urls.asMap().entries.map((e) {
                return Container(
                  width: _current == e.key ? 16 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _current == e.key
                        ? Colors.white
                        : Colors.white54,
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
