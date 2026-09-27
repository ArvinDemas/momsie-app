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
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => BookingSlotModel.fromMap(doc.data(), docId: doc.id))
              .toList();
          list.sort((a, b) => a.tanggal.compareTo(b.tanggal));
          return list;
        });
  }

  /// Simpan/update slot untuk satu tanggal
  Future<void> saveSlot(BookingSlotModel slot) async {
    await _retry(() => _firestore
        .collection(_collection)
        .doc(slot.docId)
        .set(slot.toMap(), SetOptions(merge: true)));
  }

  /// Helper untuk normalisasi slot dari Firestore (mendukung Map dan String legacy)
  static Map<String, dynamic> _normalizeSlot(dynamic s) {
    if (s is Map) {
      return {
        'time': s['time']?.toString() ?? '',
        'capacity': (s['capacity'] as num?)?.toInt() ?? 1,
        'bookedCount': (s['bookedCount'] as num?)?.toInt() ?? 0,
      };
    } else if (s is String) {
      return {
        'time': s,
        'capacity': 1,
        'bookedCount': 0,
      };
    }
    return {
      'time': '',
      'capacity': 1,
      'bookedCount': 0,
    };
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
        final slotsRaw = snapshot.exists
            ? List<dynamic>.from(snapshot.data()!['slots'] ?? [])
            : [];
        final slots = slotsRaw.map(_normalizeSlot).toList();

        // Check slot already exists
        final existingIndex = slots.indexWhere((s) => s['time'] == time);

        if (existingIndex >= 0) {
          slots[existingIndex] = {
            'time': time,
            'capacity': capacity,
            'bookedCount': slots[existingIndex]['bookedCount'] ?? 0,
          };
        } else {
          slots.add({
            'time': time,
            'capacity': capacity,
            'bookedCount': 0,
          });
        }
        slots.sort((a, b) => (a['time'] as String).compareTo(b['time'] as String));

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
        final slots = slotsRaw.map(_normalizeSlot).toList();
        final index = slots.indexWhere((s) => s['time'] == time);

        if (index >= 0) {
          slots[index]['capacity'] = newCapacity;
          tx.update(slotRef, {'slots': slots});
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
          final slots = slotsRaw.map(_normalizeSlot).toList();
          final slotToDelete = slots.firstWhere(
            (s) => s['time'] == time,
            orElse: () => <String, dynamic>{},
          );

          if (slotToDelete.isEmpty) return false;
          if ((slotToDelete['bookedCount'] as int? ?? 0) > 0) return false;

          slots.removeWhere((s) => s['time'] == time);
          tx.update(slotRef, {'slots': slots});
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
          if (!snapshot.exists) {
            // Auto-inisialisasi slot document jika belum ada di Firestore
            const defaultTimes = ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '19:00'];
            final List<Map<String, dynamic>> initialSlots = defaultTimes.map((t) => {
              'time': t,
              'capacity': 1,
              'bookedCount': t == time ? 1 : 0,
            }).toList();

            if (!defaultTimes.contains(time)) {
              initialSlots.add({
                'time': time,
                'capacity': 1,
                'bookedCount': 1,
              });
            }
            initialSlots.sort((a, b) => (a['time'] as String).compareTo(b['time'] as String));

            tx.set(slotRef, {
              'doulaId': doulaId,
              'tanggal': tanggal,
              'slots': initialSlots,
              'createdAt': FieldValue.serverTimestamp(),
            });
            return;
          }

          final slotsRaw = List<dynamic>.from(snapshot.data()!['slots'] ?? []);
          final slots = slotsRaw.map(_normalizeSlot).toList();
          final index = slots.indexWhere((s) => s['time'] == time);

          if (index < 0) {
            // Slot waktu belum tercatat, tambahkan dengan bookedCount = 1
            slots.add({
              'time': time,
              'capacity': 1,
              'bookedCount': 1,
            });
            slots.sort((a, b) => (a['time'] as String).compareTo(b['time'] as String));
            tx.update(slotRef, {'slots': slots});
            return;
          }

          final slot = slots[index];
          final bookedCount = slot['bookedCount'] as int;
          final capacity = slot['capacity'] as int;

          if (bookedCount >= capacity) {
            throw Exception('Slot is full');
          }

          slots[index]['bookedCount'] = bookedCount + 1;
          tx.update(slotRef, {'slots': slots});
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
          final slots = slotsRaw.map(_normalizeSlot).toList();
          final index = slots.indexWhere((s) => s['time'] == time);

          if (index >= 0) {
            final current = slots[index]['bookedCount'] as int;
            slots[index]['bookedCount'] = current > 0 ? current - 1 : 0;
            tx.update(slotRef, {'slots': slots});
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
            .map((doc) => doc.data()['jam']?.toString() ?? '')
            .where((j) => j.isNotEmpty)
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
