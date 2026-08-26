import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirthPlanItem {
  final String id;
  final String category;
  final String detail;
  bool isSelected;
  final bool isCustom;

  BirthPlanItem({
    required this.id,
    required this.category,
    required this.detail,
    this.isSelected = false,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'detail': detail,
        'isSelected': isSelected,
        'isCustom': isCustom,
      };

  factory BirthPlanItem.fromJson(Map<String, dynamic> json) => BirthPlanItem(
        id: json['id'] as String,
        category: json['category'] as String,
        detail: json['detail'] as String,
        isSelected: json['isSelected'] as bool? ?? false,
        isCustom: json['isCustom'] as bool? ?? false,
      );
}

class BirthPlanController extends GetxController {
  final RxList<BirthPlanItem> items = <BirthPlanItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString expandedCategory = 'Fase Laten'.obs;

  static const List<String> categories = [
    'Fase Laten',
    'Pengelolaan Rasa Nyeri',
    'Fase Aktif',
    'Setelah Persalinan',
  ];

  static const Map<String, List<String>> defaultItems = {
    'Fase Laten': [
      'Pendamping / suami saya selalu bisa mendampingi saya',
      'Ada pendamping persalinan lain selain pendamping utama (suami)',
      'Staf rumah sakit terbatas pada dokter, perawat, bidan (tidak ada mahasiswa KOAS, intern atau residen)',
      'Mempunyai pilihan untuk pulang terlebih dahulu di saat pembukaan belum memasuki fase aktif',
      'Ruangan dalam keadaan lampu redup / mati',
      'Saya diperbolehkan makan dan minum',
      'Berjalan-jalan dan bebas bergerak sesuai keinginan saya (tidak diinfus, tidak menggunakan kateter)',
      'Menggunakan pakaian saya sendiri',
      'Keadaan ruangan tenang',
      'Mendengarkan musik pilihan saya',
      'Pemeriksaan dalam (VT) seminimal mungkin untuk meminimalkan infeksi',
      'Mengambil gambar atau video',
      'Tidak dilakukan pemantauan janin secara kontinyu / hanya intermitten (berselang) saja kecuali terjadi gawat janin',
      'Tidak diberikan induksi kecuali terjadi gawat janin',
    ],
    'Pengelolaan Rasa Nyeri': [
      'Sealami mungkin dengan mengganti posisi, berjalan-jalan, mandi air hangat, melakukan pijat dan duduk di atas birth ball / gym ball',
      'Melakukan relaksasi hypnobirthing dengan pendamping persalinan saya',
      'Tidak ditawarkan penghilang rasa nyeri kecuali saya yang meminta',
    ],
    'Fase Aktif': [
      'Saya memperbolehkan yang berada di dalam ruang persalinan (isi bebas / custom)',
      'Saya tidak memperbolehkan yang berada di dalam ruang persalinan (isi bebas / custom)',
      'Tidak diberikan induksi kecuali terjadi gawat janin',
      'Mendorong bayi keluar di saat saya menginginkannya (selama saya dan bayi dalam keadaan stabil)',
      'Mencoba beberapa posisi persalinan yang berbeda yang membuat saya merasa paling nyaman',
      'Mendorong secara spontan mengikuti naluri saya',
      'Menyentuh kepala bayi saya saat sudah mulai nampak',
      'Ruangan dalam keadaan tenang',
      'Tidak dilakukan episiotomy jika memungkinkan',
      'Menghindari penggunaan forcep dan vakum',
      'Pendamping saya membantu "menangkap" bayi',
    ],
    'Setelah Persalinan': [
      'Melakukan Cord Clamping Delay (penundaan pemotongan / penjepitan tali pusat)',
      'Suami saya memotong tali pusat bayi',
      'Memeluk bayi saya sesegera mungkin setelah dilahirkan',
      'Melakukan IMD (Inisiasi Menyusui Dini)',
      'Menunda pemeriksaan & prosedur medis pada bayi hingga IMD selesai',
      'Pendamping / suami mendampingi bayi selama prosedur kesehatan dilakukan',
      'Suami melakukan skin to skin dengan bayi',
      'Rooming in dengan bayi setelah dilahirkan',
      'Hanya memberikan ASI pada bayi',
    ],
  };

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
    final prefs = await SharedPreferences.getInstance();

    final List<BirthPlanItem> list = [];

    // Load standard items
    int idCounter = 1;
    for (var cat in categories) {
      final stdList = defaultItems[cat] ?? [];
      for (var detail in stdList) {
        final itemId = 'std_$idCounter';
        final isSel = prefs.getBool('bp_sel_$itemId') ?? false;
        list.add(BirthPlanItem(
          id: itemId,
          category: cat,
          detail: detail,
          isSelected: isSel,
          isCustom: false,
        ));
        idCounter++;
      }
    }

    // Load user custom items
    final customRaw = prefs.getStringList('bp_custom_items') ?? [];
    for (var rawStr in customRaw) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(rawStr);
        final item = BirthPlanItem.fromJson(jsonMap);
        list.add(item);
      } catch (_) {}
    }

    items.assignAll(list);
    isLoading.value = false;
  }

  Future<void> toggleItem(BirthPlanItem item) async {
    item.isSelected = !item.isSelected;
    items.refresh();
    await _saveState(item);
  }

  Future<void> addCustomItem(String category, String detail) async {
    if (detail.trim().isEmpty) return;

    final newItem = BirthPlanItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      category: category,
      detail: detail.trim(),
      isSelected: true,
      isCustom: true,
    );

    items.add(newItem);
    items.refresh();
    await _saveCustomItems();
  }

  Future<void> deleteCustomItem(BirthPlanItem item) async {
    items.removeWhere((i) => i.id == item.id);
    items.refresh();
    await _saveCustomItems();
  }

  Future<void> _saveState(BirthPlanItem item) async {
    final prefs = await SharedPreferences.getInstance();
    if (item.isCustom) {
      await _saveCustomItems();
    } else {
      await prefs.setBool('bp_sel_${item.id}', item.isSelected);
    }
  }

  Future<void> _saveCustomItems() async {
    final prefs = await SharedPreferences.getInstance();
    final customList = items.where((i) => i.isCustom).toList();
    final strList = customList.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList('bp_custom_items', strList);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (var item in items) {
      item.isSelected = false;
      await prefs.remove('bp_sel_${item.id}');
    }
    await _saveCustomItems();
    items.refresh();
  }

  void toggleCategory(String cat) {
    expandedCategory.value = expandedCategory.value == cat ? '' : cat;
  }
}
