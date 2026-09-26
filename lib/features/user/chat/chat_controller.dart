import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:douce/features/user/chat/chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final String doula;
  final String user;
  final bool isDoula;
  final String? bookingId;

  ChatController({
    required this.doula,
    required this.user,
    required this.isDoula,
    this.bookingId,
  });

  final RxBool chatAccessAllowed = true.obs;
  final RxString accessMessage = ''.obs;

  @override
  void onInit() {
    chatId.value = user + doula;
    pengguna.value = isDoula ? doula : user;

    if (bookingId != null && !isDoula) {
      _validateChatAccess(bookingId!);
    } else {
      getData().then((_) => getChat());
    }

    super.onInit();
  }

  Future<void> _validateChatAccess(String bookingId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (!snapshot.exists) {
        chatAccessAllowed.value = false;
        accessMessage.value = 'Booking tidak ditemukan';
        return;
      }

      final data = snapshot.data()!;
      final status = data['status'] as String?;
      final isOnDemand = data['isOnDemand'] as bool? ?? false;
      final jam = data['jam'] as String?;
      final tanggal = data['tanggal'] as String?;
      final layanan = data['layanan'] as String? ?? '';

      // Persist slot info for header display
      slotLayanan.value = layanan;
      slotIsOnDemand.value = isOnDemand;
      slotStatus.value = status ?? '';
      slotTanggal.value = tanggal ?? '';
      slotJam.value = jam ?? '';

      // Validasi 1: status harus aktif
      if (!['paid', 'confirmed', 'ongoing'].contains(status)) {
        chatAccessAllowed.value = false;
        accessMessage.value = 'Chat belum tersedia untuk pesanan ini';
        return;
      }

      // Validasi 2: untuk scheduled services, cek waktu slot (dikecualikan untuk ongoing, layanan chat/konsultasi, atau akun demo)
      final isDemoUser = user.toLowerCase().contains('adnar') ||
          user.toLowerCase().contains('arvin') ||
          doula.toLowerCase().contains('dewi');
      final isChatConsultation = layanan.toLowerCase().contains('chat') ||
          layanan.toLowerCase().contains('konsultasi');

      if (!isOnDemand &&
          !isDemoUser &&
          !isChatConsultation &&
          status != 'ongoing' &&
          jam != null &&
          tanggal != null) {
        final now = DateTime.now();
        final slotDateTime = _parseSlotDateTime(tanggal, jam);

        if (slotDateTime != null) {
          final diffMinutes = now.difference(slotDateTime).abs().inMinutes;
          if (diffMinutes > 5) {
            chatAccessAllowed.value = false;
            accessMessage.value = 'Waktu chat belum tersedia (slot $jam)';
            return;
          }
        }
      }

      // Akses diizinkan
      chatAccessAllowed.value = true;
      getData().then((_) => getChat());
    } catch (e) {
      if (kDebugMode) debugPrint('Chat access validation error: $e');
      chatAccessAllowed.value = false;
      accessMessage.value = 'Gagal memvalidasi akses chat';
    }
  }

  DateTime? _parseSlotDateTime(String tanggal, String jam) {
    try {
      // Format tanggal: "2026-09-15", jam: "10:00"
      final date = DateTime.tryParse(tanggal);
      if (date == null) return null;

      final timeParts = jam.split(':');
      if (timeParts.length < 2) return null;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) return null;

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  final RxString namaDoula = ''.obs;
  final RxString namaUser = ''.obs;
  final RxString imageDoula = ''.obs;
  final RxString imageUser = ''.obs;
  final RxString chatId = ''.obs;
  final RxString pengguna = ''.obs;

  // Slot info for scheduled services
  final RxString slotTanggal = ''.obs;
  final RxString slotJam = ''.obs;
  final RxString slotLayanan = ''.obs;
  final RxBool slotIsOnDemand = false.obs;
  final RxString slotStatus = ''.obs;

  final TextEditingController messageController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ChatModel> messages = <ChatModel>[].obs;

  StreamSubscription? _chatSubscription;

  Future<void> getData() async {
    try {
      final value = await firestore.collection('mitra').doc(doula).get();
      if (value.exists) {
        imageDoula.value = value['image'] ?? '';
        namaDoula.value = value['name'] ?? '';
      }
    } catch (_) {}

    if (namaDoula.value.isEmpty) {
      if (doula.toLowerCase().contains('dewi') || doula == 'doula_dewi') {
        namaDoula.value = 'Doula Dewi Sartika, S.Keb';
        imageDoula.value = 'assets/images/doula_dewi.png';
      } else if (doula.toLowerCase().contains('anastasia') || doula == 'doula_anastasia') {
        namaDoula.value = 'Anastasia Mawardi';
        imageDoula.value = 'assets/images/blank-profile.png';
      } else {
        namaDoula.value = 'Doula Dewi Sartika, S.Keb';
        imageDoula.value = 'assets/images/doula_dewi.png';
      }
    }

    try {
      final value = await firestore.collection('user').doc(user).get();
      if (value.exists) {
        imageUser.value = value['image'] ?? '';
        namaUser.value = value['username'] ?? '';
      }
    } catch (_) {}

    if (namaUser.value.isEmpty) {
      if (user.toLowerCase().contains('arvin') || user.toLowerCase().contains('adnar')) {
        namaUser.value = 'Arvin Demas Naryama';
        imageUser.value = 'assets/images/blank-profile.png';
      } else if (user == 'user_nadia') {
        namaUser.value = 'Bunda Nadia Salsabila';
        imageUser.value = 'assets/images/blank-profile.png';
      } else if (user == 'user_clarissa') {
        namaUser.value = 'Bunda Clarissa Putri';
        imageUser.value = 'assets/images/blank-profile.png';
      } else if (user == 'user_sarah') {
        namaUser.value = 'Bunda Sarah Larasati';
        imageUser.value = 'assets/images/blank-profile.png';
      } else if (user == 'user_rina') {
        namaUser.value = 'Bunda Rina Anggraini';
        imageUser.value = 'assets/images/blank-profile.png';
      } else {
        namaUser.value = 'Arvin Demas Naryama';
        imageUser.value = 'assets/images/blank-profile.png';
      }
    }
  }

  void _loadDemoMessages() {
    if (messages.isNotEmpty) return;
    final now = DateTime.now();

    final isDewiDemo = doula.toLowerCase().contains('dewi') ||
        user.toLowerCase().contains('adnar') ||
        user.toLowerCase().contains('arvin');

    if (isDewiDemo) {
      messages.value = [
        ChatModel(
          sender: user,
          message: 'Halo Doula, selamat siang. Mau update perkembangan setelah sesi konsultasi kita kemarin 🌸',
          time: Timestamp.fromDate(now.subtract(const Duration(days: 1, hours: 4))),
        ),
        ChatModel(
          sender: doula,
          message: 'Halo Bunda! Salam hangat ya 💖 Senang sekali mendengar kabarnya. Bagaimana perkembangannya setelah mencoba arahan kemarin?',
          time: Timestamp.fromDate(now.subtract(const Duration(days: 1, hours: 3, minutes: 40))),
        ),
        ChatModel(
          sender: user,
          message: 'Alhamdulillah setelah rutin coba latihan pernapasan perut dan kompres hangat di pinggang yang Doula sarankan, rasa tegang dan pegal di pinggang bawah sudah jauh lebih berkurang. Kontraksi palsu semalam juga lebih tenang dan tidak panik.',
          time: Timestamp.fromDate(now.subtract(const Duration(days: 1, hours: 3, minutes: 15))),
        ),
        ChatModel(
          sender: doula,
          message: 'Alhamdulillah, kabar baik sekali Bunda! Artinya tubuh Bunda merespons teknik relaksasi dengan sangat baik. Tetap jaga hidrasi dan jangan lupa afirmasi positifnya ya ✨',
          time: Timestamp.fromDate(now.subtract(const Duration(days: 1, hours: 2, minutes: 50))),
        ),
        ChatModel(
          sender: user,
          message: 'Iya Doula. Pagi ini gerakan si kecil terasa makin aktif dan posisinya mulai terasa makin turun ke arah panggul.',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 3, minutes: 30))),
        ),
        ChatModel(
          sender: doula,
          message: 'Masya Allah, itu tanda alami bahwa si kecil semakin siap mencari jalan lahir Bunda 🌸 Apakah masih ada keluhan saat berjalan atau bergerak?',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 3, minutes: 5))),
        ),
        ChatModel(
          sender: user,
          message: 'Hanya sedikit sensasi berat di panggul bawah saat berdiri lama Doula. Untuk sesi pendampingan hari ini apakah kita tetap fokus latihan posisi tegak dan birthing ball?',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 2, minutes: 10))),
        ),
        ChatModel(
          sender: doula,
          message: 'Iya betul Bunda. Nanti saat sesi kita akan optimalkan latihan posisi panggul terbuka (open pelvis) dengan birthing ball dan teknik counter-pressure agar tetap nyaman menjelang persalinan. Perlengkapan sudah saya siapkan.',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 1, minutes: 30))),
        ),
        ChatModel(
          sender: user,
          message: 'Baik Doula, birthing ball dan ruangan sudah kami siapkan di rumah. Terima kasih banyak atas bimbingannya selama ini, sampai bertemu nanti ya Doula 🙏',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
        ),
        ChatModel(
          sender: doula,
          message: 'Sama-sama Bunda. Istirahat yang cukup dulu ya, sampai bertemu nanti di rumah Bunda ✨🌸',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 20))),
        ),
      ];
    } else if (user == 'user_clarissa') {
      messages.value = [
        ChatModel(
          sender: user,
          message: 'Halo Bidan Anastasia, salam kenal ya 🌸 Saya Clarissa dari Mlati, Sleman.',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 50))),
        ),
        ChatModel(
          sender: doula,
          message: 'Halo Bunda Clarissa! Salam hangat juga 💖 Senang sekali bisa berkenalan dengan Bunda. Ada yang bisa saya bantu atau persiapkan untuk sesi besok?',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
        ),
        ChatModel(
          sender: user,
          message: 'Iya Bidan, besok jadwal konsultasi Gentle Birth jam 14.00 ya. Nanti suami saya juga mau ikut belajar teknik napas dan afirmasi positif.',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 30))),
        ),
        ChatModel(
          sender: doula,
          message: 'Bagus sekali Bunda! Keterlibatan suami sangat penting sebagai birth partner. Sampai jumpa besok jam 14.00 ya Bunda Clarissa ✨',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 20))),
        ),
        ChatModel(
          sender: user,
          message: 'Terima kasih banyak Bidan Anastasia, sampai ketemu besok! 🙏',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 10))),
        ),
      ];
    } else {
      // Default / user_nadia
      messages.value = [
        ChatModel(
          sender: user,
          message: 'Selamat pagi Bidan Anastasia 🌸',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 2, minutes: 15))),
        ),
        ChatModel(
          sender: user,
          message: 'Saya Nadia yang booking paket Pendampingan Persalinan & Pijat Trimester 3 untuk hari ini.',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 2, minutes: 10))),
        ),
        ChatModel(
          sender: doula,
          message: 'Selamat pagi Bunda Nadia! 💖 Salam hangat ya. Bagaimana kondisi kehamilan dan perasaan Bunda pagi ini?',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 1, minutes: 55))),
        ),
        ChatModel(
          sender: user,
          message: 'Punggung bawah agak pegal Bidan, dan semalam sempat ada kontraksi palsu beberapa kali. Tapi dedek bayinya aktif bergerak.',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 1, minutes: 40))),
        ),
        ChatModel(
          sender: doula,
          message: 'Alhamdulillah dedek aktif ya Bunda. Kontraksi palsu (Braxton Hicks) wajar di minggu ke-35. Nanti saat sesi kita akan latih relaksasi otot panggul dan pijat punggung yang nyaman.',
          time: Timestamp.fromDate(now.subtract(const Duration(hours: 1, minutes: 20))),
        ),
        ChatModel(
          sender: user,
          message: 'Alhamdulillah, terima kasih banyak Bidan. Nanti jam 10.00 saya tunggu di rumah ya Bidan Anastasia.',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
        ),
        ChatModel(
          sender: doula,
          message: 'Siap Bunda Nadia, perlengkapan sudah saya siapkan. Sampai bertemu sebentar lagi ya Bunda 🌸',
          time: Timestamp.fromDate(now.subtract(const Duration(minutes: 30))),
        ),
      ];
    }
  }

  Future<void> getChat() async {
    try {
      _chatSubscription = firestore
          .collection('chat')
          .doc(chatId.value)
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots()
          .listen((event) {
            final isDewiDemo = doula.toLowerCase().contains('dewi') ||
                user.toLowerCase().contains('adnar') ||
                user.toLowerCase().contains('arvin');

            if (event.docs.isNotEmpty) {
              final loaded = event.docs
                  .map((e) => ChatModel(
                    sender: e['sender'],
                    message: e['message'] as String? ?? '',
                    replyQuote: e['replyQuote'] as String?,
                    time: e['time'] as Timestamp?,
                  ))
                  .toList();

              final hasOldNames = loaded.any((m) {
                final lower = m.message.toLowerCase();
                return lower.contains('arvin') ||
                    lower.contains('nadia') ||
                    lower.contains('clarissa') ||
                    lower.contains('anastasia') ||
                    lower.contains('dewi');
              });

              if (isDewiDemo && (loaded.length < 5 || hasOldNames)) {
                _loadDemoMessages();
                _seedDemoMessagesToFirestore();
              } else {
                messages.value = loaded;
              }
            } else {
              _loadDemoMessages();
              if (isDewiDemo) {
                _seedDemoMessagesToFirestore();
              }
            }
      }, onError: (e) {
        debugPrint('Chat error: $e');
        _loadDemoMessages();
      });
    } catch (e) {
      debugPrint('Chat error: $e');
      _loadDemoMessages();
    }
  }

  Future<void> _seedDemoMessagesToFirestore() async {
    if (chatId.value.isEmpty || messages.isEmpty) return;
    try {
      final msgCol = firestore.collection('chat').doc(chatId.value).collection('messages');
      final existing = await msgCol.get();
      final batch = firestore.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      for (final m in messages) {
        final docRef = msgCol.doc();
        batch.set(docRef, {
          'sender': m.sender,
          'message': m.message,
          'time': m.time ?? FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Seed demo chat note: $e');
    }
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    messageController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final text = messageController.value.text.trim();
    if (text.isEmpty) return;
    messageController.clear();

    final newMsg = ChatModel(
      sender: isDoula ? doula : user,
      message: text,
      time: Timestamp.now(),
    );
    messages.add(newMsg);

    try {
      if (chatId.isNotEmpty) {
        await firestore
            .collection('chat')
            .doc(chatId.value)
            .collection('messages')
            .add({
          'sender': isDoula ? doula : user,
          'message': text,
          'time': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Send message Firestore note: $e');
    }
  }
}
