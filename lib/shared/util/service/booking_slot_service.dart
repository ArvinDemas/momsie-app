import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
import 'package:flutter/foundation.dart';

class BookingSlotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'booking_slots';

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

  static String docId(String doulaId, String tanggal) => '${doulaId}_$tanggal';

  /// Ambil slot untuk doula pada tanggal tertentu
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
      if (kDebugMode) debugPrint('Get slot error: $e');
      return null;
    }
  }

  /// Stream semua slot untuk doula
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

  /// Simpan/update slot untuk satu tanggal
  Future<void> saveSlot(BookingSlotModel slot) async {
    await _retry(() => _firestore
        .collection(_collection)
        .doc(slot.docId)
        .set(slot.toMap(), SetOptions(merge: true)));
  }

  /// Buat slot baru untuk tanggal tertentu
  Future<void> createSlot({
    required String doulaId,
    required String tanggal,
    required String time,
    required int capacity,
  }) async {
    final docId = BookingSlotService.docId(doulaId, tanggal);
    final slotRef = _firestore.collection(_collection).doc(docId);

    await _retry(() async {
      await _firestore.runTransaction((tx) async {
        final snapshot = await tx.get(slotRef);
        List<dynamic> slots = snapshot.exists
            ? List<dynamic>.from(snapshot.data()!['slots'] ?? [])
            : [];

        // Check slot already exists
        final existingIndex = slots.indexWhere(
          (s) => (s as Map<String, dynamic>)['time'] == time,
        );

        if (existingIndex >= 0) {
          // Update existing slot
          slots[existingIndex] = {
            'time': time,
            'capacity': capacity,
            'bookedCount': 0,
          };
        } else {
          slots.add({
            'time': time,
            'capacity': capacity,
            'bookedCount': 0,
          });
        }

        tx.set(slotRef, {
          'doulaId': doulaId,
          'tanggal': tanggal,
          'slots': slots,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    });
  }

  /// Update capacity slot
  Future<void> updateSlotCapacity({
    required String doulaId,
    required String tanggal,
    required String time,
    required int newCapacity,
  }) async {
    final docId = BookingSlotService.docId(doulaId, tanggal);
    final slotRef = _firestore.collection(_collection).doc(docId);

    await _retry(() async {
      await _firestore.runTransaction((tx) async {
        final snapshot = await tx.get(slotRef);
        if (!snapshot.exists) return;

        final slotsRaw = List<dynamic>.from(snapshot.data()!['slots'] ?? []);
        final index = slotsRaw.indexWhere(
          (s) => (s as Map<String, dynamic>)['time'] == time,
        );

        if (index >= 0) {
          slotsRaw[index]['capacity'] = newCapacity;
          tx.update(slotRef, {'slots': slotsRaw});
        }
      });
    });
  }

  /// Hapus slot jika bookedCount == 0
  Future<bool> deleteSlot({
    required String doulaId,
    required String tanggal,
    required String time,
  }) async {
    final docId = BookingSlotService.docId(doulaId, tanggal);
    final slotRef = _firestore.collection(_collection).doc(docId);

    try {
      await _retry(() async {
        await _firestore.runTransaction((tx) async {
          final snapshot = await tx.get(slotRef);
          if (!snapshot.exists) return false;

          final slotsRaw = List<dynamic>.from(snapshot.data()!['slots'] ?? []);
          final slotToDelete = slotsRaw.firstWhere(
            (s) => (s as Map<String, dynamic>)['time'] == time,
            orElse: () => null,
          );

          if (slotToDelete == null) return false;
          if ((slotToDelete as Map<String, dynamic>)['bookedCount'] > 0) return false;

          slotsRaw.remove(slotToDelete);
          tx.update(slotRef, {'slots': slotsRaw});
          return true;
        });
      });
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Delete slot error: $e');
      return false;
    }
  }

  /// Increment bookedCount saat booking dibuat (atomic transaction)
  Future<bool> incrementBookedCount({
    required String doulaId,
    required String tanggal,
    required String time,
  }) async {
    final docId = BookingSlotService.docId(doulaId, tanggal);
    final slotRef = _firestore.collection(_collection).doc(docId);

    try {
      await _retry(() async {
        await _firestore.runTransaction((tx) async {
          final snapshot = await tx.get(slotRef);
          if (!snapshot.exists) throw Exception('Slot document not found');

          final slotsRaw = List<dynamic>.from(snapshot.data()!['slots'] ?? []);
          final index = slotsRaw.indexWhere(
            (s) => (s as Map<String, dynamic>)['time'] == time,
          );

          if (index < 0) throw Exception('Slot not found');

          final slot = slotsRaw[index] as Map<String, dynamic>;
          final bookedCount = (slot['bookedCount'] as int?) ?? 0;
          final capacity = (slot['capacity'] as int?) ?? 1;

          if (bookedCount >= capacity) {
            throw Exception('Slot is full');
          }

          slotsRaw[index]['bookedCount'] = bookedCount + 1;
          tx.update(slotRef, {'slots': slotsRaw});
        });
      });
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Increment bookedCount error: $e');
      return false;
    }
  }

  /// Decrement bookedCount saat booking expired/cancelled (atomic transaction)
  Future<void> decrementBookedCount({
    required String doulaId,
    required String tanggal,
    required String time,
  }) async {
    final docId = BookingSlotService.docId(doulaId, tanggal);
    final slotRef = _firestore.collection(_collection).doc(docId);

    try {
      await _retry(() async {
        await _firestore.runTransaction((tx) async {
          final snapshot = await tx.get(slotRef);
          if (!snapshot.exists) return;

          final slotsRaw = List<dynamic>.from(snapshot.data()!['slots'] ?? []);
          final index = slotsRaw.indexWhere(
            (s) => (s as Map<String, dynamic>)['time'] == time,
          );

          if (index >= 0) {
            final current = (slotsRaw[index] as Map<String, dynamic>)['bookedCount'] ?? 0;
            final currentInt = (current as int? ?? 0);
            slotsRaw[index]['bookedCount'] = currentInt > 0 ? currentInt - 1 : 0;
            tx.update(slotRef, {'slots': slotsRaw});
          }
        });
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Decrement bookedCount error: $e');
    }
  }

  /// Ambil booked slots dari collection bookings
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

  /// Fetch bookings untuk slot tertentu
  Future<List<Map<String, dynamic>>> getBookingsForSlot({
    required String doulaId,
    required String tanggal,
    required String time,
  }) async {
    try {
      final snapshot = await _retry(() => _firestore
          .collection('bookings')
          .where('doulaUid', isEqualTo: doulaId)
          .where('tanggal', isEqualTo: tanggal)
          .where('jam', isEqualTo: time)
          .get());
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('Get bookings for slot error: $e');
      return [];
    }
  }
}
