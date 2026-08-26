import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFeature {
  final String title;
  final String category;
  final IconData icon;
  final String route;
  final String description;

  AppFeature({
    required this.title,
    required this.category,
    required this.icon,
    required this.route,
    required this.description,
  });
}

class FeatureSearchModal extends StatefulWidget {
  final String initialQuery;
  const FeatureSearchModal({super.key, this.initialQuery = ''});

  static Future<void> show(BuildContext context, {String initialQuery = ''}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeatureSearchModal(initialQuery: initialQuery),
    );
  }

  @override
  State<FeatureSearchModal> createState() => _FeatureSearchModalState();
}

class _FeatureSearchModalState extends State<FeatureSearchModal> {
  late final TextEditingController _searchCtrl;
  String _query = '';

  final List<AppFeature> _allFeatures = [
    AppFeature(
      title: 'Perkembangan Janin (Size Guide)',
      category: 'Fitur Utama',
      icon: Icons.child_care_rounded,
      route: '/size-guide',
      description: 'Pantau estimasi ukuran & pertumbuhan janin minggu ini',
    ),
    AppFeature(
      title: 'Diary Kehamilan & Album PDF',
      category: 'Fitur Utama',
      icon: Icons.menu_book_rounded,
      route: '/diary-list',
      description: 'Catat momen kehamilan dan cetak album kenangan PDF',
    ),
    AppFeature(
      title: 'Booking Doula & Bidan',
      category: 'Kesehatan',
      icon: Icons.support_agent_rounded,
      route: '/booking-doula',
      description: 'Jadwalkan pendampingan persalinan & laktasi online/offline',
    ),
    AppFeature(
      title: 'Hospital Bag & Birth Plan',
      category: 'Persiapan',
      icon: Icons.local_hospital_rounded,
      route: '/birth-plan',
      description: 'Checklist perlengkapan bersalin ke rumah sakit & rencana persalinan',
    ),
    AppFeature(
      title: 'Kamus Nama Bayi (Islami & Modern)',
      category: 'Fitur Utama',
      icon: Icons.font_download_rounded,
      route: '/baby-names',
      description: 'Cari rekomendasi nama bayi beserta artinya',
    ),
    AppFeature(
      title: 'Rumah Sakit & Klinik Terdekat',
      category: 'Kesehatan',
      icon: Icons.local_hospital_outlined,
      route: '/see-more',
      description: 'Daftar rumah sakit bersalin dan faskes terdekat',
    ),
    AppFeature(
      title: 'Apotek & Obat Aman Bumil',
      category: 'Kesehatan',
      icon: Icons.medication_rounded,
      route: '/user-kesehatan',
      description: 'Cari obat dan vitamin kehamilan terverifikasi',
    ),
    AppFeature(
      title: 'Yoga & Senam Hamil',
      category: 'Edukasi',
      icon: Icons.fitness_center_rounded,
      route: '/user-edukasi',
      description: 'Panduan gerakan yoga trimester 1, 2, dan 3',
    ),
    AppFeature(
      title: 'Artikel Edukasi & Tips Kesehatan',
      category: 'Edukasi',
      icon: Icons.article_rounded,
      route: '/see-more',
      description: 'Kumpulan artikel medis kehamilan dan menyusui',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchCtrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AppFeature> get _filteredFeatures {
    if (_query.trim().isEmpty) return _allFeatures;
    final q = _query.toLowerCase();
    return _allFeatures.where((f) {
      return f.title.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q) ||
          f.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFeatures;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      autofocus: true,
                      onChanged: (val) => setState(() => _query = val),
                      decoration: InputDecoration(
                        hintText: 'Cari fitur, menu, atau layanan...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded, color: ColorDouce.douceBase),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Results list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'Fitur "$_query" tidak ditemukan',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (item.route == '/see-more') {
                            Get.toNamed(item.route, arguments: {'title': item.category});
                          } else {
                            Get.toNamed(item.route);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: ColorDouce.douceBase.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item.icon, color: ColorDouce.douceBase, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
