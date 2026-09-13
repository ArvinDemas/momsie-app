import 'package:douce/features/user/ai_chat/ai_chat_controller.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiApiKeyPage extends StatelessWidget {
  const AiApiKeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AiChatController c = Get.find<AiChatController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppSemanticColors.textDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Status API Key',
          style: TextStyle(color: AppSemanticColors.textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.hasCustomApiKey.value
                    ? const Color(0xFF0284C7).withOpacity(0.08)
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: c.hasCustomApiKey.value
                      ? const Color(0xFF0284C7).withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    c.hasCustomApiKey.value ? Icons.check_circle : Icons.key_off,
                    color: c.hasCustomApiKey.value ? const Color(0xFF0284C7) : Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.hasCustomApiKey.value ? 'API Key Aktif' : 'API Key Belum Diatur',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: c.hasCustomApiKey.value ? const Color(0xFF0284C7) : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (c.hasCustomApiKey.value && c.apiKeyPreview.value.isNotEmpty)
                          Text(
                            c.apiKeyPreview.value,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        if (!c.hasCustomApiKey.value)
                          const Text(
                            'Chat AI akan menggunakan mode offline (fallback edukatif).',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info section
            const Text(
              'Cara Mengatur API Key',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppSemanticColors.textDark),
            ),
            const SizedBox(height: 12),
            _stepItem(context, '1', 'Buka Firebase Console → Firestore Database'),
            _stepItem(context, '2', 'Koleksi: `app`, Dokumen: `config/settings`'),
            _stepItem(context, '3', 'Tambah field: `apiKey` → isi value `sk-ac-xxxxx`'),
            _stepItem(context, '4', 'Simpan → chat AI akan otomatis aktif setelah refresh'),

            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 12),

            // Source link
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.link, size: 18, color: Color(0xFF0284C7)),
                      SizedBox(width: 8),
                      Text('Dapatkan API Key', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Get.snackbar(
                      'URL Disalin',
                      'Buka browser dan kunjungi URL ini.',
                      snackPosition: SnackPosition.TOP,
                    ),
                    child: const Text(
                      'https://adacode.ai/api-keys',
                      style: TextStyle(fontSize: 13, color: Color(0xFF0284C7), decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Daftar akun adaCODE untuk mendapatkan API key gratis.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Security note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Keamanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• API Key disimpan di Firestore (read-only untuk client)\n'
                    '• Tidak ada API key yang hardcoded di aplikasi\n'
                    '• Client hanya bisa membaca, tidak bisa menulis\n'
                    '• Chat log tetap disimpan aman di device masing-masing',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepItem(BuildContext context, String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ColorDouce.douceBase,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
