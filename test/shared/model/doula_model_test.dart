// test/shared/model/doula_model_test.dart
//
// Unit test untuk DoulaModel.
// Jalankan dengan: flutter test test/shared/model/doula_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:douce/shared/util/model/doula_model.dart';

void main() {
  group('DoulaModel', () {
    test('fromMap() membuat objek dengan benar dari data Firestore', () {
      final map = {
        'image': 'https://example.com/foto.jpg',
        'name': 'Sri Wahyuni',
        'pekerjaan': 'Bidan',
        'alamat': 'Jl. Kenanga No. 5',
        'jenisKelamin': 'Perempuan',
        'biografi': 'Bidan berpengalaman 10 tahun',
        'rating': 4.8,
      };

      final model = DoulaModel.fromMap(map, uid: 'doula-uid-001');

      expect(model.uid, 'doula-uid-001');
      expect(model.name, 'Sri Wahyuni');
      expect(model.job, 'Bidan');         // field Dart 'job' ← Firestore 'pekerjaan'
      expect(model.rating, '4.8');
      expect(model.image, 'https://example.com/foto.jpg');
    });

    test('fromMap() tidak crash ketika field Firestore null', () {
      final map = <String, dynamic>{};
      final model = DoulaModel.fromMap(map);

      expect(model.uid, '');
      expect(model.name, '');
      expect(model.job, '');
      expect(model.rating, '0');
    });

    test('toMap() memetakan field Dart ke field Firestore dengan benar', () {
      final model = DoulaModel(
        uid: 'doula-uid-002',
        image: 'foto.jpg',
        name: 'Rina',
        job: 'Doula',
        alamat: 'Jakarta',
        jenisKelamin: 'Perempuan',
        biografi: 'Berpengalaman',
        rating: '4.5',
      );

      final map = model.toMap();

      expect(map['name'], 'Rina');
      expect(map['pekerjaan'], 'Doula'); // 'job' disimpan sebagai 'pekerjaan'
      expect(map.containsKey('uid'), false); // uid tidak disimpan di dalam dokumen
    });
  });
}
