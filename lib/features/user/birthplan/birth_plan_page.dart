import 'package:douce/features/user/birthplan/birth_plan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:douce/shared/util/helper/file_helper.dart';

class BirthPlanPage extends StatelessWidget {
  const BirthPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BirthPlanController c = Get.put(BirthPlanController());

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
                              'Birth Plan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              'Rencana persalinan personalmu',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Export PDF button
                      ElevatedButton.icon(
                        onPressed: () => _exportPDF(c),
                        icon: const Icon(Icons.picture_as_pdf_outlined,
                            size: 16),
                        label: const Text('PDF',
                            style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorDouce.douceBase,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Summary banner
                Obx(() {
                  final sel = c.totalSelected;
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorDouce.douceBase,
                          ColorDouce.lightPink
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Text('📋',
                            style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$sel dari ${c.items.length} preferensi dipilih',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'Pilih preferensi, lalu ekspor ke PDF',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        if (sel > 0)
                          TextButton(
                            onPressed: c.resetAll,
                            child: const Text('Reset',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ),
                      ],
                    ),
                  );
                }),

                // Accordion list
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: c.categories.length,
                      itemBuilder: (context, idx) {
                        final cat = c.categories[idx];
                        final label = BirthPlanController
                                .categoryLabels[cat] ??
                            cat;
                        final catItems = c.itemsFor(cat);
                        final isExpanded =
                            c.expandedCategory.value == cat;
                        final selectedCount =
                            catItems.where((i) => i.isSelected).length;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Category header (tappable)
                              InkWell(
                                onTap: () => c.toggleCategory(cat),
                                borderRadius: BorderRadius.circular(14),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                      if (selectedCount > 0)
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2),
                                          decoration: BoxDecoration(
                                            color: ColorDouce.douceBase,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '$selectedCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        isExpanded
                                            ? Icons.expand_less_rounded
                                            : Icons.expand_more_rounded,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Expanded items
                              if (isExpanded)
                                Column(
                                  children: catItems.map((item) {
                                    return Obx(() {
                                      c.items.length;
                                      return InkWell(
                                        onTap: () => c.toggleItem(item),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 8, 16, 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6),
                                                  color: item.isSelected
                                                      ? ColorDouce
                                                          .douceBase
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    color: item.isSelected
                                                        ? ColorDouce
                                                            .douceBase
                                                        : Colors
                                                            .grey[400]!,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: item.isSelected
                                                    ? const Icon(
                                                        Icons.check_rounded,
                                                        color: Colors.white,
                                                        size: 16,
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  item.detail,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: item.isSelected
                                                        ? Colors.black87
                                                        : Colors.grey[600],
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  }).toList(),
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

  Future<void> _exportPDF(BirthPlanController c) async {
    final selected = c.items.where((i) => i.isSelected).toList();
    if (selected.isEmpty) {
      Get.snackbar(
        'Tidak ada pilihan',
        'Pilih setidaknya satu preferensi terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.year}';

      // Group selected by category
      final Map<String, List<String>> grouped = {};
      for (var item in selected) {
        final label = BirthPlanController.categoryLabels[item.category] ??
            item.category;
        grouped.putIfAbsent(label, () => []).add(item.detail);
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FFEFEF'),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BIRTH PLAN',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#FF6972'),
                      ),
                    ),
                    pw.Text(
                      'Rencana Persalinan Pribadi — $dateStr',
                      style: const pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Dokumen ini mencerminkan preferensi persalinan saya. '
                      'Saya memahami bahwa situasi medis dapat mengharuskan perubahan.',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Category sections
              ...grouped.entries.map((entry) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#FF6972'),
                        borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(6)),
                      ),
                      child: pw.Text(
                        entry.key,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    ...entry.value.map((detail) => pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              left: 12, bottom: 4),
                          child: pw.Row(
                            crossAxisAlignment:
                                pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('✓ ',
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#FF6972'),
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10,
                                  )),
                              pw.Expanded(
                                child: pw.Text(
                                  detail,
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        )),
                    pw.SizedBox(height: 12),
                  ],
                );
              }),

              // Footer
              pw.Divider(),
              pw.Text(
                'Dibuat dengan Momsie App  •  $dateStr',
                style: const pw.TextStyle(
                    fontSize: 8, color: PdfColors.grey600),
                textAlign: pw.TextAlign.center,
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename:
            'BirthPlan_Momsie_${now.millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
      );
      Get.snackbar(
        'Berhasil',
        'Birth Plan PDF berhasil diunduh!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Ekspor PDF gagal: $e',
          snackPosition: SnackPosition.TOP);
    }
  }
}
