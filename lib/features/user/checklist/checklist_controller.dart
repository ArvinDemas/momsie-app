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

  // Kategori yang tersedia
  final List<String> categories = ['mum', 'partner', 'baby'];
  final Map<String, String> categoryLabels = {
    'mum': '👩 Untuk Ibu',
    'partner': '🧑 Untuk Pasangan',
    'baby': '👶 Untuk Bayi',
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
    final db = await LocalDbService.database;
    final rows = await db.query('hospitalbag', orderBy: 'category, pk');

    final prefs = await SharedPreferences.getInstance();
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
    isLoading.value = false;
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
