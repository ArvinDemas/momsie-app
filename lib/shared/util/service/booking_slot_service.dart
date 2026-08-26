import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
import 'package:flutter/foundation.dart';

class BookingSlotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'booking_slots';

  /// Retry helper dengan exponential backoff untuk operasi Firestore yang gagal.
  Future<T> _retry<T>(Future<T> Function() fn, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await fn();
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1 << i));
      }
    }
    return await fn();
  }

  /// Generate doc ID dari doulaId + tanggal
  static String docId(String doulaId, String tanggal) => '${doulaId}_$tanggal';

  /// Ambil semua slot yang tersedia untuk doula pada tanggal tertentu
  Future<BookingSlotModel?> getSlot(String doulaId, String tanggal) async {
    try {
      final doc = await _retry(() => _firestore
          .collection(_collection)
          .doc(docId(doulaId, tanggal))
          .get());
      if (doc.exists) {
        return BookingSlotModel.fromMap(doc.data()!, docId: doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Simpan slot availability untuk satu tanggal
  Future<void> saveSlot(BookingSlotModel slot) async {
    await _retry(() => _firestore
        .collection(_collection)
        .doc(slot.docId)
        .set(slot.toMap(), SetOptions(merge: true)));
  }

  /// Hapus slot pada tanggal tertentu
  Future<void> deleteSlot(String doulaId, String tanggal) async {
    await _retry(() => _firestore
        .collection(_collection)
        .doc(docId(doulaId, tanggal))
        .delete());
  }

  /// Ambil semua slot untuk doula (semua tanggal)
  Stream<List<BookingSlotModel>> streamSlotsByDoula(String doulaId) {
    return _firestore
        .collection(_collection)
        .where('doulaId', isEqualTo: doulaId)
        .orderBy('tanggal')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BookingSlotModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }

  /// Ambil semua slot yang sudah dibooking (dari collection bookings)
  Future<Map<String, List<String>>> getBookedSlots({
    required String doulaId,
    required List<String> tanggalList,
  }) async {
    final Map<String, List<String>> booked = {};
    try {
      for (String tgl in tanggalList) {
        final snapshot = await _retry(() => _firestore
            .collection('bookings')
            .where('doulaUid', isEqualTo: doulaId)
            .where('tanggal', isEqualTo: tgl)
            .where('status', whereIn: ['confirmed', 'ongoing', 'completed'])
            .get());
        booked[tgl] = snapshot.docs
            .map((doc) => doc['jam'] as String)
            .toList();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Booking slot error: $e');
    }
    return booked;
  }
}
