import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostpartumWellbeingPage extends StatefulWidget {
  const PostpartumWellbeingPage({super.key});

  @override
  State<PostpartumWellbeingPage> createState() => _PostpartumWellbeingPageState();
}

class _PostpartumWellbeingPageState extends State<PostpartumWellbeingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Header Checklist State
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaBayiController = TextEditingController();
  final TextEditingController _hariPostpartumController = TextEditingController(text: '7');
  String _jenisPersalinan = 'Vaginal';
  String _lokasiKunjungan = 'Rumah';

  // Section A: Kondisi Fisik Ibu
  final Map<String, bool> _fisikCheck = {
    'perdarahan_normal': true,
    'nyeri_terkendali': true,
    'jahitan_kering_bersih': true,
    'bebas_demam': true,
    'bak_bab_lancar': true,
    'payudara_lembut_nyaman': true,
    'bebas_pusing_lemas': true,
  };

  // Section B: Pemulihan & Istirahat
  double _skalaKelelahan = 4.0;
  final TextEditingController _jamTidurController = TextEditingController(text: '6');
  final Map<String, bool> _pemulihanCheck = {
    'makan_cukup_teratur': true,
    'minum_air_cukup': true,
    'ada_yang_membantu': true,
  };

  // Section C: Kondisi Emosional & Bonding
  final Map<String, bool> _emosiCheck = {
    'perasaan_stabil': true,
    'mudah_terhubung_bayi': true,
    'didukung_pasangan_keluarga': true,
    'merasa_aman_di_rumah': true,
    'tidak_merasa_sendirian': true,
  };

  // Section D: Menyusui / Pemberian ASI
  final TextEditingController _frekuensiMenyusuController = TextEditingController(text: '8');
  final Map<String, bool> _laktasiCheck = {
    'pelekatan_latch_baik': true,
    'puting_bebas_lecet': true,
    'produksi_asi_cukup': true,
    'bayi_tampak_puas': true,
    'bebas_benjolan_radang': true,
  };

  // Section E: Kondisi Bayi
  final TextEditingController _bakBayiController = TextEditingController(text: '6');
  final TextEditingController _babBayiController = TextEditingController(text: '3');
  final Map<String, bool> _bayiCheck = {
    'menyusu_aktif': true,
    'bayi_responsif': true,
    'napas_teratur_tenang': true,
    'suhu_tubuh_hangat_normal': true,
    'kulit_bebas_kuning_berat': true,
    'tali_pusat_bersih_kering': true,
    'sudah_periksa_nakes': true,
  };

  // Section F & G: Lingkungan & Keluarga
  final Map<String, bool> _lingkunganCheck = {
    'tidur_bayi_aman': true,
    'masih_skin_to_skin': true,
    'tangan_bersih_sebelum_pegang': true,
    'pembagian_tugas_pasangan_jelas': true,
    'bebas_tekanan_keluarga': true,
  };

  // Red Flags
  final Map<String, bool> _redFlagsIbu = {
    'perdarahan_hebat_bergumpal': false,
    'demam_tinggi_menggigil': false,
    'nyeri_hebat_memburuk': false,
    'sesak_pingsan_pusing_berat': false,
    'luka_terinfeksi_bercairan': false,
    'depresi_berat_menyakiti': false,
  };

  final Map<String, bool> _redFlagsBayi = {
    'bayi_tidak_mau_menyusu': false,
    'napas_cepat_sesak_merintih': false,
    'kejang': false,
    'bayi_sangat_lemas_letargis': false,
    'demam_atau_hipotermia': false,
    'kuning_pekat_meluas': false,
    'tali_pusat_bernanah_bau': false,
  };

  // Status Akhir
  String _statusKesimpulan = 'AMAN';
  final TextEditingController _catatanTambahanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedChecklist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _namaIbuController.dispose();
    _namaBayiController.dispose();
    _hariPostpartumController.dispose();
    _jamTidurController.dispose();
    _frekuensiMenyusuController.dispose();
    _bakBayiController.dispose();
    _babBayiController.dispose();
    _catatanTambahanController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaIbuController.text = prefs.getString('postpartum_nama_ibu') ?? 'Bunda Sarah';
      _namaBayiController.text = prefs.getString('postpartum_nama_bayi') ?? 'Baby Kalandra';
      _hariPostpartumController.text = prefs.getString('postpartum_hari') ?? '7';
      _statusKesimpulan = prefs.getString('postpartum_status') ?? 'AMAN';
    });
  }

  Future<void> _saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('postpartum_nama_ibu', _namaIbuController.text.trim());
    await prefs.setString('postpartum_nama_bayi', _namaBayiController.text.trim());
    await prefs.setString('postpartum_hari', _hariPostpartumController.text.trim());
    await prefs.setString('postpartum_status', _statusKesimpulan);

    Get.snackbar(
      'Tersimpan Berhasil',
      'Lembar Postpartum Wellbeing Check berhasil diperbarui.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,

      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _recalculateStatus() {
    final hasRedFlagIbu = _redFlagsIbu.values.any((v) => v);
    final hasRedFlagBayi = _redFlagsBayi.values.any((v) => v);

    if (hasRedFlagIbu || hasRedFlagBayi) {
      _statusKesimpulan = 'PERLU RUJUKAN';
    } else if (_skalaKelelahan >= 8 ||
        _fisikCheck.values.where((v) => !v).length >= 2 ||
        _bayiCheck.values.where((v) => !v).length >= 2) {
      _statusKesimpulan = 'PERLU DIPANTAU';
    } else {
      _statusKesimpulan = 'AMAN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FA),
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Postpartum Wellbeing',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textDark,
                              ),
                            ),
                            Text(
                              'Standar Evaluasi Nifas Rumah Gentle Birth',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B8B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.workspace_premium_rounded, size: 14, color: Color(0xFFFF6B8B)),
                            SizedBox(width: 4),
                            Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B8B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppElevation.level1,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: ColorDouce.douceBase,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppSemanticColors.textMuted,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Modul Edukasi'),
                      Tab(text: 'Checklist Kunjungan'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildModulEdukasiTab(),
                      _buildChecklistTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: MODUL EDUKASI
  Widget _buildModulEdukasiTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header Hero Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppElevation.softColor(const Color(0xFFEC4899)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat atas Kelahiran Buah Hati!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fokus pada pemulihan fisik, nutrisi ASI, dan ketenangan jiwa selama masa nifas.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Modul Pemulihan Pasca Melahirkan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppSemanticColors.textDark,
          ),
        ),
        const SizedBox(height: 12),

        _buildModuleCard(
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF06B6D4),
          title: 'Senam Nifas & Pemulihan Otot Panggul',
          desc: 'Panduan gerakan aman mempercepat pemulihan rahim dan otot panggul Kegel pasca persalinan.',
        ),
        _buildModuleCard(
          icon: Icons.psychology_rounded,
          color: const Color(0xFFA855F7),
          title: 'Pencegahan Baby Blues & Mood Tracker',
          desc: 'Edukasi mengenali perubahan emosi, mengatasi kelelahan, dan membangun dukungan keluarga.',
        ),
        _buildModuleCard(
          icon: Icons.water_drop_rounded,
          color: const Color(0xFF10B981),
          title: 'Panduan Laktasi & Pijat Oksitosin',
          desc: 'Teknik pelekatan latching yang nyaman, posisi menyusui, dan stimulasi pengeluaran ASI.',
        ),
        _buildModuleCard(
          icon: Icons.medical_information_rounded,
          color: const Color(0xFFF59E0B),
          title: 'Perawatan Perineum & Jahitan Caesar',
          desc: 'Tata cara menjaga kebersihan luka operasi dan jahitan perineum agar terhindar dari infeksi.',
        ),
      ],
    );
  }

  // TAB 2: CHECKLIST DIGITAL SESUAI DOKUMEN RUMAH GENTLE BIRTH
  Widget _buildChecklistTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Summary Status Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _statusKesimpulan == 'AMAN'
                ? Colors.green.shade50
                : _statusKesimpulan == 'PERLU DIPANTAU'
                    ? Colors.amber.shade50
                    : Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _statusKesimpulan == 'AMAN'
                  ? Colors.green.shade300
                  : _statusKesimpulan == 'PERLU DIPANTAU'
                      ? Colors.amber.shade300
                      : Colors.red.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _statusKesimpulan == 'AMAN'
                    ? Icons.check_circle_rounded
                    : _statusKesimpulan == 'PERLU DIPANTAU'
                        ? Icons.warning_rounded
                        : Icons.error_rounded,
                color: _statusKesimpulan == 'AMAN'
                    ? Colors.green.shade700
                    : _statusKesimpulan == 'PERLU DIPANTAU'
                        ? Colors.amber.shade800
                        : Colors.red.shade700,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Kunjungan: $_statusKesimpulan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _statusKesimpulan == 'AMAN'
                            ? Colors.green.shade900
                            : _statusKesimpulan == 'PERLU DIPANTAU'
                                ? Colors.amber.shade900
                                : Colors.red.shade900,
                      ),
                    ),

                    const SizedBox(height: 2),
                    Text(
                      _statusKesimpulan == 'AMAN'
                          ? 'Seluruh parameter berada dalam batas normal dan pemulihan berjalan baik.'
                          : _statusKesimpulan == 'PERLU DIPANTAU'
                              ? 'Terdapat poin yang membutuhkan perhatian khusus dalam 24-48 jam ke depan.'
                              : 'Ditemukan tanda bahaya. Segera hubungi dokter spesialis atau fasilitas kesehatan.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Identitas Kunjungan
        _buildSectionCard(
          title: 'Identitas Kunjungan Pasca Persalinan',
          icon: Icons.badge_outlined,
          color: const Color(0xFF6366F1),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _namaIbuController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Ibu',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _namaBayiController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Bayi',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hariPostpartumController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hari Postpartum Ke-',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _jenisPersalinan,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Persalinan',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Vaginal', child: Text('Vaginal Normal', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'SC', child: Text('Operasi Caesar (SC)', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya', style: TextStyle(fontSize: 13))),
                    ],
                    onChanged: (val) => setState(() => _jenisPersalinan = val ?? 'Vaginal'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _lokasiKunjungan,
              decoration: const InputDecoration(
                labelText: 'Lokasi Kunjungan',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              items: const [
                DropdownMenuItem(value: 'Rumah', child: Text('Kunjungan ke Rumah (Home Visit)', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Online', child: Text('Konsultasi Online / Virtual', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Klinik', child: Text('Klinik / Fasilitas Kesehatan', style: TextStyle(fontSize: 13))),
              ],
              onChanged: (val) => setState(() => _lokasiKunjungan = val ?? 'Rumah'),
            ),
          ],
        ),


        const SizedBox(height: 16),

        // Bagian A: Kondisi Fisik Ibu
        _buildSectionCard(
          title: 'A. Kondisi Fisik Ibu',
          icon: Icons.health_and_safety_outlined,
          color: const Color(0xFFEC4899),
          children: [
            _buildCheckTile('Jumlah darah nifas normal tanpa gumpalan besar berulang', 'perdarahan_normal', _fisikCheck),
            _buildCheckTile('Tingkat nyeri perineum atau perut dalam batas terkendali', 'nyeri_terkendali', _fisikCheck),
            _buildCheckTile('Luka jahitan bersih, kering, tanpa bau tidak biasa atau nanah', 'jahitan_kering_bersih', _fisikCheck),
            _buildCheckTile('Bebas demam, tidak menggigil atau meriang', 'bebas_demam', _fisikCheck),
            _buildCheckTile('Buang air kecil dan besar nyaman tanpa rasa sakit hebat', 'bak_bab_lancar', _fisikCheck),
            _buildCheckTile('Payudara lembut dan tidak ada area mengeras merah panas', 'payudara_lembut_nyaman', _fisikCheck),
            _buildCheckTile('Bebas dari pusing berputar, lemas ekstrem, atau sesak napas', 'bebas_pusing_lemas', _fisikCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian B: Pemulihan & Istirahat
        _buildSectionCard(
          title: 'B. Pemulihan, Istirahat & Nutrisi',
          icon: Icons.hotel_outlined,
          color: const Color(0xFF06B6D4),
          children: [
            Row(
              children: [
                const Text('Skala Kelelahan Ibu: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${_skalaKelelahan.toInt()} / 10', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _skalaKelelahan >= 7 ? Colors.red : Colors.pink)),
              ],
            ),
            Slider(
              value: _skalaKelelahan,
              min: 0,
              max: 10,
              divisions: 10,
              activeColor: _skalaKelelahan >= 7 ? Colors.red : ColorDouce.douceBase,
              label: '${_skalaKelelahan.toInt()}',
              onChanged: (val) {
                setState(() {
                  _skalaKelelahan = val;
                  _recalculateStatus();
                });
              },
            ),
            _buildCheckTile('Makan teratur dengan asupan bergizi seimbang', 'makan_cukup_teratur', _pemulihanCheck),
            _buildCheckTile('Minum air putih cukup minimal dua hingga tiga liter sehari', 'minum_air_cukup', _pemulihanCheck),
            _buildCheckTile('Ada anggota keluarga atau pendamping yang aktif membantu', 'ada_yang_membantu', _pemulihanCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian C: Emosional & Bonding
        _buildSectionCard(
          title: 'C. Kondisi Emosional & Ikatan Batin',
          icon: Icons.sentiment_satisfied_alt_outlined,
          color: const Color(0xFFA855F7),
          children: [
            _buildCheckTile('Perasaan tenang dan stabil tanpa kecemasan berlebihan', 'perasaan_stabil', _emosiCheck),
            _buildCheckTile('Mudah merasa terhubung dan penuh kasih saat bersama bayi', 'mudah_terhubung_bayi', _emosiCheck),
            _buildCheckTile('Merasa didengar dan didukung penuh oleh pasangan serta keluarga', 'didukung_pasangan_keluarga', _emosiCheck),
            _buildCheckTile('Merasa aman dan diperlakukan dengan baik di lingkungan rumah', 'merasa_aman_di_rumah', _emosiCheck),
            _buildCheckTile('Tidak merasa terisolasi atau harus menanggung segalanya sendirian', 'tidak_merasa_sendirian', _emosiCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian D: Menyusui / ASI
        _buildSectionCard(
          title: 'D. Menyusui & Pemberian ASI',
          icon: Icons.water_drop_outlined,
          color: const Color(0xFF10B981),
          children: [
            _buildCheckTile('Pelekatan mulut bayi pada payudara latching sudah dalam dan benar', 'pelekatan_latch_baik', _laktasiCheck),
            _buildCheckTile('Puting susu nyaman tanpa lecet berdarah', 'puting_bebas_lecet', _laktasiCheck),
            _buildCheckTile('Produksi ASI mencukupi kebutuhan harian bayi', 'produksi_asi_cukup', _laktasiCheck),
            _buildCheckTile('Bayi tampak rileks dan puas setelah sesi menyusui selesai', 'bayi_tampak_puas', _laktasiCheck),
            _buildCheckTile('Payudara tidak bengkak mastitis atau tersumbat saluran ASI', 'bebas_benjolan_radang', _laktasiCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian E: Kondisi Bayi
        _buildSectionCard(
          title: 'E. Kondisi Kesehatan Bayi',
          icon: Icons.child_care_outlined,
          color: const Color(0xFFF59E0B),
          children: [
            _buildCheckTile('Bayi menyusu secara aktif minimal delapan kali sehari', 'menyusu_aktif', _bayiCheck),
            _buildCheckTile('Bayi aktif bergerak saat bangun dan tidak letargis lemas', 'bayi_responsif', _bayiCheck),
            _buildCheckTile('Pernapasan bayi tenang dan tidak sesak atau berbunyi grok berat', 'napas_teratur_tenang', _bayiCheck),
            _buildCheckTile('Suhu tubuh bayi stabil hangat di kisaran tiga puluh tujuh derajat', 'suhu_tubuh_hangat_normal', _bayiCheck),
            _buildCheckTile('Kulit dan mata tidak tampak kuning pekat meluas ke dada atau perut', 'kulit_bebas_kuning_berat', _bayiCheck),
            _buildCheckTile('Pangkal tali pusat bersih kering dan tidak berbau atau berair', 'tali_pusat_bersih_kering', _bayiCheck),
            _buildCheckTile('Sudah mendapat pemeriksaan neonatal atau imunisasi dari nakes', 'sudah_periksa_nakes', _bayiCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian F & G: Perawatan & Keluarga
        _buildSectionCard(
          title: 'F & G. Lingkungan Aman & Dukungan Pasangan',
          icon: Icons.family_restroom_outlined,
          color: const Color(0xFF3B82F6),
          children: [
            _buildCheckTile('Bayi tidur di tempat tidur datar tanpa bantal tebal atau boneka', 'tidur_bayi_aman', _lingkunganCheck),
            _buildCheckTile('Ibu dan bayi masih rutin melakukan kontak kulit ke kulit skin-to-skin', 'masih_skin_to_skin', _lingkunganCheck),
            _buildCheckTile('Seluruh keluarga mencuci tangan dengan sabun sebelum menyentuh bayi', 'tangan_bersih_sebelum_pegang', _lingkunganCheck),
            _buildCheckTile('Pasangan berbagi peran secara aktif dalam merawat bayi dan rumah', 'pembagian_tugas_pasangan_jelas', _lingkunganCheck),
            _buildCheckTile('Suasana rumah kondusif tanpa tekanan tuntutan berlebih', 'bebas_tekanan_keluarga', _lingkunganCheck),
          ],
        ),

        const SizedBox(height: 16),

        // Bagian Merah: RED FLAG / TANDA BAHAYA
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade300, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'RED FLAG: Tanda Bahaya (Segera ke Faskes)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Bila tercentang salah satu saja di bawah ini, segera hubungi dokter atau fasilitas kesehatan.',
                style: TextStyle(fontSize: 11.5, color: Colors.black87),
              ),
              const Divider(height: 20),
              const Text('Tanda Bahaya Ibu:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.red)),
              _buildRedFlagTile('Perdarahan nifas membanjiri lebih dari dua pembalut per jam', 'perdarahan_hebat_bergumpal', _redFlagsIbu),
              _buildRedFlagTile('Demam tinggi lebih dari 38 derajat celsius atau menggigil hebat', 'demam_tinggi_menggigil', _redFlagsIbu),
              _buildRedFlagTile('Nyeri perut atau kepala berat tak tertahankan disertai pandangan kabur', 'sesak_pingsan_pusing_berat', _redFlagsIbu),
              _buildRedFlagTile('Luka jahitan mengeluarkan cairan keruh, bernanah, atau terbuka', 'luka_terinfeksi_bercairan', _redFlagsIbu),
              _buildRedFlagTile('Kondisi depresi berat atau muncul dorongan menyakiti diri atau bayi', 'depresi_berat_menyakiti', _redFlagsIbu),

              const SizedBox(height: 8),
              const Text('Tanda Bahaya Bayi:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.red)),
              _buildRedFlagTile('Bayi menolak menyusu sama sekali atau muntah terus menerus', 'bayi_tidak_mau_menyusu', _redFlagsBayi),
              _buildRedFlagTile('Napas sangat cepat lebih dari enam puluh kali per menit atau merintih', 'napas_cepat_sesak_merintih', _redFlagsBayi),
              _buildRedFlagTile('Bayi kejang atau mata mendelik ke atas', 'kejang', _redFlagsBayi),
              _buildRedFlagTile('Bayi sangat lemas, tidak menangis, atau sulit dibangunkan', 'bayi_sangat_lemas_letargis', _redFlagsBayi),
              _buildRedFlagTile('Suhu tubuh bayi sangat tinggi atau dingin di bawah tiga puluh enam derajat', 'demam_atau_hipotermia', _redFlagsBayi),
              _buildRedFlagTile('Kuning pekat mencapai telapak tangan atau telapak kaki', 'kuning_pekat_meluas', _redFlagsBayi),
              _buildRedFlagTile('Tali pusat merah bengkak bernanah atau berbau busuk tajam', 'tali_pusat_bernanah_bau', _redFlagsBayi),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Catatan Tindak Lanjut
        _buildSectionCard(
          title: 'Catatan & Rencana Tindak Lanjut',
          icon: Icons.note_alt_outlined,
          color: const Color(0xFF64748B),
          children: [
            TextField(
              controller: _catatanTambahanController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tuliskan catatan pendampingan doula atau rekomendasi khusus untuk keluarga di sini...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Tombol Simpan
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _saveChecklist,
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            label: const Text(
              'Simpan Lembar Evaluasi',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppElevation.level1,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppSemanticColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCheckTile(String label, String key, Map<String, bool> map) {
    final isChecked = map[key] ?? false;
    return InkWell(
      onTap: () {
        setState(() {
          map[key] = !isChecked;
          _recalculateStatus();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: isChecked ? ColorDouce.douceBase : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isChecked ? AppSemanticColors.textDark : AppSemanticColors.textMuted,
                  fontWeight: isChecked ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedFlagTile(String label, String key, Map<String, bool> map) {
    final isFlagged = map[key] ?? false;
    return InkWell(
      onTap: () {
        setState(() {
          map[key] = !isFlagged;
          _recalculateStatus();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(
              isFlagged ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: isFlagged ? Colors.red.shade700 : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isFlagged ? Colors.red.shade800 : Colors.black87,
                  fontWeight: isFlagged ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppElevation.level1,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppSemanticColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppSemanticColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
