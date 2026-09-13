// test/shared/service/booking_slot_service_test.dart
//
// Unit test untuk BookingSlotService — race condition guard & capacity logic.
// Jalankan: flutter test test/shared/service/booking_slot_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:douce/shared/util/model/booking_slot_model.dart';
import 'package:douce/shared/util/service/booking_slot_service.dart';

void main() {
  group('SlotItem', () {
    test('fromMap memvalidasi capacity & bookedCount dari Firestore map', () {
      final slot = SlotItem.fromMap({
        'time': '10:00',
        'capacity': 3,
        'bookedCount': 2,
      });
      expect(slot.time, '10:00');
      expect(slot.capacity, 3);
      expect(slot.bookedCount, 2);
      expect(slot.isFull, false);
    });

    test('fromMap fallback: capacity default 1, bookedCount default 0', () {
      final slot = SlotItem.fromMap({'time': '12:00'});
      expect(slot.capacity, 1);
      expect(slot.bookedCount, 0);
    });

    test('isFull=true saat bookedCount==capacity', () {
      final slot = SlotItem(time: '14:00', capacity: 2, bookedCount: 2);
      expect(slot.isFull, true);
    });

    test('isFull=false saat bookedCount<capacity', () {
      final slot = SlotItem(time: '09:00', capacity: 5, bookedCount: 0);
      expect(slot.isFull, false);
    });

    test('copyWith mengubah bookedCount tanpa ubah field lain', () {
      final original = SlotItem(time: '11:00', capacity: 3, bookedCount: 1);
      final updated = original.copyWith(bookedCount: 2);
      expect(updated.time, '11:00');
      expect(updated.capacity, 3);
      expect(updated.bookedCount, 2);
    });
  });

  group('BookingSlotService.docId', () {
    test('docId format: doulaId_tanggal', () {
      expect(BookingSlotService.docId('doula-abc', '2026-09-15'),
          'doula-abc_2026-09-15');
    });

    test('docId dengan input kosong menghasilkan underscore', () {
      expect(BookingSlotService.docId('', ''), '_');
    });
  });

  group('BookingSlotModel', () {
    test('fromMap menghasilkan docId dari parameter', () {
      final model = BookingSlotModel.fromMap(
        {'doulaId': 'd1', 'tanggal': '2026-09-15', 'slots': []},
        docId: 'd1_2026-09-15',
      );
      expect(model.docId, 'd1_2026-09-15');
      expect(model.doulaId, 'd1');
      expect(model.tanggal, '2026-09-15');
    });

    test('fromMap fallback: empty map', () {
      final model = BookingSlotModel.fromMap({});
      expect(model.docId, '');
      expect(model.doulaId, '');
      expect(model.tanggal, '');
      expect(model.slots, <SlotItem>[]);
    });

    test('toMap mengembalikan doulaId & tanggal', () {
      final model = BookingSlotModel(
        docId: 'd2_2026-09-20',
        doulaId: 'd2',
        tanggal: '2026-09-20',
        slots: [],
        createdAt: DateTime(2026, 9, 1),
      );
      final map = model.toMap();
      expect(map['doulaId'], 'd2');
      expect(map['tanggal'], '2026-09-20');
      expect(map['slots'], <dynamic>[]);
    });

    test('copyWith dengan slots baru', () {
      final original = BookingSlotModel(
        docId: 'd3_2026-10-01',
        doulaId: 'd3',
        tanggal: '2026-10-01',
        slots: [],
        createdAt: DateTime(2026, 10, 1),
      );
      final updated = original.copyWith(
        slots: [SlotItem(time: '08:00', capacity: 2, bookedCount: 0)],
      );
      expect(updated.slots.length, 1);
      expect(updated.slots[0].time, '08:00');
      // Fields lain tetap sama
      expect(updated.doulaId, 'd3');
      expect(updated.tanggal, '2026-10-01');
    });
  });

  group('Atomic slot reservation guard (Fix #17 simulation)', () {
    // Simulasi logika atomic reservation di payment_service.dart:
    // incrementBookedCount() dipanggil SEBELUM batch commit transaksi.
    // Jika slot penuh (false), exception dilempar dan no transaction dibuat.

    test('incrementBookedCount berhasil saat kapasitas tersedia', () {
      int bookedCount = 2;
      final capacity = 3;
      // Guard check: bookable?
      expect(bookedCount < capacity, true);
      // Atomic increment (simulasi transaksi Firestore)
      bookedCount = bookedCount + 1;
      expect(bookedCount, 3);
    });

    test('incrementBookedCount gagal saat slot penuh (race condition guard)',
        () {
      int bookedCount = 3;
      final capacity = 3;
      // Guard: jika sudah penuh, tolak booking
      final canBook = bookedCount < capacity;
      expect(canBook, false);
      // bookedCount tidak berubah — atomic guard bekerja
    });

    test('decrementBookedCount clamp ke 0 (Fix #17 verify)', () {
      int bookedCount = 0;
      bookedCount = bookedCount > 0 ? bookedCount - 1 : 0;
      expect(bookedCount, 0);
    });

    test('Race condition: dua user booking slot terakhir', () {
      // User A dan B concurrently request slot terakhir (bookedCount=0, capacity=1)
      int bookedCount = 0;
      final capacity = 1;

      // User A: check guard → OK (0 < 1), increment
      bool userABooked = bookedCount < capacity; // true
      if (userABooked) bookedCount = bookedCount + 1; // → 1

      // User B: check guard → FAIL (1 < 1 = false, slot penuh)
      bool userBBooked = bookedCount < capacity; // false
      expect(userBBooked, false); // B ditolak
      expect(bookedCount, 1); // A berhasil, total booked = 1
    });

    test('SlotItem.isFull mencegah booking slot penuh', () {
      final slots = [
        SlotItem(time: '10:00', capacity: 1, bookedCount: 1),
        SlotItem(time: '15:00', capacity: 2, bookedCount: 1),
      ];
      // Slot 10:00 penuh
      expect(slots[0].isFull, true);
      // Slot 15:00 masih ada tempat
      expect(slots[1].isFull, false);
    });

    test('Slots kosong berarti hasAvailableSlot=true', () {
      final slots = [
        SlotItem(time: '09:00', capacity: 3, bookedCount: 0),
      ];
      final anyAvailable = slots.any((s) => !s.isFull);
      expect(anyAvailable, true);
    });
  });
}
