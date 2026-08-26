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

  ChatController({
    required this.doula,
    required this.user,
    required this.isDoula,
  });

  @override
  void onInit() {
    chatId.value = user + doula;
    pengguna.value = isDoula ? doula : user;
    getData().then((_) => getChat());

    super.onInit();
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
