import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/features/user/chat/chat_model.dart';
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

  final Rx<TextEditingController> messageController =
      TextEditingController().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ChatModel> messages = <ChatModel>[].obs;

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
      firestore
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
    } catch (_) {}
  }

  Future<void> sendMessage() async {
    try {
      if (chatId.isNotEmpty) {
        final text = messageController.value.text.trim();
        if (text.isEmpty) return;
        messageController.value.clear();
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
    } catch (_) {}
  }
}
