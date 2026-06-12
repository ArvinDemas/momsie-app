import 'package:douce/features/user/diary/diary_controller.dart';
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
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diary Kehamilan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              'Abadikan setiap momen berharga',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // PDF export
                      IconButton(
                        tooltip: 'Ekspor PDF Album',
                        icon: Icon(Icons.picture_as_pdf_outlined,
                            color: ColorDouce.douceBase),
                        onPressed: () => Get.toNamed('/diary-pdf'),
                      ),
                      // Add new
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
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // List
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (c.entries.isEmpty) {
                      return _buildEmpty(c);
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      itemCount: c.entries.length,
                      itemBuilder: (_, i) =>
                          _DiaryCard(entry: c.entries[i], controller: c),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📖', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada catatan diary',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Text(
            'Abadikan perasaan & momen kehamilan\nmu hari ini!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              c.initForm();
              Get.toNamed('/diary-form');
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Tulis Diary Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final DiaryModel entry;
  final DiaryController controller;
  const _DiaryCard({required this.entry, required this.controller});

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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo strip (if any)
            if (entry.photoUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18)),
                child: SizedBox(
                  height: 140,
                  child: entry.photoUrls.length == 1
                      ? Image.network(
                          entry.photoUrls.first,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox.shrink(),
                        )
                      : Row(
                          children: entry.photoUrls.take(2).map((url) {
                            return Expanded(
                              child: Image.network(
                                url,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const SizedBox.shrink(),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Mood emoji
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ColorDouce.kindaRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${entry.moodEmoji} ${entry.moodLabel}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ColorDouce.veryLightPink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🤱 Minggu ${entry.pregnancyWeek}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black54),
                        ),
                      ),
                      const Spacer(),
                      // Options menu
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded,
                            color: Colors.grey, size: 20),
                        onSelected: (v) {
                          if (v == 'edit') {
                            controller.initForm(entry: entry);
                            Get.toNamed('/diary-form',
                                arguments: entry);
                          } else if (v == 'delete') {
                            Get.defaultDialog(
                              title: 'Hapus Diary?',
                              middleText:
                                  'Entri ini akan dihapus permanen.',
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
                              child: Row(children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Edit')
                              ])),
                          PopupMenuItem(
                              value: 'delete',
                              child: Row(children: [
                                Icon(Icons.delete_outline,
                                    size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Hapus',
                                    style:
                                        TextStyle(color: Colors.red))
                              ])),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (entry.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.content,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey),
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
