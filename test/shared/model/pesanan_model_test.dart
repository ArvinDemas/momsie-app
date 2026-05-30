// test/shared/model/pesanan_model_test.dart
//
// Unit test untuk PesananModel dan ActiveModel.
// Jalankan dengan: flutter test test/shared/model/pesanan_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';

void main() {
  group('PesananModel', () {
    test('fromMap() membuat objek dengan benar dari data Firestore', () {
      final map = {
        'id': 'pesanan-001',
        'user': 'uid-user-123',
        'tanggal': '2024-06-15',
        'day': 'Sabtu',
        'jam': '09:00',
        'layanan': 'Persalinan',
        'harga': 500000,
      };

      final model = PesananModel.fromMap(map, namaUser: 'Budi');

      expect(model.id, 'pesanan-001');
      expect(model.pemesan, 'uid-user-123');
      expect(model.tanggal, '2024-06-15');
      expect(model.day, 'Sabtu');
      expect(model.jam, '09:00');
      expect(model.layanan, 'Persalinan');
      expect(model.harga, '500000');
      expect(model.namaUser, 'Budi');
    });

    test('fromMap() tidak crash ketika field Firestore null (fallback aman)',
        () {
      final map = <String, dynamic>{};

      final model = PesananModel.fromMap(map);

      expect(model.id, '');
      expect(model.pemesan, '');
      expect(model.tanggal, '');
      expect(model.harga, '0');
      expect(model.namaUser, '');
    });

    test('fromMap() mengkonversi harga int ke String dengan benar', () {
      final map = {'harga': 750000};
      final model = PesananModel.fromMap(map);
      expect(model.harga, '750000');
    });

    test('toMap() menghasilkan Map yang sesuai dengan field Firestore', () {
      final model = PesananModel(
        id: 'pesanan-002',
        pemesan: 'uid-123',
        tanggal: '2024-07-01',
        day: 'Senin',
        jam: '10:00',
        layanan: 'Nifas',
        harga: '300000',
        namaUser: 'Siti',
      );

      final map = model.toMap();

      expect(map['id'], 'pesanan-002');
      expect(map['user'], 'uid-123'); // field Firestore pakai 'user', bukan 'pemesan'
      expect(map['tanggal'], '2024-07-01');
      expect(map['harga'], '300000');
      expect(map.containsKey('namaUser'), false); // namaUser tidak disimpan ke Firestore
    });
  });

  group('ActiveModel', () {
    test('fromMap() membuat objek dengan benar', () {
      final map = {
        'id': 'active-001',
        'user': 'uid-user-456',
        'doula': 'uid-doula-789',
        'tanggal': '2024-06-20',
        'day': 'Kamis',
        'jam': '14:00',
        'layanan': 'Pendampingan Lahir',
        'harga': 1000000,
      };

      final model = ActiveModel.fromMap(
        map,
        namaUser: 'Ani',
        namaDoula: 'Bidan Sri',
      );

      expect(model.id, 'active-001');
      expect(model.pemesan, 'uid-user-456');
      expect(model.doula, 'uid-doula-789');
      expect(model.harga, '1000000');
      expect(model.namaUser, 'Ani');
      expect(model.namaDoula, 'Bidan Sri');
    });

    test('fromMap() tidak crash ketika semua field null', () {
      final map = <String, dynamic>{};
      final model = ActiveModel.fromMap(map);

      expect(model.id, '');
      expect(model.pemesan, '');
      expect(model.doula, '');
      expect(model.harga, '0');
    });

    test('toMap() menyertakan namaUser dan namaDoula (untuk Firestore)', () {
      final model = ActiveModel(
        id: 'active-002',
        pemesan: 'uid-user',
        doula: 'uid-doula',
        tanggal: '2024-07-10',
        day: 'Rabu',
        jam: '08:00',
        layanan: 'Senam Hamil',
        harga: '200000',
        namaUser: 'Dewi',
        namaDoula: 'Bidan Rina',
      );

      final map = model.toMap();

      expect(map['user'], 'uid-user');
      expect(map['doula'], 'uid-doula');
      expect(map['namaUser'], 'Dewi');
      expect(map['namaDoula'], 'Bidan Rina');
    });
  });
}
