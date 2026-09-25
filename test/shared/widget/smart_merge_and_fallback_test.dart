import 'package:flutter_test/flutter_test.dart';
import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';

void main() {
  group('Fix #23 - Smart Merge Logic Tests', () {
    test('Smart merge Toko Bayi: combines dummy and remote without duplicates', () {
      final remoteData = [
        // Duplicate item (same name, lowercase)
        {
          'nama': 'vinolia baby & kids shop',
          'alamat': 'Jl. Urip Sumoharjo No.35',
          'image': 'https://example.com/vinolia_remote.jpg',
          'rating': '4.9',
          'mapUrl': 'https://maps.google.com',
          'whatsapp': '08123456789',
        },
        // Brand new item
        {
          'nama': 'Toko Bayi Ceria Jogja',
          'alamat': 'Jl. Kaliurang KM 5',
          'image': 'https://example.com/ceria.jpg',
          'rating': '4.8',
          'mapUrl': 'https://maps.google.com',
          'whatsapp': '08987654321',
        },
      ];

      final combined = <TokoBayiModel>[...DummyData.tokoBayis];
      final initialCount = combined.length;

      for (var m in remoteData) {
        final remote = TokoBayiModel.fromMap(m);
        if (!combined.any((existing) => existing.nama.toLowerCase() == remote.nama.toLowerCase())) {
          combined.add(remote);
        }
      }

      // Should only add 1 new item ('Toko Bayi Ceria Jogja')
      expect(combined.length, equals(initialCount + 1));
      expect(combined.any((t) => t.nama == 'Toko Bayi Ceria Jogja'), isTrue);
      // Ensure 'VINOLIA BABY & KIDS SHOP' is still present only once
      expect(combined.where((t) => t.nama.toLowerCase().contains('vinolia')).length, equals(1));
    });

    test('Smart merge Rumah Sakit: combines dummy and remote without duplicates', () {
      final remoteList = [
        // Duplicate item (RSKIA Sadewa)
        RumahSakitModel(
          nama: 'RSKIA SADEWA',
          latitude: -7.7788,
          longitude: 110.4150,
          alamat: 'Alamat Baru',
          layanan: 'Layanan Lengkap',
          rating: '4.8',
          image: 'https://example.com/sadewa_remote.jpg',
          mapUrl: 'https://maps.google.com',
        ),
        // Brand new hospital
        RumahSakitModel(
          nama: 'RS Ibu & Anak Kasih Bunda',
          latitude: -7.7900,
          longitude: 110.4000,
          alamat: 'Jl. Magelang KM 4',
          layanan: 'Persalinan Nyaman 24 Jam',
          rating: '4.9',
          image: 'https://example.com/kasih_bunda.jpg',
          mapUrl: 'https://maps.google.com',
        ),
      ];

      final combined = <RumahSakitModel>[...DummyData.rumahSakitList];
      final initialCount = combined.length;

      for (var r in remoteList) {
        if (!combined.any((existing) => existing.nama.toLowerCase() == r.nama.toLowerCase())) {
          combined.add(r);
        }
      }

      // Should only add 1 new hospital
      expect(combined.length, equals(initialCount + 1));
      expect(combined.any((r) => r.nama == 'RS Ibu & Anak Kasih Bunda'), isTrue);
      // Ensure RSKIA Sadewa is only present once
      expect(combined.where((r) => r.nama.toLowerCase().contains('sadewa')).length, equals(1));
    });
  });

  group('Fix #23 - Hospital Image Local Asset Resolution Tests', () {
    final localAssetMap = {
      'rskia sadewa': 'assets/images/rskia_sadewa.jpg',
      'rskia rachmi': 'assets/images/rskia_rachmi.jpg',
      'rsu sakina idaman': 'assets/images/rsu_sakina_idaman.jpg',
      'rskia permata bunda': 'assets/images/rskia_permata_bunda.jpg',
      'rskia pku muhammadiyah kotagede': 'assets/images/rskia_pku_kotagede.jpg',
      'rsia arvita bunda': 'assets/images/rsia_arvita_bunda.webp',
      'rumah bersalin khadijah': 'assets/images/rumah_bersalin_khadijah.jpg',
      'hermina hospital yogya': 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=600&auto=format&fit=crop&q=80',
      'rumah sakit jih': 'assets/images/rumah_sakit_jih.webp',
      'siloam hospitals yogyakarta': 'assets/images/siloam_hospitals.jpg',
      'rumah sakit bethesda yogyakarta': 'assets/images/rs_bethesda.jpg',
      'rumah sakit panti rapih': 'assets/images/rs_panti_rapih.jpg',
      'rs happy land medical centre': 'assets/images/rs_happy_land.jpg',
      'rsi hidayatullah': 'assets/images/rsi_hidayatullah.jpg',
    };

    String resolveLocalAsset(String nama) {
      final key = nama.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
      if (localAssetMap.containsKey(key)) {
        return localAssetMap[key]!;
      }
      for (var entry in localAssetMap.entries) {
        if (key.contains(entry.key) || entry.key.contains(key)) {
          return entry.value;
        }
      }
      return '';
    }

    test('Resolves exact hospital names correctly', () {
      expect(resolveLocalAsset('RSKIA Sadewa'), equals('assets/images/rskia_sadewa.jpg'));
      expect(resolveLocalAsset('Rumah Sakit JIH'), equals('assets/images/rumah_sakit_jih.webp'));
      expect(resolveLocalAsset('Siloam Hospitals Yogyakarta'), equals('assets/images/siloam_hospitals.jpg'));
    });

    test('Resolves fuzzy/partial hospital names correctly', () {
      // Name with extra prefix/suffix or slightly different wording
      expect(resolveLocalAsset('RSU Sakina Idaman (Ex-RSKIA)'), equals('assets/images/rsu_sakina_idaman.jpg'));
      expect(resolveLocalAsset('RSKIA PKU Muhammadiyah Kotagede'), equals('assets/images/rskia_pku_kotagede.jpg'));
    });

    test('Returns empty string when no local asset matches', () {
      expect(resolveLocalAsset('RS Umum Daerah Tidak Dikenal'), equals(''));
    });
  });
}
