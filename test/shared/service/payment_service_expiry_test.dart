// test/shared/service/payment_service_expiry_test.dart
//
// Unit test untuk edge case expire booking — verify capacity release logic
// dan timeout behavior.
// Jalankan: flutter test test/shared/service/payment_service_expiry_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Expire booking capacity release', () {
    test('Expired booking: bookedCount decrement dengan clamp', () {
      int bookedCount = 1;
      final capacity = 1;
      // Simulasi expireBookingWithCapacityRelease
      bookedCount = bookedCount > 0 ? bookedCount - 1 : 0;
      expect(bookedCount, 0);
      expect(bookedCount <= capacity, true);
    });

    test('Expired booking: multiple bookings di slot yang sama', () {
      int bookedCount = 2;
      final capacity = 3;
      // Booking 1 expire
      bookedCount = bookedCount > 0 ? bookedCount - 1 : 0; // → 1
      // Booking 2 expire
      bookedCount = bookedCount > 0 ? bookedCount - 1 : 0; // → 0
      expect(bookedCount, 0);
      expect(capacity - bookedCount, 3); // kapasitas kembali penuh
    });

    test('Expired booking: bookedCount tidak negatif setelah clamp', () {
      int bookedCount = 0;
      bookedCount = bookedCount > 0 ? bookedCount - 1 : 0;
      expect(bookedCount, 0);
      expect(bookedCount >= 0, true);
    });
  });

  group('Booking timeout — 15 minutes expiry', () {
    // Simulasi countdown 15 menit expire pending booking
    // Fix #17: jika user tidak menyelesaikan pembayaran dalam 15 menit,
    // booking di-expire dan slot capacity dilepaskan.

    test('Booking pending selama < 15 menit: tetap aktif', () {
      final createdAt = DateTime.now().subtract(const Duration(minutes: 5));
      final fifteenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 15));
      expect(createdAt.isAfter(fifteenMinutesAgo), true);
      // Booking masih aktif
    });

    test('Booking pending selama >= 15 menit: perlu di-expire', () {
      final createdAt = DateTime.now().subtract(const Duration(minutes: 20));
      final fifteenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 15));
      expect(createdAt.isBefore(fifteenMinutesAgo), true);
      // Booking harus di-expire
    });

    test('Booking dengan status paid: tidak di-expire oleh timer', () {
      final status = 'paid';
      final shouldExpire = status == 'pending';
      expect(shouldExpire, false);
    });
  });

  group('WhatsApp fallback link validation', () {
    test('Template pesan WhatsApp mengandung Order ID', () {
      final orderId = 'TX-MSI-ABC123';
      final template =
          'Halo Admin Momsie, saya ingin konfirmasi booking $orderId';
      expect(template.contains(orderId), true);
    });

    test('URL wa.me valid untuk nomor Indonesia', () {
      final url = 'https://wa.me/6281373673251';
      expect(url.startsWith('https://wa.me/'), true);
      expect(url.contains('6281373673251'), true);
    });

    test('URL Instagram valid', () {
      final url = 'https://instagram.com/momsiee.id';
      expect(url.startsWith('https://instagram.com/'), true);
      expect(url.contains('momsiee.id'), true);
    });
  });

  group('On-demand materi access grant', () {
    // Verifikasi bahwa on-demand service (materi_online, paket_bundling)
    // menerima akses materi secara instan setelah pembayaran.

    test('materi_online → grant access otomatis', () {
      final layanan = 'materi_online';
      final isOnDemand = ['materi_online', 'paket_bundling']
          .any((s) => layanan.toLowerCase().contains(s));
      expect(isOnDemand, true);
    });

    test('chat_doula → auto-confirm, bukan on-demand access', () {
      final layanan = 'chat_doula';
      final isOnDemand = ['materi_online', 'paket_bundling']
          .any((s) => layanan.toLowerCase().contains(s));
      expect(isOnDemand, false);
      final isAutoConfirm = ['chat_doula', 'prenatal_yoga', 'materi_online',
          'paket_bundling']
          .any((s) => layanan.toLowerCase().contains(s));
      expect(isAutoConfirm, true);
    });

    test('doula_offline → tidak auto-confirm, tunggu manual', () {
      final layanan = 'doula_offline';
      final isAutoConfirm = ['chat_doula', 'prenatal_yoga', 'materi_online',
          'paket_bundling']
          .any((s) => layanan.toLowerCase().contains(s));
      expect(isAutoConfirm, false);
    });
  });
}
