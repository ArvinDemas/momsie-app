import 'package:douce/shared/database/local_db_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirthPlanItem {
  final int pk;
  final String category;
  final String detail;
  bool isSelected;

  BirthPlanItem({
    required this.pk,
    required this.category,
    required this.detail,
    this.isSelected = false,
  });
}

class BirthPlanController extends GetxController {
  final RxList<BirthPlanItem> items = <BirthPlanItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString expandedCategory = ''.obs;

  // Indonesian-friendly category labels & icons
  static const Map<String, String> categoryLabels = {
    'environment': '🏥 Lingkungan Persalinan',
    'companions': '👨‍👩‍👧 Pendamping',
    'foetal monitoring': '💓 Pemantauan Janin',
    'photos & videos': '📸 Foto & Video',
    'induction': '💊 Induksi',
    'pain relief': '💆 Pereda Nyeri',
    'tearing & episiotomy': '✂️ Episiotomi',
    'during labour': '🤰 Saat Persalinan',
    'caesarean birth': '🏨 Persalinan Cesar',
    'delivery': '👶 Kelahiran',
    'birthing equipment': '🛏️ Peralatan',
    'after delivery': '🌸 Pasca Persalinan',
    'umbilical cord': '🔗 Tali Pusat',
    'feeding': '🍼 Menyusui',
  };

  List<String> get categories => categoryLabels.keys.toList();

  List<BirthPlanItem> itemsFor(String category) =>
      items.where((i) => i.category == category).toList();

  int get totalSelected => items.where((i) => i.isSelected).length;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  Future<void> _loadItems() async {
    isLoading.value = true;
    final db = await LocalDbService.database;
    final rows = await db.query('birthplan', orderBy: 'title, pk');
    final prefs = await SharedPreferences.getInstance();

    final loaded = rows.map((row) {
      final pk = row['pk'] as int;
      return BirthPlanItem(
        pk: pk,
        category: row['title'] as String,
        detail: row['detail'] as String,
        isSelected: prefs.getBool('birthplan_$pk') ?? false,
      );
    }).toList();

    items.assignAll(loaded);
    // Open first category by default
    if (categories.isNotEmpty) expandedCategory.value = categories.first;
    isLoading.value = false;
  }

  Future<void> toggleItem(BirthPlanItem item) async {
    item.isSelected = !item.isSelected;
    items.refresh();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('birthplan_${item.pk}', item.isSelected);
  }

  void toggleCategory(String cat) {
    expandedCategory.value = expandedCategory.value == cat ? '' : cat;
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (var item in items) {
      item.isSelected = false;
      await prefs.remove('birthplan_${item.pk}');
    }
    items.refresh();
  }
}
