import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String role; // 'user' | 'model'
  final String text;
  final DateTime time;

  ChatMessage({required this.role, required this.text, required this.time});
}

class AiChatController extends GetxController {
  static const _apiKeyPref = 'gemini_api_key';
  static const _systemPrompt =
      'Kamu adalah Momsie AI, asisten kesehatan kehamilan yang ramah, '
      'empatik, dan informatif. Jawab dalam Bahasa Indonesia. '
      'Berikan informasi kesehatan ibu hamil yang akurat, tetapi selalu '
      'sarankan konsultasi dokter untuk kondisi medis serius. '
      'Gunakan emoji secara wajar agar terasa hangat dan ramah. '
      'Jangan pernah memberikan diagnosis medis.';

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasApiKey = false.obs;
  final RxString apiKeyPreview = ''.obs;

  final messageCtrl = TextEditingController();
  String _apiKey = '';

  @override
  void onInit() {
    super.onInit();
    _loadApiKey();
    // Welcome message
    messages.add(ChatMessage(
      role: 'model',
      text: 'Halo! Saya Momsie AI 🌸\n\n'
          'Saya siap menjawab pertanyaan seputar kehamilan, '
          'nutrisi ibu hamil, perkembangan janin, dan tips perawatan. '
          'Apa yang ingin kamu tanyakan?',
      time: DateTime.now(),
    ));
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_apiKeyPref) ?? '';
    _apiKey = saved;
    hasApiKey.value = saved.isNotEmpty;
    if (saved.isNotEmpty && saved.length > 8) {
      apiKeyPreview.value =
          '${saved.substring(0, 4)}...${saved.substring(saved.length - 4)}';
    }
  }

  Future<void> saveApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, trimmed);
    _apiKey = trimmed;
    hasApiKey.value = true;
    if (trimmed.length > 8) {
      apiKeyPreview.value =
          '${trimmed.substring(0, 4)}...${trimmed.substring(trimmed.length - 4)}';
    }
    Get.back();
    Get.snackbar('API Key Tersimpan', 'Gemini API key berhasil disimpan.',
        snackPosition: SnackPosition.TOP);
  }

  Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPref);
    _apiKey = '';
    hasApiKey.value = false;
    apiKeyPreview.value = '';
  }

  Future<void> sendMessage() async {
    final text = messageCtrl.text.trim();
    if (text.isEmpty || isLoading.value) return;
    if (_apiKey.isEmpty) {
      Get.snackbar('API Key belum diatur',
          'Masukkan Gemini API key terlebih dahulu.',
          snackPosition: SnackPosition.TOP);
      return;
    }

    messages.add(ChatMessage(
      role: 'user',
      text: text,
      time: DateTime.now(),
    ));
    messageCtrl.clear();
    isLoading.value = true;

    try {
      // Build conversation history for context
      final history = messages
          .where((m) => m.role != 'model' || messages.indexOf(m) > 0)
          .take(20) // last 20 messages for context window
          .map((m) => {
                'role': m.role,
                'parts': [
                  {'text': m.text}
                ],
              })
          .toList();

      final body = jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': _systemPrompt}
          ]
        },
        'contents': history,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        },
      });

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/'
        'gemini-2.0-flash:generateContent?key=$_apiKey',
      );

      final response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates']?[0]?['content']?['parts']?[0]
                ?['text'] as String? ??
            'Maaf, tidak ada respons.';
        messages.add(ChatMessage(
          role: 'model',
          text: reply,
          time: DateTime.now(),
        ));
      } else if (response.statusCode == 400) {
        messages.add(ChatMessage(
          role: 'model',
          text:
              '⚠️ API Key tidak valid atau permintaan tidak dapat diproses. '
              'Periksa kembali API key kamu.',
          time: DateTime.now(),
        ));
      } else if (response.statusCode == 429) {
        messages.add(ChatMessage(
          role: 'model',
          text: '⚠️ Batas kuota API tercapai. Coba beberapa saat lagi.',
          time: DateTime.now(),
        ));
      } else {
        messages.add(ChatMessage(
          role: 'model',
          text:
              '⚠️ Terjadi error (${response.statusCode}). Coba lagi nanti.',
          time: DateTime.now(),
        ));
      }
    } catch (e) {
      messages.add(ChatMessage(
        role: 'model',
        text:
            '⚠️ Koneksi gagal. Pastikan kamu terhubung ke internet: $e',
        time: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
    }
  }

  void clearHistory() {
    messages.clear();
    messages.add(ChatMessage(
      role: 'model',
      text: 'Riwayat chat dihapus. Ada yang bisa saya bantu? 🌸',
      time: DateTime.now(),
    ));
  }
}
