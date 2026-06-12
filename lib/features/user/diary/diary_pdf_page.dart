import 'package:douce/features/user/diary/diary_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/helper/file_helper.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
                              'Album Diary PDF',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              'Ekspor semua diary menjadi album kenangan',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Preview info card
                Obx(() {
                  final count = c.entries.length;
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorDouce.douceBase,
                          ColorDouce.lightPink
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('📖', style: TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$count entri diary',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Akan dimasukkan dalam album PDF',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Diary preview list
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(e.moodEmoji,
                                  style:
                                      const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Minggu ${e.pregnancyWeek} · $dateStr',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (e.photoUrls.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.photo_outlined,
                                        size: 14,
                                        color: Colors.grey[400]),
                                    Text(
                                      ' ${e.photoUrls.length}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey),
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

                // Export button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating
                          ? null
                          : () => _generatePdf(c),
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          : const Icon(Icons.picture_as_pdf_rounded),
                      label: Text(_isGenerating
                          ? 'Membuat Album...'
                          : 'Ekspor Album PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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

  Future<void> _generatePdf(DiaryController c) async {
    if (c.entries.isEmpty) return;
    setState(() => _isGenerating = true);
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      // ── Cover page ──────────────────────────────────────────────
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Container(
            decoration: pw.BoxDecoration(
              gradient: const pw.LinearGradient(
                colors: [PdfColors.pink100, PdfColors.purple100],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
            ),
            child: pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '📖',
                    style: const pw.TextStyle(fontSize: 60),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Diary Kehamilan',
                    style: pw.TextStyle(
                      fontSize: 36,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#FF6972'),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Album Kenangan Berharga',
                    style: const pw.TextStyle(
                        fontSize: 16, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    '${c.entries.length} Entri Diary',
                    style: const pw.TextStyle(
                        fontSize: 14, color: PdfColors.grey500),
                  ),
                  pw.Text(
                    'Dibuat: ${now.day.toString().padLeft(2, '0')}-'
                    '${now.month.toString().padLeft(2, '0')}-${now.year}',
                    style: const pw.TextStyle(
                        fontSize: 12, color: PdfColors.grey400),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'Momsie App',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColor.fromHex('#FF6972'),
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // ── Diary entry pages ────────────────────────────────────────
      for (final entry in c.entries) {
        final dateStr =
            '${entry.createdAt.day.toString().padLeft(2, '0')}/'
            '${entry.createdAt.month.toString().padLeft(2, '0')}/'
            '${entry.createdAt.year}';

        // Download photos
        final photoImages = <pw.ImageProvider>[];
        for (final url in entry.photoUrls.take(4)) {
          try {
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              photoImages
                  .add(pw.MemoryImage(response.bodyBytes));
            }
          } catch (_) {}
        }

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(36),
            build: (_) => [
              // Entry header
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FFF0F3'),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment:
                          pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${entry.moodEmoji} ${entry.moodLabel}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text(
                          'Minggu ${entry.pregnancyWeek}  ·  $dateStr',
                          style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey600),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      entry.title,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#FF6972'),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // Photos grid
              if (photoImages.isNotEmpty)
                pw.Column(
                  children: [
                    pw.Row(
                      children: photoImages
                          .take(2)
                          .map(
                            (img) => pw.Expanded(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(3),
                                child: pw.Image(img,
                                    height: 160,
                                    fit: pw.BoxFit.cover),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (photoImages.length > 2)
                      pw.Row(
                        children: photoImages
                            .skip(2)
                            .take(2)
                            .map(
                              (img) => pw.Expanded(
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(3),
                                  child: pw.Image(img,
                                      height: 120,
                                      fit: pw.BoxFit.cover),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    pw.SizedBox(height: 14),
                  ],
                ),

              // Content
              if (entry.content.isNotEmpty)
                pw.Text(
                  entry.content,
                  style: const pw.TextStyle(
                      fontSize: 11, lineSpacing: 4),
                ),

              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Text(
                'Momsie App  ·  $dateStr',
                style: const pw.TextStyle(
                    fontSize: 8, color: PdfColors.grey400),
                textAlign: pw.TextAlign.right,
              ),
            ],
          ),
        );
      }

      final bytes = await pdf.save();
      await FileHelper.saveAndOpenFile(
        bytes: bytes,
        filename:
            'DiaryAlbum_Momsie_${now.millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
      );
      if (mounted) {
        Get.snackbar('Berhasil', 'Album PDF berhasil diunduh!',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Error: $e',
          snackPosition: SnackPosition.TOP);
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
