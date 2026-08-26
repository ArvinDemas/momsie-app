import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/rumahsakit_service.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
import 'package:get/get.dart';

class UserEksplorController extends GetxController {
  final RxList<TokoBayiModel> tokoBayiList = <TokoBayiModel>[].obs;
  final RxList<RumahSakitModel> rumahSakitList = <RumahSakitModel>[].obs;
  final RxBool isLoading = true.obs;

  final RxString searchValue = ''.obs;
  final RxList<TokoBayiModel> filteredTokoBayi = <TokoBayiModel>[].obs;
  final RxList<RumahSakitModel> filteredRumahSakit = <RumahSakitModel>[].obs;

  @override
  void onInit() {
    _loadData();
    super.onInit();
  }

  void _loadData() {
    TokoBayiService().getTokoBayi().then((raw) {
      if (raw.isNotEmpty) {
        tokoBayiList.assignAll(raw.map((m) => TokoBayiModel.fromMap(m)).toList());
      } else {
        tokoBayiList.assignAll(DummyData.tokoBayis);
      }
    }).catchError((_) {
      tokoBayiList.assignAll(DummyData.tokoBayis);
    });

    RumahSakitService().getRumahSakit().then((list) {
      if (list.isNotEmpty) {
        rumahSakitList.assignAll(list);
      } else {
        rumahSakitList.assignAll(DummyData.rumahSakitList);
      }
      isLoading.value = false;
    }).catchError((_) {
      rumahSakitList.assignAll(DummyData.rumahSakitList);
      isLoading.value = false;
    });
  }

  void onSearch(String value) {
    searchValue.value = value;
    if (value.isEmpty) {
      filteredTokoBayi.clear();
      filteredRumahSakit.clear();
      return;
    }
    filteredTokoBayi.value = tokoBayiList
        .where((e) => e.nama.toLowerCase().contains(value.toLowerCase()))
        .toList();
    filteredRumahSakit.value = rumahSakitList
        .where((e) => e.nama.toLowerCase().contains(value.toLowerCase()) ||
            e.alamat.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
