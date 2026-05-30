import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String sender;
  final String message;
  /// Disimpan sebagai Firestore Timestamp; ditampilkan sebagai h:mm.
  final Timestamp? time;

  ChatModel({
    required this.sender,
    required this.message,
    this.time,
  });

  String get formattedTime {
    if (time == null) return '';
    final dt = time!.toDate();
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }
}
