import 'package:douce/features/user/birthplan/birth_plan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:douce/shared/util/service/ad_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:douce/shared/util/helper/file_helper.dart';

import 'package:douce/shared/util/service/subscription_service.dart';

class BirthPlanPage extends StatefulWidget {
  const BirthPlanPage({super.key});

  @override
  State<BirthPlanPage> createState() => _BirthPlanPageState();
}

class _BirthPlanPageState extends State<BirthPlanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SubscriptionService.to.showPaywall(
          context: context,
          featureName: 'Birth Plan Persalinan',
          canDismissToAccess: true,
        );
      }
    });
  }

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
                // ══════════ AppBar ══════════
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
                              'Birth Plan Persalinan',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rencana & Harapan Persalinan Bunda',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Export PDF button
                      ElevatedButton.icon(
                        onPressed: () => _exportPDF(c),
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                        label: const Text('PDF', style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorDouce.douceBase,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),

                // ══════════ Header Banner Statement ══════════
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF43F5E), Color(0xFFFB7185)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "\"Selama persalinan, saya berencana dan meminta dukungan Anda untuk:\"",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ══════════ Counter & Reset Banner ══════════
                Obx(() {
                  final sel = c.totalSelected;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$sel dari ${c.items.length} poin preferensi dipilih',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                        if (sel > 0)
                          InkWell(
                            onTap: c.resetAll,
                            child: const Text(
                              'Reset Pilihan',
                              style: TextStyle(
                                color: Color(0xFFF43F5E),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 4),

                // ══════════ Accordion List ══════════
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: BirthPlanController.categories.length,
                      itemBuilder: (context, idx) {
                        final cat = BirthPlanController.categories[idx];
                        
                        return Obx(() {
                          final catItems = c.itemsFor(cat);
                          final isExpanded = c.expandedCategory.value == cat;
                          final selectedCount = catItems.where((i) => i.isSelected).length;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Category header
                                InkWell(
                                  onTap: () => c.toggleCategory(cat),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            cat,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        if (selectedCount > 0)
                                          Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: ColorDouce.douceBase,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '$selectedCount terpilih',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons.keyboard_arrow_down_rounded,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Expanded Checklist Items
                                if (isExpanded)
                                  Column(
                                    children: [
                                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                      ...catItems.map((item) {
                                        return InkWell(
                                          onTap: () => c.toggleItem(item),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(milliseconds: 150),
                                                  width: 22,
                                                  height: 22,
                                                  margin: const EdgeInsets.only(top: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: item.isSelected
                                                        ? ColorDouce.douceBase
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: item.isSelected
                                                          ? ColorDouce.douceBase
                                                          : Colors.grey.shade400,
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
                                                      fontSize: 13.5,
                                                      color: item.isSelected
                                                          ? const Color(0xFF0F172A)
                                                          : const Color(0xFF64748B),
                                                      fontWeight: item.isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                      height: 1.35,
                                                    ),
                                                  ),
                                                ),
                                                if (item.isCustom)
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_outline_rounded,
                                                      color: Colors.redAccent,
                                                      size: 18,
                                                    ),
                                                    onPressed: () => c.deleteCustomItem(item),
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),

                                      // Button: + Tambah Keinginan Khusus User
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showAddCustomDialog(context, c, cat),
                                          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                                          label: Text("Tambah Poin Khusus $cat"),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: ColorDouce.douceBase,
                                            side: BorderSide(color: ColorDouce.douceBase),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        });
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

  /// Dialog untuk Tambah Keinginan Khusus / Custom Items
  void _showAddCustomDialog(BuildContext context, BirthPlanController c, String category) {
    final TextEditingController textCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Tambah Catatan Khusus\n($category)",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Tuliskan harapan atau permintaan khusus Bunda pada tahap ini:",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textCtrl,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Contoh: Menginginkan terapi aromaterapi lavender...",
                hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorDouce.douceBase, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                c.addCustomItem(category, textCtrl.text.trim());
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  /// Ekspor Dokumen Birth Plan ke PDF
  Future<void> _exportPDF(BirthPlanController c) async {
    final selected = c.items.where((i) => i.isSelected).toList();
    if (selected.isEmpty) {
      Get.snackbar(
        'Belum Ada Pilihan',
        'Silakan pilih atau tambah poin harapan persalinan Bunda terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final watchedAd = await AdService.showRewardedAdDialog(
      Get.context!,
      title: 'Unduh Birth Plan PDF',
      description:
          'Saksikan iklan sponsor (5 detik) untuk mengunduh dokumen Birth Plan dan Rencana Persalinan secara gratis.',
    );
    if (!watchedAd) return;

    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Group selected by category
      final Map<String, List<String>> grouped = {};
      for (var item in selected) {
        grouped.putIfAbsent(item.category, () => []).add(item.detail);
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
          build: (pw.Context context) {
            return [
              // Header Title
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FFF1F2'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                  border: pw.Border.all(color: PdfColor.fromHex('#F43F5E'), width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BIRTH PLAN PERSALINAN',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#F43F5E'),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '"Selama persalinan, saya berencana dan meminta dukungan Anda untuk:"',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColor.fromHex('#0F172A'),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Tanggal Dibuat: $dateStr  •  Aplikasi Momsie Health Care',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // Grouped Category Sections
              ...grouped.entries.map((entry) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#F43F5E'),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
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
                    pw.SizedBox(height: 8),
                    ...entry.value.map(
                      (detail) => pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, bottom: 5),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('✓ ',
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex('#F43F5E'),
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
                      ),
                    ),
                    pw.SizedBox(height: 12),
                  ],
                );
              }),

              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 6),
              pw.Text(
                'Dokumen ini merupakan acuan preferensi persalinan mandiri Bunda. Situasi medis darurat dapat memerlukan penyesuaian tim kesehatan.',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                textAlign: pw.TextAlign.center,
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename: 'BirthPlan_Momsie_${now.millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
      );
      Get.snackbar(
        'Berhasil Ekspor PDF',
        'Dokumen Birth Plan berhasil disimpan!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Ekspor PDF gagal: $e', snackPosition: SnackPosition.TOP);
    }
  }
}
