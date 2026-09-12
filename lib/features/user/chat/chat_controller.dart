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

      // Validasi 1: status harus aktif
      if (!['paid', 'confirmed', 'ongoing'].contains(status)) {
        chatAccessAllowed.value = false;
        accessMessage.value = 'Chat belum tersedia untuk pesanan ini';
        return;
      }

      // Validasi 2: untuk scheduled services, cek waktu slot
      if (!isOnDemand && jam != null && tanggal != null) {
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

  final TextEditingController messageController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ChatModel> messages = <ChatModel>[].obs;

  StreamSubscription? _chatSubscription;

  Future<void> getData() async {
    await firestore.collection('mitra').doc(doula).get().then((value) {
      imageDoula.value = value['image'];
      namaDoula.value = value['name'];
    });

    await firestore.collection('user').doc(user).get().then((value) {
      imageUser.value = value['image'];
      namaUser.value = value['username'];
    });
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
            messages.value = event.docs
                .map((e) => ChatModel(
                  sender: e['sender'],
                  message: e['message'],
                  time: e['time'] as Timestamp?,
                ))
            .toList();
      });
    } catch (e) {
      debugPrint('Chat error: $e');
    }
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    messageController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    try {
      if (chatId.isNotEmpty) {
        final text = messageController.value.text.trim();
        if (text.isEmpty) return;
        messageController.clear();
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
      debugPrint('Send message error: $e');
    }
  }
}
