import 'package:douce/shared/database/local_db_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistItem {
  final int pk;
  final String category;
  final String detail;
  bool isDone;

  ChecklistItem({
    required this.pk,
    required this.category,
    required this.detail,
    this.isDone = false,
  });
}

class ChecklistController extends GetxController {
  final RxList<ChecklistItem> items = <ChecklistItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'mum'.obs;

  // Kategori yang tersedia (Clean tanpa emoji)
  final List<String> categories = ['mum', 'partner', 'baby'];
  final Map<String, String> categoryLabels = {
    'mum': 'Untuk Ibu',
    'partner': 'Untuk Pendamping',
    'baby': 'Untuk Bayi',
  };

  List<ChecklistItem> get filteredItems =>
      items.where((i) => i.category == selectedCategory.value).toList();

  int get totalDone => items.where((i) => i.isDone).length;
  int get totalItems => items.length;
  double get progress =>
      totalItems == 0 ? 0 : totalDone / totalItems;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  Future<void> _loadItems() async {
    isLoading.value = true;
    try {
      final db = await LocalDbService.database;
      final rows = await db.query('hospitalbag', orderBy: 'category, pk');

      final prefs = await SharedPreferences.getInstance();

      if (rows.isNotEmpty) {
        final List<ChecklistItem> loaded = rows.map((row) {
          final pk = row['pk'] as int;
          final isDone = prefs.getBool('checklist_$pk') ?? false;
          return ChecklistItem(
            pk: pk,
            category: row['category'] as String,
            detail: row['detail'] as String,
            isDone: isDone,
          );
        }).toList();
        items.assignAll(loaded);
      } else {
        // Fallback item komprehensif jika DB lokal belum terisi
        final List<ChecklistItem> fallback = _getFallbackItems(prefs);
        items.assignAll(fallback);
      }
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      items.assignAll(_getFallbackItems(prefs));
    } finally {
      isLoading.value = false;
    }
  }

  List<ChecklistItem> _getFallbackItems(SharedPreferences prefs) {
    final raw = [
      // IBU
      {'pk': 1, 'category': 'mum', 'detail': 'Dokumen Penting (KTP, BPJS, Buku KIA, Hasil USG)'},
      {'pk': 2, 'category': 'mum', 'detail': 'Baju Atasan Kancing Depan (2-3 pcs)'},
      {'pk': 3, 'category': 'mum', 'detail': 'Pembalut Nifas Jumbo / Adult Diaper'},
      {'pk': 4, 'category': 'mum', 'detail': 'Bra Menyusui & Breast Pad'},
      {'pk': 5, 'category': 'mum', 'detail': 'Sarung / Kain Batik (2-3 lembar)'},
      {'pk': 6, 'category': 'mum', 'detail': 'Perlengkapan Mandi & Skincare Ibu'},
      {'pk': 7, 'category': 'mum', 'detail': 'Sandal Nyaman & Kaos Kaki'},
      {'pk': 8, 'category': 'mum', 'detail': 'Gurita Ibu / Korset Postpartum'},

      // BAYI
      {'pk': 101, 'category': 'baby', 'detail': 'Baju Bayi Newborn (Kancing Depan)'},
      {'pk': 102, 'category': 'baby', 'detail': 'Bedong Kain Katun Lembut (4-5 lembar)'},
      {'pk': 103, 'category': 'baby', 'detail': 'Diaper Ukuran Newborn (1 pack)'},
      {'pk': 104, 'category': 'baby', 'detail': 'Minyak Telon & Tisu Basah Bebas Alkohol'},
      {'pk': 105, 'category': 'baby', 'detail': 'Sarung Tangan & Sarung Kaki Bayi'},
      {'pk': 106, 'category': 'baby', 'detail': 'Topi Bayi Lembut'},
      {'pk': 107, 'category': 'baby', 'detail': 'Selimut Topi untuk Pulang RS'},
      {'pk': 108, 'category': 'baby', 'detail': 'Handuk Bayi Lembut & Perlak Karet'},

      // PENDAMPING / SUAMI
      {'pk': 201, 'category': 'partner', 'detail': 'Baju Ganti Pendamping (2-3 set)'},
      {'pk': 202, 'category': 'partner', 'detail': 'Perlengkapan Ibadah'},
      {'pk': 203, 'category': 'partner', 'detail': 'Charger HP & Powerbank'},
      {'pk': 204, 'category': 'partner', 'detail': 'Dompet, Kartu Identitas & Cash Darurat'},
      {'pk': 205, 'category': 'partner', 'detail': 'Air Minum, Thermos & Snack Nutrisi'},
    ];

    return raw.map((map) {
      final pk = map['pk'] as int;
      return ChecklistItem(
        pk: pk,
        category: map['category'] as String,
        detail: map['detail'] as String,
        isDone: prefs.getBool('checklist_$pk') ?? false,
      );
    }).toList();
  }

  Future<void> toggleItem(ChecklistItem item) async {
    item.isDone = !item.isDone;
    items.refresh();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checklist_${item.pk}', item.isDone);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (var item in items) {
      item.isDone = false;
      await prefs.remove('checklist_${item.pk}');
    }
    items.refresh();
  }

  void selectCategory(String cat) => selectedCategory.value = cat;
}
