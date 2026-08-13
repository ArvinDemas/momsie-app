import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  
  // Endpoint Backend Proxy Server Aman (Zero Key di Flutter APK Client)
  static const _proxyEndpoint = 'https://momsie.id/api/chat';

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasCustomApiKey = false.obs;
  final RxString apiKeyPreview = ''.obs;

  final messageCtrl = TextEditingController();
  String _customApiKey = '';

  @override
  void onInit() {
    super.onInit();
    _loadCustomApiKey();
    // Welcome message
    messages.add(ChatMessage(
      role: 'model',
      text: 'Halo Bunda! Saya Momsie AI 🌸\n\n'
          'Saya siap mendampingi Bunda menjawab pertanyaan seputar perkembangan Si Kecil, '
          'nutrisi ibu hamil, persiapan bersalin, dan tips laktasi.\n\n'
          'Apa yang sedang Bunda rasakan atau ingin tanyakan hari ini?',
      time: DateTime.now(),
    ));
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadCustomApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_apiKeyPref) ?? '';
    _customApiKey = saved.trim();
    hasCustomApiKey.value = _customApiKey.isNotEmpty;
    if (_customApiKey.length > 8) {
      apiKeyPreview.value =
          '${_customApiKey.substring(0, 4)}...${_customApiKey.substring(_customApiKey.length - 4)}';
    }
  }

  Future<void> saveApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, trimmed);
    _customApiKey = trimmed;
    hasCustomApiKey.value = true;
    if (trimmed.length > 8) {
      apiKeyPreview.value =
          '${trimmed.substring(0, 4)}...${trimmed.substring(trimmed.length - 4)}';
    }
    Get.back();
    Get.snackbar(
      'API Key Tersimpan',
      'API key kustom berhasil disimpan.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPref);
    _customApiKey = '';
    hasCustomApiKey.value = false;
    apiKeyPreview.value = '';
  }

  Future<void> sendMessage() async {
    final text = messageCtrl.text.trim();
    if (text.isEmpty || isLoading.value) return;

    final userMsg = ChatMessage(
      role: 'user',
      text: text,
      time: DateTime.now(),
    );

    messages.add(userMsg);
    messageCtrl.clear();
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final historyPayload = messages
          .where((m) => m.role != 'model' || messages.indexOf(m) > 0)
          .take(20)
          .map((m) => {
                'role': m.role == 'user' ? 'user' : 'model',
                'text': m.text,
              })
          .toList();

      final body = jsonEncode({
        'prompt': text,
        'history': historyPayload,
        'apiKey': _customApiKey.isNotEmpty ? _customApiKey : null,
        'userId': user?.uid ?? 'anonymous',
        'userEmail': user?.email ?? 'anonymous',
      });

      final response = await http
          .post(
            Uri.parse(_proxyEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 25));

      String reply = '';
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        reply = data['reply'] as String? ??
            'Maaf Bunda, Momsie tidak dapat memproses jawaban saat ini. Coba tanyakan lagi ya.';
      } else if (response.statusCode == 429) {
        reply = '⚠️ Batas penggunaan AI tercapai sementara. Mohon tunggu beberapa saat ya Bunda.';
      } else if (response.statusCode == 503) {
        reply = '⚠️ Layanan AI sedang dalam pemeliharaan server. Bunda dapat mencoba beberapa saat lagi atau memasukkan Gemini API Key sendiri via menu di pojok atas.';
      } else {
        reply = '⚠️ Maaf Bunda, terjadi kendala teknis pada server proxy (${response.statusCode}). Silakan coba lagi.';
      }

      final aiMsg = ChatMessage(
        role: 'model',
        text: reply,
        time: DateTime.now(),
      );
      messages.add(aiMsg);

      // Async Backup Audit Log ke Firestore lokal jika diperlukan
      _logChatToFirestore(text, reply);

    } catch (e) {
      messages.add(ChatMessage(
        role: 'model',
        text: '⚠️ Koneksi terputus. Mohon periksa koneksi internet Bunda.',
        time: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _logChatToFirestore(String userPrompt, String aiResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('ai_chat_logs').add({
        'userId': user?.uid ?? 'anonymous',
        'userEmail': user?.email ?? 'anonymous',
        'prompt': userPrompt,
        'response': aiResponse,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Silent catch for log failures
    }
  }

  void clearHistory() {
    messages.clear();
    messages.add(ChatMessage(
      role: 'model',
      text: 'Riwayat percakapan telah dibersihkan. Ada yang ingin Bunda tanyakan lagi? 🌸',
      time: DateTime.now(),
    ));
  }
}
