import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SopCsMessagePage extends StatefulWidget {
  const SopCsMessagePage({super.key});

  @override
  State<SopCsMessagePage> createState() => _SopCsMessagePageState();
}

class _SopCsMessagePageState extends State<SopCsMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Isi pesan terlebih dahulu',
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      await _firestore.collection('cs_messages').add({
        'userId': _userController.uid.value,
        'userEmail': _userController.email.value,
        'userName': _userController.username.value,
        'message': _messageController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      _messageController.clear();
      Get.snackbar(
        'Terkirim!',
        'Pesan Anda telah dikirim ke Customer Service',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hubungi Customer Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorDouce.douceBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: ColorDouce.douceBase),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tulis pesan Anda terkait pendaftaran. Tim CS akan merespon secepatnya melalui halaman ini.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pesan Anda:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Contoh: Saya ingin menanyakan proses verifikasi pendaftaran saya...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorDouce.douceBase,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kirim Pesan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
