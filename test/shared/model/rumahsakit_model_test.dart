// test/shared/model/rumahsakit_model_test.dart
//
// Unit test untuk RumahSakitModel.
// Jalankan dengan: flutter test test/shared/model/rumahsakit_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';

void main() {
  group('RumahSakitModel', () {
    test('fromMap() mengkonversi latitude/longitude String ke double', () {
      final map = {
        'nama': 'RS Ibu dan Anak',
        'latitude': '-6.2088',
        'longitude': '106.8456',
        'alamat': 'Jl. Sudirman No. 1',
        'layanan': 'IGD, Persalinan',
        'rating': '4.7',
        'image': 'https://example.com/rs.jpg',
      };

      final model = RumahSakitModel.fromMap(map);

      expect(model.nama, 'RS Ibu dan Anak');
      expect(model.latitude, -6.2088);
      expect(model.longitude, 106.8456);
      expect(model.rating, '4.7');
    });

    test('fromMap() tidak crash ketika latitude/longitude bukan angka valid',
        () {
      final map = {
        'latitude': 'invalid',
        'longitude': null,
      };

      final model = RumahSakitModel.fromMap(map);

      expect(model.latitude, 0.0);   // fallback ke 0.0, tidak crash
      expect(model.longitude, 0.0);
    });

    test('fromMap() tidak crash ketika semua field null', () {
      final map = <String, dynamic>{};
      final model = RumahSakitModel.fromMap(map);

      expect(model.nama, '');
      expect(model.latitude, 0.0);
      expect(model.longitude, 0.0);
      expect(model.alamat, '');
    });

    test('toMap() menghasilkan Map dengan latitude/longitude sebagai String',
        () {
      final model = RumahSakitModel(
        nama: 'RS Bunda',
        latitude: -6.9,
        longitude: 107.6,
        alamat: 'Bandung',
        layanan: 'Persalinan',
        rating: '4.5',
        image: 'image.jpg',
      );

      final map = model.toMap();

      expect(map['latitude'], '-6.9');
      expect(map['longitude'], '107.6');
      expect(map['nama'], 'RS Bunda');
    });
  });
}
