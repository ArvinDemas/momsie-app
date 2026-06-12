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
          image: 'https://i.pravatar.cc/300?img=47',
          name: 'Bidan Sari Dewi, Amd.Keb',
          job: 'Doula Persalinan & Laktasi',
          alamat: 'Jakarta Selatan',
          jenisKelamin: 'Perempuan',
          biografi:
              'Bidan berpengalaman 8 tahun dalam pendampingan persalinan normal dan sesar. Spesialis konsultasi laktasi dan senam hamil. Telah membantu lebih dari 200 ibu melahirkan dengan nyaman.',
          rating: '4.9',
        ),
        DoulaModel(
          uid: 'doula_002',
          image: 'https://i.pravatar.cc/300?img=48',
          name: 'Bidan Rini Handayani, Amd.Keb',
          job: 'Doula Prenatal & Postnatal',
          alamat: 'Bandung',
          jenisKelamin: 'Perempuan',
          biografi:
              'Spesialis perawatan prenatal dan postnatal selama 6 tahun. Ahli teknik pernapasan untuk persalinan minim rasa sakit. Certified HypnoBirthing Practitioner.',
          rating: '4.8',
        ),
        DoulaModel(
          uid: 'doula_003',
          image: 'https://i.pravatar.cc/300?img=49',
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
          image: 'https://i.pravatar.cc/300?img=50',
          name: 'Bidan Fitri Rahayu, Amd.Keb',
          job: 'Doula VBAC & Konselor Kehamilan',
          alamat: 'Surabaya',
          jenisKelamin: 'Perempuan',
          biografi:
              'Konselor kehamilan bersertifikat dengan spesialisasi VBAC (Vaginal Birth After Caesarean). Membantu ibu yang ingin melahirkan normal setelah operasi sesar sebelumnya.',
          rating: '4.9',
        ),
        DoulaModel(
          uid: 'doula_005',
          image: 'https://i.pravatar.cc/300?img=51',
          name: 'Bidan Nurul Hidayah, S.ST',
          job: 'Doula Nutrisi & Gizi Kehamilan',
          alamat: 'Medan',
          jenisKelamin: 'Perempuan',
          biografi:
              'Ahli gizi khusus ibu hamil dengan gelar S.ST Kebidanan. Membantu perencanaan nutrisi optimal selama kehamilan dan menyusui. Pengalaman 7 tahun.',
          rating: '4.8',
        ),
        DoulaModel(
          uid: 'doula_006',
          image: 'https://i.pravatar.cc/300?img=52',
          name: 'Bidan Diah Permata, Amd.Keb',
          job: 'Doula Senam Hamil & Yoga',
          alamat: 'Semarang',
          jenisKelamin: 'Perempuan',
          biografi:
              'Instruktur senam hamil dan prenatal yoga bersertifikat internasional. Membantu ibu menjaga kebugaran dan mempersiapkan tubuh untuk persalinan selama 4 tahun.',
          rating: '4.6',
        ),
        DoulaModel(
          uid: 'doula_007',
          image: 'https://i.pravatar.cc/300?img=53',
          name: 'Bidan Lestari Wulandari, S.Keb',
          job: 'Doula Psikologi Kehamilan',
          alamat: 'Jakarta Pusat',
          jenisKelamin: 'Perempuan',
          biografi:
              'Konselor psikologi kehamilan dan kecemasan persalinan. Berpengalaman menangani baby blues dan persiapan mental ibu hamil. Certified Birth Trauma Specialist.',
          rating: '5.0',
        ),
        DoulaModel(
          uid: 'doula_008',
          image: 'https://i.pravatar.cc/300?img=54',
          name: 'Bidan Anisa Fadilah, Amd.Keb',
          job: 'Doula Pijat Oksitosin & Laktasi',
          alamat: 'Bekasi',
          jenisKelamin: 'Perempuan',
          biografi:
              'Terapis pijat oksitosin untuk memperlancar ASI. Membantu ibu menyusui dengan berbagai teknik yang telah terbukti efektif. Pengalaman 5 tahun.',
          rating: '4.7',
        ),
        DoulaModel(
          uid: 'doula_009',
          image: 'https://i.pravatar.cc/300?img=55',
          name: 'Bidan Wahyu Indah, S.ST',
          job: 'Doula Persalinan Prematur',
          alamat: 'Makassar',
          jenisKelamin: 'Perempuan',
          biografi:
              'Spesialis pendampingan kehamilan risiko tinggi dan persalinan prematur. Berpengalaman di NICU selama 6 tahun sebelum beralih menjadi doula independen.',
          rating: '4.8',
        ),
        DoulaModel(
          uid: 'doula_010',
          image: 'https://i.pravatar.cc/300?img=56',
          name: 'Bidan Retno Ayu, Amd.Keb',
          job: 'Doula Home Birth Specialist',
          alamat: 'Depok',
          jenisKelamin: 'Perempuan',
          biografi:
              'Spesialis persalinan di rumah (home birth) yang aman dan nyaman. Tersertifikasi dalam manajemen darurat obstetri. Sudah mendampingi 80+ persalinan di rumah.',
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
          thumbnail: 'https://picsum.photos/seed/art001/400/250',
          pubDate: '2 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Senam Hamil: Manfaat dan Gerakan Aman',
          description:
              'Olahraga ringan selama kehamilan terbukti mempercepat proses persalinan dan mengurangi komplikasi. Berikut gerakan aman yang bisa dilakukan ibu hamil...',
          thumbnail: 'https://picsum.photos/seed/art002/400/250',
          pubDate: '5 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Tanda-Tanda Persalinan yang Perlu Diketahui',
          description:
              'Kontraksi teratur, keluar lendir bercampur darah, dan pecah ketuban adalah tanda utama persalinan sudah dimulai. Pelajari cara membedakan kontraksi palsu...',
          thumbnail: 'https://picsum.photos/seed/art003/400/250',
          pubDate: '7 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Manfaat ASI Eksklusif untuk Bayi dan Ibu',
          description:
              'ASI mengandung kolostrum yang kaya antibodi. Pemberian ASI eksklusif 6 bulan pertama terbukti meningkatkan kecerdasan bayi dan melindungi dari berbagai penyakit...',
          thumbnail: 'https://picsum.photos/seed/art004/400/250',
          pubDate: '8 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Cara Mengatasi Mual Muntah di Awal Kehamilan',
          description:
              'Morning sickness dialami oleh 70-80% ibu hamil. Ada beberapa cara alami yang efektif untuk mengatasinya: jahe, makan porsi kecil sering, dan menghindari bau menyengat...',
          thumbnail: 'https://picsum.photos/seed/art005/400/250',
          pubDate: '9 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Persiapan Mental Menghadapi Persalinan',
          description:
              'Kecemasan menghadapi persalinan sangat normal. Teknik relaksasi, HypnoBirthing, dan dukungan doula terbukti membantu ibu lebih siap secara mental...',
          thumbnail: 'https://picsum.photos/seed/art006/400/250',
          pubDate: '10 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Perkembangan Janin Minggu ke Minggu',
          description:
              'Dari ukuran biji apel hingga semangka! Pahami tahapan luar biasa perkembangan bayi Anda dari trimester pertama hingga lahir ke dunia...',
          thumbnail: 'https://picsum.photos/seed/art007/400/250',
          pubDate: '11 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Posisi Tidur yang Nyaman untuk Ibu Hamil',
          description:
              'Tidur miring ke kiri adalah posisi terbaik untuk ibu hamil karena melancarkan sirkulasi darah ke janin. Gunakan bantal kehamilan untuk kenyamanan maksimal...',
          thumbnail: 'https://picsum.photos/seed/art008/400/250',
          pubDate: '12 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Vaksinasi yang Diperlukan Selama Kehamilan',
          description:
              'Vaksin Td (Tetanus-Difteri) dan vaksin influenza direkomendasikan selama kehamilan untuk melindungi ibu dan bayi dari infeksi berbahaya...',
          thumbnail: 'https://picsum.photos/seed/art009/400/250',
          pubDate: '13 Juni 2026',
          link: '',
        ),
        ArtikelModel(
          title: 'Tips Menyiapkan Tas Bersalin yang Lengkap',
          description:
              'Tas bersalin sebaiknya sudah disiapkan sejak usia kehamilan 36 minggu. Isi dengan perlengkapan ibu, bayi, dan dokumen penting agar tidak panik saat kontraksi...',
          thumbnail: 'https://picsum.photos/seed/art010/400/250',
          pubDate: '14 Juni 2026',
          link: '',
        ),
      ];

  // ============================================================
  // OBAT & SUPLEMEN
  // ============================================================
  static List<ObatModel> get obats => [
        ObatModel(
          nama: 'Elevit Pronatal',
          image: 'https://picsum.photos/seed/obat001/300/300',
          harga: '185000',
          deskripsi:
              'Suplemen multivitamin lengkap untuk ibu hamil dan menyusui. Mengandung 12 vitamin dan 7 mineral penting termasuk asam folat 800mcg, zat besi 60mg, dan kalsium 125mg.',
          jenis: 'Vitamin',
          noreg: 'BPOM RI DI 1803300943',
          aturan: '1 tablet per hari sesudah makan pagi',
        ),
        ObatModel(
          nama: 'Folamil Genio',
          image: 'https://picsum.photos/seed/obat002/300/300',
          harga: '95000',
          deskripsi:
              'Suplemen asam folat dan DHA untuk mendukung perkembangan otak dan saraf janin. Sangat dianjurkan sejak trimester pertama kehamilan hingga akhir masa menyusui.',
          jenis: 'Asam Folat',
          noreg: 'BPOM RI DI 1807302876',
          aturan: '1 tablet per hari sesudah makan',
        ),
        ObatModel(
          nama: 'Vitonal-F',
          image: 'https://picsum.photos/seed/obat003/300/300',
          harga: '75000',
          deskripsi:
              'Tablet penambah darah (Fe) untuk mencegah anemia pada ibu hamil. Mengandung ferrous fumarate 300mg setara dengan zat besi elemental 100mg.',
          jenis: 'Zat Besi',
          noreg: 'BPOM RI DTL 0128703410A1',
          aturan: '1 tablet per hari, minum dengan air jeruk untuk penyerapan optimal',
        ),
        ObatModel(
          nama: 'Blackmores Pregnancy & Breast-Feeding Gold',
          image: 'https://picsum.photos/seed/obat004/300/300',
          harga: '320000',
          deskripsi:
              'Formula premium dengan omega-3 DHA dari minyak ikan untuk perkembangan otak bayi. Mengandung 60 kapsul dengan formula all-in-one lengkap untuk ibu hamil.',
          jenis: 'Vitamin Premium',
          noreg: 'BPOM RI DI 1904601518',
          aturan: '2 kapsul per hari sesudah makan',
        ),
        ObatModel(
          nama: 'Calcivit-D Ibu Hamil',
          image: 'https://picsum.photos/seed/obat005/300/300',
          harga: '55000',
          deskripsi:
              'Suplemen kalsium dan vitamin D3 untuk pembentukan tulang dan gigi bayi. Membantu mencegah kram kaki yang sering dialami ibu hamil di trimester ketiga.',
          jenis: 'Kalsium',
          noreg: 'BPOM RI DTL 0218700310A1',
          aturan: '1-2 tablet per hari sesudah makan',
        ),
        ObatModel(
          nama: 'Omega-3 Mamivita DHA',
          image: 'https://picsum.photos/seed/obat006/300/300',
          harga: '145000',
          deskripsi:
              'Minyak ikan tinggi DHA khusus ibu hamil. DHA memainkan peran penting dalam perkembangan otak, mata, dan sistem saraf janin selama trimester kedua dan ketiga.',
          jenis: 'DHA Omega-3',
          noreg: 'BPOM RI SI 154523001',
          aturan: '1 kapsul 2x sehari sesudah makan',
        ),
        ObatModel(
          nama: 'Sangobion Ibu Hamil',
          image: 'https://picsum.photos/seed/obat007/300/300',
          harga: '65000',
          deskripsi:
              'Formula khusus dengan zat besi, asam folat, dan vitamin C untuk cegah anemia kehamilan. Formula bebas sembelit sehingga nyaman dikonsumsi setiap hari.',
          jenis: 'Zat Besi + Folat',
          noreg: 'BPOM RI DTL 0331301310A1',
          aturan: '1 kapsul per hari sesudah makan malam',
        ),
        ObatModel(
          nama: 'Vitamin B6 Prenagen',
          image: 'https://picsum.photos/seed/obat008/300/300',
          harga: '42000',
          deskripsi:
              'Suplemen vitamin B6 yang terbukti klinis mengurangi mual dan muntah (morning sickness) pada trimester pertama. Aman dikonsumsi sejak awal kehamilan.',
          jenis: 'Vitamin B6',
          noreg: 'BPOM RI DI 0512300890',
          aturan: '1 tablet 3x sehari atau sesuai anjuran dokter',
        ),
        ObatModel(
          nama: 'Zinc Ibu Hamil NutriMama',
          image: 'https://picsum.photos/seed/obat009/300/300',
          harga: '38000',
          deskripsi:
              'Suplemen zinc untuk mendukung sistem imun ibu dan perkembangan sel janin. Zinc berperan penting dalam sintesis DNA dan pertumbuhan optimal bayi.',
          jenis: 'Zinc/Mineral',
          noreg: 'BPOM RI SI 154390176',
          aturan: '1 tablet per hari sesudah makan',
        ),
        ObatModel(
          nama: 'Magnesium Bumil BioMag',
          image: 'https://picsum.photos/seed/obat010/300/300',
          harga: '89000',
          deskripsi:
              'Suplemen magnesium untuk mencegah kram otot, menjaga tekanan darah normal, dan mendukung perkembangan tulang bayi. Sangat direkomendasikan di trimester ketiga.',
          jenis: 'Magnesium',
          noreg: 'BPOM RI SI 154491023',
          aturan: '1 tablet 2x sehari pagi dan malam sesudah makan',
        ),
      ];

  // ============================================================
  // TOKO BAYI
  // ============================================================
  static List<TokoBayiModel> get tokoBayis => [
        TokoBayiModel(
          nama: 'Mothercare Indonesia',
          alamat: 'Mall Grand Indonesia Lt. 3, Jakarta Pusat',
          desc:
              'Toko perlengkapan bayi dan ibu terpercaya dengan koleksi internasional. Menyediakan stroller, carseat, pakaian bayi, dan aksesori menyusui premium.',
          rating: '4.7',
          image: 'https://picsum.photos/seed/toko001/400/250',
          product: [],
        ),
        TokoBayiModel(
          nama: 'BabyOne Indonesia',
          alamat: 'Lippo Mall Puri, Jakarta Barat',
          desc:
              'Pusat kebutuhan bayi terlengkap dengan harga terjangkau. Tersedia popok, susu formula, mainan edukatif, dan perlengkapan kamar bayi dari berbagai merek ternama.',
          rating: '4.5',
          image: 'https://picsum.photos/seed/toko002/400/250',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Kiddo Store Bandung',
          alamat: 'Paris Van Java Mall, Bandung',
          desc:
              'Spesialis pakaian dan aksesori fashion bayi & anak. Koleksi baju bayi baru lahir hingga usia 5 tahun dengan bahan ramah kulit sensitif bayi.',
          rating: '4.6',
          image: 'https://picsum.photos/seed/toko003/400/250',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Baby Mart Jogja',
          alamat: 'Jl. Magelang No. 147, Yogyakarta',
          desc:
              'Toko bayi kebanggaan warga Jogja. Menyediakan kebutuhan lengkap dari popok, susu, hingga peralatan makan bayi dengan harga bersahabat.',
          rating: '4.8',
          image: 'https://picsum.photos/seed/toko004/400/250',
          product: [],
        ),
        TokoBayiModel(
          nama: 'Little Kingdom Surabaya',
          alamat: 'Tunjungan Plaza Lt. 4, Surabaya',
          desc:
              'Toko bayi premium dengan konsep one-stop shopping. Tersedia layanan konsultasi pemilihan perlengkapan bayi oleh tim ahli kami.',
          rating: '4.9',
          image: 'https://picsum.photos/seed/toko005/400/250',
          product: [],
        ),
      ];
}
