import 'package:douce/shared/database/local_db_service.dart';
import 'package:get/get.dart';

class BabyNameItem {
  final int pk;
  final String lang;
  final String boy;
  final String girl;
  BabyNameItem({
    required this.pk,
    required this.lang,
    required this.boy,
    required this.girl,
  });
}

class BabyNamesController extends GetxController {
  final RxList<BabyNameItem> allNames = <BabyNameItem>[].obs;
  final RxList<BabyNameItem> filtered = <BabyNameItem>[].obs;
  final RxBool isLoading = true.obs;

  // Filter state
  final RxString searchQuery = ''.obs;
  final RxString selectedGender = 'Semua'.obs; // 'Semua', 'Laki-laki', 'Perempuan'
  final RxString selectedLang = 'Indonesian'.obs;

  // Available languages (subset that makes sense for Indonesian users)
  final List<String> languages = [
    'Indonesian',
    'Muslim',
    'English',
    'American',
    'Japanese',
    'French',
    'Korean',
    'Indian',
    'Arabic',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadNames();
  }

  Future<void> _loadNames() async {
    isLoading.value = true;
    final db = await LocalDbService.database;
    // Ambil semua bahasa yang relevan sekaligus
    final rows = await db.query(
      'names',
      where: 'lang IN (${languages.map((_) => '?').join(',')})',
      whereArgs: languages,
      orderBy: 'lang, seq',
    );

    final items = rows.map((r) => BabyNameItem(
          pk: r['pk'] as int,
          lang: r['lang'] as String,
          boy: r['boy'] as String? ?? '',
          girl: r['girl'] as String? ?? '',
        )).toList();

    allNames.assignAll(items);
    _applyFilter();
    isLoading.value = false;
  }

  void _applyFilter() {
    final q = searchQuery.value.toLowerCase();
    filtered.value = allNames.where((n) {
      // Language filter
      if (n.lang != selectedLang.value) return false;

      // Gender filter: hide empty names
      if (selectedGender.value == 'Laki-laki' && n.boy.isEmpty) return false;
      if (selectedGender.value == 'Perempuan' && n.girl.isEmpty) return false;

      // Search
      if (q.isNotEmpty) {
        final boyMatch = n.boy.toLowerCase().contains(q);
        final girlMatch = n.girl.toLowerCase().contains(q);
        return boyMatch || girlMatch;
      }
      return true;
    }).toList();
  }

  void onSearch(String q) {
    searchQuery.value = q;
    _applyFilter();
  }

  void onGenderChanged(String gender) {
    selectedGender.value = gender;
    _applyFilter();
  }

  void onLangChanged(String lang) {
    selectedLang.value = lang;
    _applyFilter();
  }
}
