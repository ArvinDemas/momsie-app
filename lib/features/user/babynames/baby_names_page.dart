import 'package:douce/features/user/babynames/baby_names_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BabyNamesPage extends StatelessWidget {
  const BabyNamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BabyNamesController c = Get.put(BabyNamesController());

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
                        child: Text(
                          'Pencari Nama Bayi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ColorDouce.douceBase.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${c.filtered.length} nama',
                              style: TextStyle(
                                color: ColorDouce.douceBase,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: c.onSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari nama bayi...',
                      prefixIcon: Icon(Icons.search_rounded, color: ColorDouce.douceBase),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter row: Gender chips + Language dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Gender filter chips
                      Expanded(
                        child: Obx(() => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: ['Semua', 'Laki-laki', 'Perempuan'].map((g) {
                                  final sel = c.selectedGender.value == g;
                                  IconData iconData;
                                  if (g == 'Laki-laki') {
                                    iconData = Icons.face_5_rounded;
                                  } else if (g == 'Perempuan') {
                                    iconData = Icons.face_3_rounded;
                                  } else {
                                    iconData = Icons.grid_view_rounded;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: ChoiceChip(
                                      avatar: Icon(
                                        iconData,
                                        size: 14,
                                        color: sel ? Colors.white : Colors.grey.shade600,
                                      ),
                                      label: Text(
                                        g,
                                        style: TextStyle(
                                          color: sel ? Colors.white : Colors.black87,
                                          fontSize: 12,
                                          fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      selected: sel,
                                      selectedColor: ColorDouce.douceBase,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      visualDensity: VisualDensity.compact,
                                      onSelected: (_) => c.onGenderChanged(g),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )),
                      ),
                      const SizedBox(width: 8),
                      // Language dropdown
                      Obx(() => Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: c.selectedLang.value,
                                icon: const Icon(Icons.expand_more_rounded, size: 18),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                ),
                                items: c.languages.map((lang) {
                                  return DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  );
                                }).toList(),
                                onChanged: (v) => v != null ? c.onLangChanged(v) : null,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Column headers
                Obx(() {
                  final gender = c.selectedGender.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (gender == 'Semua' || gender == 'Laki-laki')
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C9EFF).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.face_5_rounded, size: 18, color: Color(0xFF3B5FDB)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Laki-laki',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3B5FDB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (gender == 'Semua') const SizedBox(width: 8),
                        if (gender == 'Semua' || gender == 'Perempuan')
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: ColorDouce.lightPink.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.face_3_rounded, size: 18, color: ColorDouce.douceBase),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Perempuan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorDouce.douceBase,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),

                // Names list
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (c.filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada nama yang ditemukan.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: c.filtered.length,
                      itemBuilder: (context, i) {
                        final n = c.filtered[i];
                        final gender = c.selectedGender.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Boy name
                              if (gender == 'Semua' || gender == 'Laki-laki')
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Text(
                                      n.boy.isEmpty ? '—' : n.boy,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: n.boy.isEmpty
                                            ? Colors.grey.shade300
                                            : const Color(0xFF3B5FDB),
                                      ),
                                    ),
                                  ),
                                ),
                              if (gender == 'Semua')
                                Container(
                                  width: 1,
                                  height: 36,
                                  color: Colors.grey.shade200,
                                ),
                              // Girl name
                              if (gender == 'Semua' || gender == 'Perempuan')
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Text(
                                      n.girl.isEmpty ? '—' : n.girl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: n.girl.isEmpty
                                            ? Colors.grey.shade300
                                            : ColorDouce.douceBase,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
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
}
