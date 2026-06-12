import 'dart:io';
import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryFormPage extends StatelessWidget {
  const DiaryFormPage({super.key});

  static const List<String> _moods = [
    'happy', 'love', 'calm', 'tired', 'anxious', 'sad'
  ];

  @override
  Widget build(BuildContext context) {
    final DiaryController c = Get.find<DiaryController>();
    // editId null = tambah baru
    final DiaryModel? editEntry = Get.arguments as DiaryModel?;
    final isEdit = editEntry != null;

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
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          c.clearForm();
                          Get.back();
                        },
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Diary' : 'Tulis Diary Baru',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                      Obx(() => ElevatedButton(
                            onPressed: c.isSaving.value
                                ? null
                                : () => c.saveEntry(
                                      editId: editEntry?.id,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorDouce.douceBase,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: c.isSaving.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : const Text('Simpan'),
                          )),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood selector
                        const Text(
                          'Perasaanmu hari ini?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: _moods.map((mood) {
                                final isSelected =
                                    c.selectedMood.value == mood;
                                return GestureDetector(
                                  onTap: () =>
                                      c.selectedMood.value = mood,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorDouce.douceBase
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.07),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          DiaryModel.moodEmojis[mood] ??
                                              '😊',
                                          style: const TextStyle(
                                              fontSize: 24),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          DiaryModel.moodLabels[mood] ??
                                              mood,
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),

                        const SizedBox(height: 20),

                        // Pregnancy week slider
                        Obx(() => Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minggu Kehamilan: ${c.editingWeek.value}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Slider(
                                  value:
                                      c.editingWeek.value.toDouble(),
                                  min: 1,
                                  max: 42,
                                  divisions: 41,
                                  activeColor: ColorDouce.douceBase,
                                  label: 'Minggu ${c.editingWeek.value}',
                                  onChanged: (v) =>
                                      c.editingWeek.value = v.round(),
                                ),
                              ],
                            )),

                        const SizedBox(height: 4),

                        // Title field
                        TextField(
                          controller: c.titleCtrl,
                          decoration: InputDecoration(
                            labelText: 'Judul *',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Content field
                        TextField(
                          controller: c.contentCtrl,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: 'Ceritakan hari ini...',
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Photos section
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Foto (maks. 4)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            TextButton.icon(
                              onPressed: c.pickPhotos,
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                              label: const Text('Tambah'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Existing photos
                        Obx(() {
                          final existing = c.existingPhotoUrls;
                          final newPics = c.newPhotos;
                          if (existing.isEmpty && newPics.isEmpty) {
                            return Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.grey[300]!,
                                    style: BorderStyle.solid),
                              ),
                              child: const Center(
                                child: Text(
                                  'Ketuk "Tambah" untuk memilih foto',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            );
                          }
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Existing network photos
                              ...existing.map((url) =>
                                  _photoTile(
                                    child: Image.network(
                                      url,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                    onRemove: () =>
                                        c.removeExistingPhoto(url),
                                  )),
                              // New local photos
                              ...newPics.asMap().entries.map((e) =>
                                  _photoTile(
                                    child: Image.file(
                                      File(e.value.path),
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                    onRemove: () =>
                                        c.removeNewPhoto(e.key),
                                  )),
                            ],
                          );
                        }),
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

  Widget _photoTile(
      {required Widget child, required VoidCallback onRemove}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(width: 90, height: 90, child: child),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
