import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';

class DummyData {
  // ============================================================
  // DOULA
  // ============================================================
  static List<DoulaModel> get doulas => [
        DoulaModel(
          uid: 'doula_001',
          image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
          name: 'Bidan Sari Dewi, Amd.Keb',
          job: 'Doula Persalinan & Laktasi',
          alamat: 'Yogyakarta',
          jenisKelamin: 'Perempuan',
          biografi:
              'Bidan berpengalaman 8 tahun dalam pendampingan persalinan normal dan sesar. Spesialis konsultasi laktasi dan senam hamil. Telah membantu lebih dari 200 ibu melahirkan dengan nyaman.',
          rating: '4.9',
        ),
        DoulaModel(
          uid: 'doula_002',
          image: 'https://images.unsplash.com/photo-1594824813571-24a69c100c3b?w=500&auto=format&fit=crop&q=80',
          name: 'Bidan Rini Handayani, Amd.Keb',
          job: 'Doula Prenatal & Postnatal',
          alamat: 'Sleman, Yogyakarta',
          jenisKelamin: 'Perempuan',
          biografi:
              'Spesialis perawatan prenatal dan postnatal selama 6 tahun. Ahli teknik pernapasan untuk persalinan minim rasa sakit. Certified HypnoBirthing Practitioner.',
          rating: '4.8',
        ),
        DoulaModel(
          uid: 'doula_003',
          image: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500&auto=format&fit=crop&q=80',
          name: 'Bidan Maya Kusuma, S.Keb',
          job: 'Doula Air & Waterbirth Specialist',
          alamat: 'Yogyakarta',
          jenisKelamin: 'Perempuan',
          biografi:
              'Spesialis persalinan dalam air (waterbirth). Pengalaman 5 tahun mendampingi persalinan alami. Pernah menangani lebih dari 150 kasus persalinan air yang sukses.',
          rating: '4.7',
        ),
        DoulaModel(
          uid: 'doula_004',
          image: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=500&auto=format&fit=crop&q=80',
          name: 'Bidan Fitri Rahayu, Amd.Keb',
          job: 'Doula VBAC & Konselor Kehamilan',
          alamat: 'Sleman, Yogyakarta',
          jenisKelamin: 'Perempuan',
          biografi:
              'Konselor kehamilan bersertifikat dengan spesialisasi VBAC (Vaginal Birth After Caesarean). Membantu ibu yang ingin melahirkan normal setelah operasi sesar sebelumnya.',
          rating: '4.9',
        ),
      ];

  // ============================================================
  // ARTIKEL
  // ============================================================
  static List<ArtikelModel> get artikels => [
        ArtikelModel(
          title: 'Nutrisi Penting di Trimester Pertama',
          description:
              'Trimester pertama adalah periode kritis perkembangan janin. Asam folat, zat besi, dan kalsium adalah nutrisi utama yang tidak boleh diabaikan...',
          thumbnail: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=80',
          pubDate: '2 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Senam Hamil: Manfaat dan Gerakan Aman',
          description:
              'Olahraga ringan selama kehamilan terbukti mempercepat proses persalinan dan mengurangi komplikasi. Berikut gerakan aman yang bisa dilakukan ibu hamil...',
          thumbnail: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=500&auto=format&fit=crop&q=80',
          pubDate: '5 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Tanda-Tanda Persalinan yang Perlu Diketahui',
          description:
              'Kontraksi teratur, keluar lendir bercampur darah, dan pecah ketuban adalah tanda utama persalinan sudah dimulai. Pelajari cara membedakan kontraksi palsu...',
          thumbnail: 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=500&auto=format&fit=crop&q=80',
          pubDate: '7 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Manfaat ASI Eksklusif untuk Bayi dan Ibu',
          description:
              'ASI mengandung kolostrum yang kaya antibodi. Pemberian ASI eksklusif 6 bulan pertama terbukti meningkatkan kecerdasan bayi dan melindungi dari berbagai penyakit...',
          thumbnail: 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=500&auto=format&fit=crop&q=80',
          pubDate: '8 Juni 2026',
          link: '',
        ),
      ];

  // ============================================================
  // OBAT & SUPLEMEN
  // ============================================================
  static List<ObatModel> get obats => [
        ObatModel(
          nama: 'Elevit Pronatal',
          image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300',
          harga: '185000',
          deskripsi:
              'Suplemen multivitamin lengkap untuk ibu hamil dan menyusui. Mengandung 12 vitamin dan 7 mineral penting termasuk asam folat 800mcg, zat besi 60mg, dan kalsium 125mg.',
          jenis: 'Vitamin',
          noreg: 'BPOM RI DI 1803300943',
          aturan: '1 tablet per hari sesudah makan pagi',
        ),
        ObatModel(
          nama: 'Folamil Genio',
          image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300',
          harga: '95000',
          deskripsi:
              'Suplemen asam folat dan DHA untuk mendukung perkembangan otak dan saraf janin. Sangat dianjurkan sejak trimester pertama kehamilan hingga akhir masa menyusui.',
          jenis: 'Asam Folat',
          noreg: 'BPOM RI DI 1807302876',
          aturan: '1 tablet per hari sesudah makan',
        ),
      ];

  // ============================================================
  // TOKO BAYI (100% TERVERIFIKASI REAL EKSIS DI YOGYAKARTA / SLEMAN)
  // ============================================================
  static List<TokoBayiModel> get tokoBayis => [
        TokoBayiModel(
          nama: 'Baby Zania — Baby Shop & Spa',
          alamat: 'Jl. Laksda Adisucipto No. 169, Ambarukmo, Caturtunggal, Depok, Sleman, Yogyakarta',
          desc:
              'Pusat perlengkapan ibu hamil, menyusui, dan perlengkapan bayi newborn terbesar & terpopuler di Sleman Jogja. Menyediakan stroller, carseat, baju perlengkapan melahirkan, dan perawatan baby spa.',
          rating: '4.8',
          image: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=500&auto=format&fit=crop&q=80',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Clandys Grosir & Eceran Baby Shop',
          alamat: 'Jl. Magelang No. 133, Kricak, Tegalrejo, Kota Yogyakarta',
          desc:
              'Toko perlengkapan bayi dan anak terlengkap di Jogja dengan harga grosir bersahabat. Menyediakan popok, susu, pakaian bayi newborn, dan perlengkapan mandi.',
          rating: '4.7',
          image: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=500&auto=format&fit=crop&q=80',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Wijaya Baby Store (Kaliurang)',
          alamat: 'Jl. Kaliurang Km 5 CT III No. 7, Pogung Kidul, Mlati, Sleman, Yogyakarta',
          desc:
              'Toko perlengkapan bayi dan baju anak berkualitas tinggi di wilayah Kaliurang/Mlati Sleman. Pilihan baju melahirkan dan botol susu lengkap.',
          rating: '4.6',
          image: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=500&auto=format&fit=crop&q=80',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Kin-Kin Baby, Kids & Maternity',
          alamat: 'Jl. Kaliurang Km 5, Barek Gang Kinanthi 4C, Sleman, Yogyakarta',
          desc:
              'Spesialis baju hamil, perlengkapan ibu menyusui, piyama kancing depan, dan perlengkapan perlengkapan bayi newborn terlengkap.',
          rating: '4.8',
          image: 'https://images.unsplash.com/photo-1560506840-ec148e82a604?w=500&auto=format&fit=crop&q=80',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Bunglon Baby Shop',
          alamat: 'Jl. Mawar No. 4, Babadan Baru, Kentungan, Condong Catur, Sleman, Yogyakarta',
          desc:
              'Toko perlengkapan perlengkapan bayi dan stroller lengkap di Condongcatur Sleman dengan pelayanan ramah dan lengkap.',
          rating: '4.7',
          image: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=500&auto=format&fit=crop&q=80',
          product: [],
        ),
      ];
}
