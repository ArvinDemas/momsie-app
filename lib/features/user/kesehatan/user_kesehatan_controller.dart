import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/util/service/doula_service.dart';
import 'package:douce/shared/util/service/rumahsakit_service.dart';
import 'package:get/get.dart';

class UserKesehatanController extends GetxController {
  final RxList<DoulaModel> doulaList = <DoulaModel>[].obs;
  final RxList<DoulaModel> listFilteredDoula = <DoulaModel>[].obs;

  final RxList<RumahSakitModel> rumahSakitList = <RumahSakitModel>[].obs;
  final RxList<RumahSakitModel> listFilteredRumahSakit = <RumahSakitModel>[].obs;

  final RxBool isLoading = true.obs;

  RxString kesehatanType = "Doula".obs;
  RxString searchValue = "".obs;

  @override
  void onInit() {
    _loadData();
    super.onInit();
  }

  static int _doulaPriority(DoulaModel d) {
    final name = d.name.toLowerCase();
    if (name.contains('dewi riana')) return 0;
    if (name.contains('laily')) return 1;
    if (name.contains('erny')) return 2;
    if (name.contains('agustin')) return 3;
    if (name.contains('karisma')) return 4;
    if (name.contains('anastasia')) return 5;
    if (name.contains('arvin')) return 9999;
    return 100;
  }

  void _loadData() {
    DoulaService().getDoula().then((list) {
      final combined = <DoulaModel>[...DummyData.doulas];
      for (var d in list) {
        if (!combined.any((existing) => existing.name.toLowerCase() == d.name.toLowerCase())) {
          combined.add(d);
        }
      }
      combined.sort((a, b) => _doulaPriority(a).compareTo(_doulaPriority(b)));
      doulaList.assignAll(combined);
      isLoading.value = false;
    }).catchError((_) {
      final fallback = <DoulaModel>[...DummyData.doulas];
      fallback.sort((a, b) => _doulaPriority(a).compareTo(_doulaPriority(b)));
      doulaList.assignAll(fallback);
      isLoading.value = false;
    });

    RumahSakitService().getRumahSakit().then((list) {
      final combined = <RumahSakitModel>[...DummyData.rumahSakitList];
      for (var r in list) {
        if (!combined.any((existing) => existing.nama.toLowerCase() == r.nama.toLowerCase())) {
          combined.add(r);
        }
      }
      rumahSakitList.assignAll(combined);
      isLoading.value = false;
    }).catchError((_) {
      rumahSakitList.assignAll(DummyData.rumahSakitList);
      isLoading.value = false;
    });
  }

  void changeType(String value) {
    kesehatanType.value = value;
    update();
  }

  void onSearch(String value) {
    searchValue.value = value;
    if (value.isEmpty) {
      listFilteredDoula.clear();
      listFilteredRumahSakit.clear();
      return;
    }
    listFilteredDoula.value = doulaList
        .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    listFilteredRumahSakit.value = rumahSakitList
        .where((e) => e.nama.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
