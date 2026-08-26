import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:douce/shared/util/service/subscription_service.dart';

class DiaryFormPage extends StatefulWidget {
  const DiaryFormPage({super.key});

  @override
  State<DiaryFormPage> createState() => _DiaryFormPageState();
}

class _DiaryFormPageState extends State<DiaryFormPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SubscriptionService.to.showPaywall(
          context: context,
          featureName: 'Input Diary Kehamilan',
          canDismissToAccess: true,
        );
      }
    });
  }

  Widget _buildPhoto(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: url,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _fallbackBox(),
      );
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackBox(),
      );
    }
    return _fallbackBox();
  }

  Widget _fallbackBox() {
    return Container(
      width: 90,
      height: 90,
      color: ColorDouce.veryLightPink,
      child: const Icon(Icons.photo_rounded, size: 24, color: Color(0xFFFF6972)),
    );
  }

  Widget _buildMoodCard(DiaryController c, String moodKey) {
    final isSelected = c.selectedMood.value == moodKey;
    final emoji = DiaryModel.moodEmojis[moodKey] ?? '😊';
    final label = DiaryModel.moodLabels[moodKey] ?? moodKey;

    return GestureDetector(
      onTap: () => c.selectedMood.value = moodKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? ColorDouce.douceBase : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ColorDouce.douceBase
                : Colors.grey.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? ColorDouce.douceBase.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DiaryController c = Get.isRegistered<DiaryController>()
        ? Get.find<DiaryController>()
        : Get.put(DiaryController());

    final DiaryModel? editEntry =
        Get.arguments is DiaryModel ? Get.arguments as DiaryModel : null;
    final isEdit = editEntry != null;

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top Custom App Bar Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF0F172A)),
                        onPressed: () {
                          c.clearForm();
                          Get.back();
                        },
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Catatan' : 'Tulis Momen',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Obx(() => ElevatedButton(
                            onPressed: c.isSaving.value
                                ? null
                                : () => c.saveEntry(editId: editEntry?.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorDouce.douceBase,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            child: c.isSaving.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Simpan'),
                          )),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Mood Selector Section (iOS Emoji 3x2 Grid)
                        const Text(
                          'Perasaan Bunda Hari Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Obx(() => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildMoodCard(c, 'happy')),
                                    const SizedBox(width: 10),
                                    Expanded(child: _buildMoodCard(c, 'love')),
                                    const SizedBox(width: 10),
                                    Expanded(child: _buildMoodCard(c, 'calm')),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: _buildMoodCard(c, 'tired')),
                                    const SizedBox(width: 10),
                                    Expanded(child: _buildMoodCard(c, 'anxious')),
                                    const SizedBox(width: 10),
                                    Expanded(child: _buildMoodCard(c, 'excited')),
                                  ],
                                ),
                              ],
                            )),

                        const SizedBox(height: 22),

                        // 2. Mode Toggle + Center-aligned Input Controls
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Kategori Periode',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Professional Segmented Switch (Masa Kehamilan vs Bayi Lahir)
                              Obx(() => Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => c.updateMode(false),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: !c.isBabyBorn.value
                                                    ? ColorDouce.douceBase
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: !c.isBabyBorn.value
                                                    ? [
                                                        BoxShadow(
                                                          color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.pregnant_woman_rounded,
                                                    size: 18,
                                                    color: !c.isBabyBorn.value
                                                        ? Colors.white
                                                        : const Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Masa Kehamilan',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: !c.isBabyBorn.value
                                                          ? Colors.white
                                                          : const Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => c.updateMode(true),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: c.isBabyBorn.value
                                                    ? ColorDouce.douceBase
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: c.isBabyBorn.value
                                                    ? [
                                                        BoxShadow(
                                                          color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.child_care_rounded,
                                                    size: 18,
                                                    color: c.isBabyBorn.value
                                                        ? Colors.white
                                                        : const Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Bayi Lahir',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: c.isBabyBorn.value
                                                          ? Colors.white
                                                          : const Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),

                              const SizedBox(height: 20),

                              // Centered Controls per Mode
                              Obx(() {
                                if (c.isBabyBorn.value) {
                                  // ── MODE BAYI LAHIR: Center-aligned Numeric Input + Sleek Dropdown ──
                                  return Column(
                                    children: [
                                      const Text(
                                        'Usia Bayi Saat Ini',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Center Numeric Input Box
                                          SizedBox(
                                            width: 70,
                                            height: 44,
                                            child: TextField(
                                              controller: c.weekTextCtrl,
                                              keyboardType: TextInputType.number,
                                              maxLength: 2,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              onChanged: c.onWeekTextChanged,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                              decoration: InputDecoration(
                                                counterText: '',
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                filled: true,
                                                fillColor: const Color(0xFFF8FAFC),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(color: ColorDouce.douceBase, width: 1.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Sleek Custom Dropdown for Month / Year Selection
                                          Container(
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(horizontal: 14),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFFE2E8F0)),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: c.babyAgeUnit.value,
                                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0F172A),
                                                ),
                                                onChanged: (String? val) {
                                                  if (val != null) c.updateUnit(val);
                                                },
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'bulan',
                                                    child: Text('Bulan'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'tahun',
                                                    child: Text('Tahun'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                // ── MODE MASA KEHAMILAN: Center-aligned Stepper (- / +) + Centered Text Box + Slider ──
                                return Column(
                                  children: [
                                    const Text(
                                      'Usia Kehamilan Saat Ini',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Decrement Button (-)
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: c.safeEditingWeek > c.minAge ? c.decrementAge : null,
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: Icon(
                                                Icons.remove_rounded,
                                                size: 20,
                                                color: c.safeEditingWeek > c.minAge
                                                    ? ColorDouce.douceBase
                                                    : Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Centered Numeric Input Box
                                        SizedBox(
                                          width: 64,
                                          height: 42,
                                          child: TextField(
                                            controller: c.weekTextCtrl,
                                            keyboardType: TextInputType.number,
                                            maxLength: 2,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            onChanged: c.onWeekTextChanged,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                              filled: true,
                                              fillColor: const Color(0xFFF8FAFC),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: ColorDouce.douceBase, width: 1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        const Text(
                                          'Minggu',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Increment Button (+)
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: c.safeEditingWeek < c.maxAge ? c.incrementAge : null,
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: Icon(
                                                Icons.add_rounded,
                                                size: 20,
                                                color: c.safeEditingWeek < c.maxAge
                                                    ? ColorDouce.douceBase
                                                    : Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // Visual Slider Indicator
                                    Slider(
                                      value: c.safeEditingWeek.toDouble(),
                                      min: c.minAge.toDouble(),
                                      max: c.maxAge.toDouble(),
                                      divisions: (c.maxAge - c.minAge) > 0 ? (c.maxAge - c.minAge) : 1,
                                      activeColor: ColorDouce.douceBase,
                                      inactiveColor: const Color(0xFFE2E8F0),
                                      label: '${c.safeEditingWeek} Minggu',
                                      onChanged: (v) => c.setWeekValue(v.round()),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 3. Clean Text Box Inputs (Judul Catatan & Cerita Momen)
                        const Row(
                          children: [
                            Text(
                              'Judul Catatan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: c.titleCtrl,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Contoh: USG Pertama Adik Bayi / Pertama Kali Senyum',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.normal,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: ColorDouce.douceBase),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Cerita Momen Section Label
                        const Text(
                          'Ceritakan Momen Hari Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: c.contentCtrl,
                            maxLines: 5,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tuliskan perasaan, perkembangan fisik, atau pesan hangat untuk buah hati...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: ColorDouce.douceBase),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 4. Photos Section Header & Upload Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Foto Kenangan (Maksimal 4)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: c.pickPhotos,
                              icon: const Icon(Icons.add_a_photo_rounded, size: 16),
                              label: const Text('Pilih Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: ColorDouce.douceBase,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Photos Display Area
                        Obx(() {
                          final existing = c.existingPhotoUrls;
                          final newPics = c.newPhotos;
                          if (existing.isEmpty && newPics.isEmpty) {
                            return GestureDetector(
                              onTap: c.pickPhotos,
                              child: Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, size: 36, color: ColorDouce.douceBase),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Ketuk di sini untuk menambahkan foto kenangan',
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              // Existing photos (cloud URL or local file)
                              ...existing.map(
                                (url) => _photoTile(
                                  child: _buildPhoto(url),
                                  onRemove: () => c.removeExistingPhoto(url),
                                ),
                              ),
                              // New picked photos
                              ...newPics.asMap().entries.map(
                                (e) => _photoTile(
                                  child: _buildPhoto(e.value.path),
                                  onRemove: () => c.removeNewPhoto(e.key),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 30),
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

  Widget _photoTile({required Widget child, required VoidCallback onRemove}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(width: 90, height: 90, child: child),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
