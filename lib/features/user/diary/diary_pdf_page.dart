import 'dart:io';
import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/helper/file_helper.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:douce/shared/util/service/ad_service.dart';
import 'package:douce/shared/util/service/subscription_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DiaryPdfPage extends StatefulWidget {
  const DiaryPdfPage({super.key});

  @override
  State<DiaryPdfPage> createState() => _DiaryPdfPageState();
}

class _DiaryPdfPageState extends State<DiaryPdfPage> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final DiaryController c = Get.find<DiaryController>();

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // AppBar Header
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
                              'Album Diary PDF',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Ekspor semua diary menjadi album kenangan indah',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Preview Info Card
                Obx(() {
                  final count = c.entries.length;
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorDouce.douceBase,
                          ColorDouce.lightPink,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColorDouce.douceBase.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$count Entri Diary',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Desain Album Vektor Elegan & Eksklusif',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Diary Preview List
                Expanded(
                  child: Obx(() {
                    if (c.entries.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada diary untuk diekspor.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: c.entries.length,
                      itemBuilder: (_, i) {
                        final e = c.entries[i];
                        final dateStr =
                            '${e.createdAt.day.toString().padLeft(2, '0')}/'
                            '${e.createdAt.month.toString().padLeft(2, '0')}/'
                            '${e.createdAt.year}';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(e.moodEmoji, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${e.ageLabel} · $dateStr',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (e.photoUrls.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.photo_outlined, size: 14, color: Colors.grey[400]),
                                    Text(
                                      ' ${e.photoUrls.length}',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),

                // Export Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : () => _generatePdf(c),
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf_rounded),
                      label: Text(_isGenerating ? 'Membuat Album...' : 'Ekspor Album PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
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

  /// Builds adaptive & dynamic photo layouts depending on photo count (1, 2, 3, or 4)
  pw.Widget _buildDynamicPhotoLayout(List<pw.ImageProvider> images) {
    if (images.isEmpty) return pw.SizedBox();

    // ── 1 PHOTO: Full-width Hero Featured Picture ──
    if (images.length == 1) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 12),
        height: 250,
        decoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(14)),
          border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
          image: pw.DecorationImage(
            image: images[0],
            fit: pw.BoxFit.cover,
          ),
        ),
      );
    }

    // ── 2 PHOTOS: Side-by-Side Dual Columns ──
    if (images.length == 2) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 12),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                height: 180,
                decoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                  border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                  image: pw.DecorationImage(
                    image: images[0],
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Container(
                height: 180,
                decoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                  border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                  image: pw.DecorationImage(
                    image: images[1],
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── 3 PHOTOS: 1 Hero Top + 2 Side-by-Side Bottom ──
    if (images.length == 3) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 12),
        child: pw.Column(
          children: [
            pw.Container(
              height: 170,
              decoration: pw.BoxDecoration(
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                image: pw.DecorationImage(
                  image: images[0],
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    height: 120,
                    decoration: pw.BoxDecoration(
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                      border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                      image: pw.DecorationImage(
                        image: images[1],
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    height: 120,
                    decoration: pw.BoxDecoration(
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                      border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                      image: pw.DecorationImage(
                        image: images[2],
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // ── 4 PHOTOS: 2x2 Balanced Grid ──
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 12),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  height: 130,
                  decoration: pw.BoxDecoration(
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                    image: pw.DecorationImage(
                      image: images[0],
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Container(
                  height: 130,
                  decoration: pw.BoxDecoration(
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                    image: pw.DecorationImage(
                      image: images[1],
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  height: 130,
                  decoration: pw.BoxDecoration(
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                    image: pw.DecorationImage(
                      image: images[2],
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Container(
                  height: 130,
                  decoration: pw.BoxDecoration(
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                    image: pw.DecorationImage(
                      image: images[3],
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdf(DiaryController c) async {
    if (c.entries.isEmpty) return;

    if (!SubscriptionService.to.isPremium.value) {
      SubscriptionService.to.showPaywall(
        context: context,
        featureName: 'Eksport Diary ke PDF',
        canDismissToAccess: true,
        onUnlocked: () => _generatePdf(c),
      );
      return;
    }

    final watchedAd = await AdService.showRewardedAdDialog(
      context,
      title: 'Ekspor Album Diary PDF',
      description:
          'Saksikan iklan sponsor (5 detik) untuk membuka dan mengunduh Album PDF Diary Kehamilan Anda secara gratis.',
    );
    if (!watchedAd) return;

    setState(() => _isGenerating = true);
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      // ── COVER PAGE (High-End Pure Vector Layout with Frames & Ornaments) ──
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: const pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [
                  PdfColor.fromInt(0xFFFFF0F5),
                  PdfColor.fromInt(0xFFFFE4E8),
                  PdfColor.fromInt(0xFFFFF8FA),
                ],
                begin: pw.Alignment.topCenter,
                end: pw.Alignment.bottomCenter,
              ),
            ),
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(24)),
                border: pw.Border.all(color: PdfColor.fromHex('#FF6972'), width: 2),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Top Ornamental Badge & Lines
                  pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(width: 40, height: 1.5, color: PdfColor.fromHex('#FF6972')),
                          pw.SizedBox(width: 10),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#900C3F'),
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                            ),
                            child: pw.Text(
                              'ALBUM KENANGAN EKSKLUSIF',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Container(width: 40, height: 1.5, color: PdfColor.fromHex('#FF6972')),
                        ],
                      ),
                    ],
                  ),

                  // Center Main Title Block
                  pw.Column(
                    children: [
                      pw.Text(
                        'DIARY KEHAMILAN & BAYI',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#800A34'),
                          letterSpacing: 1.2,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(width: 30, height: 1, color: PdfColor.fromHex('#FF9EAA')),
                          pw.SizedBox(width: 8),
                          pw.Text('❖', style: pw.TextStyle(fontSize: 12, color: PdfColor.fromHex('#FF6972'))),
                          pw.SizedBox(width: 8),
                          pw.Container(width: 30, height: 1, color: PdfColor.fromHex('#FF9EAA')),
                        ],
                      ),
                      pw.SizedBox(height: 14),
                      pw.Text(
                        'Abadikan Setiap Momen Indah, Perasaan, & Tumbuh Tumbuh Buah Hati',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),

                  // Pure Vector Stats Box Card
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FFF5F7'),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
                      border: pw.Border.all(color: PdfColor.fromHex('#FFD0DB'), width: 1.5),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text(
                              '${c.entries.length}',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#FF6972'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Total Catatan',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                        pw.Container(width: 1, height: 30, color: PdfColor.fromHex('#FFD0DB')),
                        pw.Column(
                          children: [
                            pw.Text(
                              '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#0F172A'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Tanggal Cetak',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bottom Watermark Footer Banner
                  pw.Column(
                    children: [
                      pw.Container(
                        width: double.infinity,
                        height: 1,
                        color: PdfColor.fromHex('#FFD0DB'),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'MOMSIE APP · PENDAMPING SETIA BUNDA & BUAH HATI',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColor.fromHex('#900C3F'),
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // ── DIARY ENTRY PAGES (Clean Pure Vector Header & Dynamic Layout) ──
      for (int idx = 0; idx < c.entries.length; idx++) {
        final entry = c.entries[idx];
        final dateStr =
            '${entry.createdAt.day.toString().padLeft(2, '0')}/'
            '${entry.createdAt.month.toString().padLeft(2, '0')}/'
            '${entry.createdAt.year}';

        // Load entry photo bytes
        final photoImages = <pw.ImageProvider>[];
        for (final url in entry.photoUrls.take(4)) {
          try {
            if (url.startsWith('http://') || url.startsWith('https://')) {
              final response = await http.get(Uri.parse(url));
              if (response.statusCode == 200) {
                photoImages.add(pw.MemoryImage(response.bodyBytes));
              }
            } else {
              final file = File(url);
              if (await file.exists()) {
                final bytes = await file.readAsBytes();
                photoImages.add(pw.MemoryImage(bytes));
              }
            }
          } catch (e) {
            debugPrint('Error loading photo bytes for PDF: $e');
          }
        }

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(36),
            build: (_) => [
              // Vector Styled Entry Header Box
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FFF5F7'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(14)),
                  border: pw.Border.all(color: PdfColor.fromHex('#FFE2E8'), width: 1.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        // Mood Badge Pill
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#FF6972'),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                          ),
                          child: pw.Text(
                            entry.moodLabel.toUpperCase(),
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        // Age & Date Pill
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                            border: pw.Border.all(color: PdfColor.fromHex('#FFD6E0')),
                          ),
                          child: pw.Text(
                            '${entry.ageLabel}  ·  $dateStr',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#900C3F'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      entry.title,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#0F172A'),
                      ),
                    ),
                  ],
                ),
              ),

              // Dynamic Adaptive Photo Grid
              _buildDynamicPhotoLayout(photoImages),

              // Content Body Text inside Quote-style Box
              if (entry.content.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#FAFAFA'),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    border: pw.Border(
                      left: pw.BorderSide(color: PdfColor.fromHex('#FF6972'), width: 3),
                    ),
                  ),
                  child: pw.Text(
                    entry.content,
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColor.fromHex('#334155'),
                      lineSpacing: 4,
                    ),
                  ),
                ),
              ],

              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),

              // Page Footer Watermark
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Momsie App · Catatan Momen Kehamilan & Bayi',
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    dateStr,
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey400),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      final bytes = await pdf.save();
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename: 'DiaryAlbum_Momsie_${now.millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
      );
      if (mounted) {
        Get.snackbar(
          'Berhasil',
          'Album PDF berhasil diunduh dan dibuka!',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Error: $e', snackPosition: SnackPosition.TOP);
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
