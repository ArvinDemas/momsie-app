import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryListPage extends StatelessWidget {
  const DiaryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DiaryController c = Get.put(DiaryController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppSemanticColors.textDark),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diary Kehamilan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Abadikan kenangan momen indah kehamilan',
                              style: TextStyle(fontSize: 11, color: AppSemanticColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      // PDF Export Button
                      IconButton(
                        tooltip: 'Ekspor PDF Album Kenangan',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.picture_as_pdf_outlined, color: ColorDouce.douceBase, size: 20),
                        ),
                        onPressed: () => Get.toNamed('/diary-pdf'),
                      ),
                      const SizedBox(width: 4),
                      // Add New Entry Button
                      GestureDetector(
                        onTap: () {
                          c.initForm();
                          Get.toNamed('/diary-form');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppElevation.softColor(ColorDouce.douceBase),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Main Entries List
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (c.entries.isEmpty) {
                      return _buildEmpty(c);
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: c.entries.length,
                      itemBuilder: (_, i) => _DiaryCard(entry: c.entries[i], controller: c),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(DiaryController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorDouce.veryLightPink,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.book_rounded, size: 64, color: ColorDouce.douceBase),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Catatan Diary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppSemanticColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Abadikan perasaan, foto USG, dan cerita indah perkembangan si buah hati.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                c.initForm();
                Get.toNamed('/diary-form');
              },
              icon: const Icon(Icons.edit_note_rounded, size: 22),
              label: const Text('Tulis Diary Pertama'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final DiaryModel entry;
  final DiaryController controller;
  const _DiaryCard({required this.entry, required this.controller});

  Widget _buildPhotoItem(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: url,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _photoFallback(),
      );
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(
        file,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _photoFallback(),
      );
    }
    return _photoFallback();
  }

  Widget _photoFallback() {
    return Container(
      height: 140,
      width: double.infinity,
      color: ColorDouce.veryLightPink,
      child: const Center(
        child: Icon(Icons.photo_rounded, size: 36, color: Color(0xFFFF6972)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${entry.createdAt.day.toString().padLeft(2, '0')}/'
        '${entry.createdAt.month.toString().padLeft(2, '0')}/'
        '${entry.createdAt.year}';

    return GestureDetector(
      onTap: () => Get.toNamed('/diary-detail', arguments: entry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppElevation.level2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Strip (If photos exist)
              if (entry.photoUrls.isNotEmpty)
                SizedBox(
                  height: 140,
                  child: entry.photoUrls.length == 1
                      ? _buildPhotoItem(entry.photoUrls.first)
                      : Row(
                          children: entry.photoUrls.take(2).map((url) {
                            return Expanded(
                              child: _buildPhotoItem(url),
                            );
                          }).toList(),
                        ),
                ),

              // Card Body Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Mood Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorDouce.kindaRed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(entry.moodEmoji, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                entry.moodLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppSemanticColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pregnancy Week Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorDouce.veryLightPink,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            entry.ageLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Popup Menu
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                          onSelected: (v) {
                            if (v == 'edit') {
                              controller.initForm(entry: entry);
                              Get.toNamed('/diary-form', arguments: entry);
                            } else if (v == 'delete') {
                              Get.defaultDialog(
                                title: 'Hapus Diary?',
                                middleText: 'Entri ini akan dihapus secara permanen.',
                                textConfirm: 'Hapus',
                                textCancel: 'Batal',
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.red,
                                onConfirm: () {
                                  Get.back();
                                  controller.deleteEntry(entry);
                                },
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (entry.content.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.content,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppSemanticColors.textDarkSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        if (entry.photoUrls.isNotEmpty) ...[
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.photo_library_rounded, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${entry.photoUrls.length} Foto',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ],
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
