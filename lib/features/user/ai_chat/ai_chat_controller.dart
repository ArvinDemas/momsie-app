import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String role; // 'user' | 'model'
  final String text;
  final DateTime time;

  ChatMessage({required this.role, required this.text, required this.time});

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'time': time.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'] as String? ?? 'model',
        text: json['text'] as String? ?? '',
        time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      );
}

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final list = (json['messages'] as List?)
            ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];
    return ChatSession(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Percakapan AI',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      messages: list,
    );
  }
}

class AiChatController extends GetxController {
  static const _sessionsPref = 'ai_chat_sessions_v2';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Built-in adaCODE API Key (default out-of-the-box fallback)
  static const String _defaultApiKey = 'sk-adacode-4835c3eafa2e810757c9ea0babd0422ab57611fe36ea0529';

  // Endpoint adaCODE (OpenAI-compatible)
  static const String _adacodeEndpoint = 'https://api.adacode.ai/v1/chat/completions';
  static const String _adacodeModel = 'claude-sonnet-4-6';

  // System Prompt Medis Kemenkes/WHO Khusus Spesialis Kehamilan & Laktasi
  static const String _systemPrompt = '''
Anda adalah Momsie AI, asisten virtual SPESIALIS KHUSUS KEHAMILAN, KESEHATAN IBU DAN JANIN, SERTA LAKTASI bersertifikasi edukasi Kemenkes RI & WHO.

BATASAN DOMAIN MUTLAK (STRICT GUARDRAILS):
1. Anda HANYA boleh menjawab pertanyaan seputar: kehamilan, nutrisi ibu hamil, perkembangan janin, gejala/keluhan saat hamil, persiapan persalinan, kebidanan, doula, dan perawatan bayi baru lahir/laktasi.
2. Jika pengguna menanyakan topik DI LUAR KEHAMILAN (misalnya: pemrograman/coding, politik, bisnis/saham, olahraga umum, teknologi, hiburan, dll.), Anda WAJIB MENOLAK DENGAN SOPAN:
   "Maaf ya Bunda 🌸 Momsie AI dirancang khusus untuk mendampingi kesehatan kehamilan, persalinan, dan tumbuh kembang Si Kecil. Ada yang ingin Bunda tanyakan seputar kehamilan Bunda hari ini?"
3. Jawablah dengan hangat, empatik, dan bahasa Indonesia yang santun.
4. Selalu sertakan medical disclaimer singkat di akhir jawaban medis: "Informasi ini bersifat edukatif dan bukan pengganti diagnosis dokter."
5. Jika ada tanda bahaya kehamilan (perdarahan, ketuban pecah dini, tidak ada gerakan janin, pusing hebat), berikan Peringatan Darurat Merah dan sarankan segera ke IGD RS terdekat.
6. Tulislah pesan secara rapi tanpa tanda bintang mentah (**), gunakan bullet point (•) atau penomoran biasa (1, 2, 3) agar nyaman dibaca.
''';

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatSession> sessions = <ChatSession>[].obs;
  final RxString currentSessionId = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool hasCustomApiKey = false.obs;
  final RxString apiKeyPreview = ''.obs;

  final messageCtrl = TextEditingController();
  final RxString _customApiKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCustomApiKey();
    _loadAllSessions();
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }

  bool get showWelcomingCanvas => messages.isEmpty;

  Future<void> _loadAllSessions() async {
    try {
      final raw = await _secureStorage.read(key: _sessionsPref);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw);
        final loaded = decoded.map((s) => ChatSession.fromJson(s as Map<String, dynamic>)).toList();
        if (loaded.isNotEmpty) {
          sessions.assignAll(loaded);
          final lastSession = sessions.first;
          currentSessionId.value = lastSession.id;
          messages.assignAll(lastSession.messages);
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }

    // Buat sesi baru jika masih kosong
    createNewChat();
  }

  Future<void> _saveAllSessions() async {
    try {
      // Update pesan di sesi aktif saat ini
      if (currentSessionId.value.isNotEmpty) {
        final idx = sessions.indexWhere((s) => s.id == currentSessionId.value);
        if (idx != -1) {
          String sessionTitle = sessions[idx].title;
          final firstUserMsg = messages.firstWhereOrNull((m) => m.role == 'user');
          if (firstUserMsg != null && sessionTitle.startsWith('Sesi')) {
            sessionTitle = firstUserMsg.text.length > 25
                ? '${firstUserMsg.text.substring(0, 25)}...'
                : firstUserMsg.text;
          }
          sessions[idx] = ChatSession(
            id: currentSessionId.value,
            title: sessionTitle,
            createdAt: sessions[idx].createdAt,
            messages: List.from(messages),
          );
        }
      }

      final listJson = sessions.map((s) => s.toJson()).toList();
      await _secureStorage.write(key: _sessionsPref, value: jsonEncode(listJson));
    } catch (e) {
      debugPrint('Error saving chat sessions: $e');
    }
  }

  void createNewChat() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    final newSession = ChatSession(
      id: newId,
      title: 'Sesi ${sessions.length + 1}',
      createdAt: DateTime.now(),
      messages: [],
    );

    sessions.insert(0, newSession);
    currentSessionId.value = newId;
    messages.clear();
    _saveAllSessions();
  }

  void switchSession(ChatSession session) {
    currentSessionId.value = session.id;
    messages.assignAll(session.messages);
  }

  Future<void> deleteSession(String sessionId) async {
    sessions.removeWhere((s) => s.id == sessionId);
    if (currentSessionId.value == sessionId) {
      if (sessions.isNotEmpty) {
        switchSession(sessions.first);
      } else {
        createNewChat();
      }
    }
    await _saveAllSessions();
  }

  Future<void> _loadCustomApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocal = prefs.getString('adacode_api_key') ?? '';
      if (savedLocal.trim().isNotEmpty) {
        _customApiKey.value = savedLocal.trim();
        hasCustomApiKey.value = true;
        if (_customApiKey.value.length > 8) {
          apiKeyPreview.value =
              '${_customApiKey.value.substring(0, 4)}...${_customApiKey.value.substring(_customApiKey.value.length - 4)}';
        }
        return;
      }

      final doc = await FirebaseFirestore.instance
          .doc('app/config/settings')
          .get();
      if (doc.exists) {
        final key = (doc.data()?['apiKey'] as String?)?.trim() ?? '';
        if (key.isNotEmpty) {
          _customApiKey.value = key;
          hasCustomApiKey.value = true;
          if (key.length > 8) {
            apiKeyPreview.value =
                '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading API key: $e');
    }
    hasCustomApiKey.value = true;
    apiKeyPreview.value = 'Momsie AI';
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
    await _saveAllSessions();

    try {
      String reply = '';
      final activeKey = _customApiKey.value.isNotEmpty ? _customApiKey.value : _defaultApiKey;

      // Format request OpenAI-compatible untuk adaCODE
      final messagesList = <Map<String, dynamic>>[];
      messagesList.add({'role': 'system', 'content': _systemPrompt});

      // Ambil riwayat percakapan pengguna
      for (var m in messages.take(12)) {
        messagesList.add({
          'role': m.role == 'user' ? 'user' : 'assistant',
          'content': m.text,
        });
      }

      final bodyPayload = jsonEncode({
        'model': _adacodeModel,
        'messages': messagesList,
        'temperature': 0.7,
      });

      http.Response? response;
      for (int attempt = 0; attempt < 3; attempt++) {
        if (attempt > 0) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
        try {
          response = await http
              .post(
                Uri.parse(_adacodeEndpoint),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $activeKey',
                },
                body: bodyPayload,
              )
              .timeout(const Duration(seconds: 25));
          if (response.statusCode != 429) break;
        } catch (e) {
          debugPrint('AI chat attempt $attempt error: $e');
          if (attempt == 2) rethrow;
        }
      }

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'] as Map?;
          reply = message?['content'] as String? ?? '';
        }
      } else if (response != null && response.statusCode != 200) {
        debugPrint('[MomsieAI] API Response ${response.statusCode}: ${response.body}');
      }

      // Jika balasan dari API kosong atau error network, berikan jawaban edukatif medis
      if (reply.trim().isEmpty) {
        reply = _getEducativeFallbackResponse(text);
      }

      final aiMsg = ChatMessage(
        role: 'model',
        text: reply,
        time: DateTime.now(),
      );
      messages.add(aiMsg);
      await _saveAllSessions();

      _logChatToFirestore(text, reply);

    } catch (e) {
      debugPrint('Error sending AI chat: $e');
      final fallbackReply = _getEducativeFallbackResponse(text);
      messages.add(ChatMessage(
        role: 'model',
        text: fallbackReply,
        time: DateTime.now(),
      ));
      await _saveAllSessions();
    } finally {
      isLoading.value = false;
    }
  }

  String _getEducativeFallbackResponse(String prompt) {
    final lower = prompt.toLowerCase();

    final safeContextPhrases = [
      'sel darah',
      'penambah darah',
      'tekanan darah',
      'golongan darah',
      'kekurangan darah',
      'anemia',
      'donor darah',
      'zat besi',
      'suplemen darah',
    ];
    final bool isSafeContext = safeContextPhrases.any((phrase) => lower.contains(phrase));

    final emergencyPhrases = [
      'perdarahan',
      'pendarahan',
      'keluar darah',
      'flek darah',
      'ketuban pecah',
      'cairan ketuban',
      'janin tidak bergerak',
      'gerakan janin berhenti',
      'kejang',
    ];
    final bool isEmergency = !isSafeContext && emergencyPhrases.any((phrase) => lower.contains(phrase));

    if (isEmergency) {
      return '🚨 **PERINGATAN DARURAT KESEHATAN:**\n'
          'Perdarahan aktif atau keluar cairan ketuban saat hamil merupakan tanda bahaya kehamilan.\n\n'
          'Mohon **SEGERA** menuju ke IGD RSIA Sadewa / RSUP Dr. Sardjito atau fasilitas kesehatan terdekat untuk pemeriksaan fisik langsung oleh dokter spesialis kandungan!\n\n'
          'Disclaimer: Informasi ini bersifat edukatif dan bukan pengganti diagnosis dokter.';
    } else if (lower.contains('mual') || lower.contains('muntah') || lower.contains('morning sickness')) {
      return 'Mual dan muntah (morning sickness) sangat umum terjadi di trimester pertama akibat peningkatan hormon hCG.\n\n'
          '💡 **Tips:**\n'
          '1. Makan dengan porsi kecil tapi sering (tiap 2-3 jam).\n'
          '2. Hindari makanan yang terlalu berminyak atau berbau menyengat.\n'
          '3. Minum air hangat atau teh jahe hangat secukupnya.\n\n'
          'Disclaimer: Informasi ini bersifat edukatif dan bukan pengganti diagnosis dokter.';
    } else if (isSafeContext || lower.contains('nutrisi') || lower.contains('makanan') || lower.contains('vitamin')) {
      return 'Untuk memperkuat dan menjaga stamina kehamilan, disarankan mengonsumsi:\n\n'
          '1. **Makanan Kaya Zat Besi:** Daging sapi tanpa lemak, hati ayam, bayam, dan kacang merah.\n'
          '2. **Vitamin C:** Jeruk, jambu biji, atau kiwi untuk membantu penyerapan zat besi secara optimal.\n'
          '3. **Asam Folat & Vitamin B12:** Untuk mendukung pembentukan sel saraf janin & sel darah ibu.\n\n'
          'Jangan lupa minum suplemen penambah darah sesuai rekomendasi Bidan / Dokter Bunda 🌸\n\n'
          'Disclaimer: Informasi ini bersifat edukatif dan bukan pengganti diagnosis dokter.';
    } else {
      return 'Terima kasih atas pertanyaannya Bunda 🌸\n\n'
          'Untuk menjaga kesehatan selama kehamilan, pastikan memenuhi asupan asam folat, zat besi, kalsium, serta istirahat yang cukup. Jangan ragu untuk berkonsultasi rutin dengan Bidan atau Dokter Spesialis Kandungan.\n\n'
          'Disclaimer: Informasi ini bersifat edukatif dan bukan pengganti diagnosis dokter.';
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
    } catch (e) {
      debugPrint('Error saving chat history log: $e');
    }
  }

  Future<void> clearCurrentSession() async {
    messages.clear();
    messages.add(ChatMessage(
      role: 'model',
      text: 'Pesan dalam sesi ini telah dibersihkan. Ada yang ingin ditanyakan lagi Bunda? 🌸',
      time: DateTime.now(),
    ));
    await _saveAllSessions();
  }
}
