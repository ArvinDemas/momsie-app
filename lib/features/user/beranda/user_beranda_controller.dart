import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/service/doula_service.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class UserBerandaController extends GetxController {
  RxList<TokoBayiModel> tokoBayiList = <TokoBayiModel>[].obs;
  RxBool isTokoBayiLoading = true.obs;

  RxList<ArtikelModel> artikelList = <ArtikelModel>[].obs;
  RxBool isArtikelLoading = true.obs;

  RxList<DoulaModel> doulaList = <DoulaModel>[].obs;
  RxBool isDoulaLoading = true.obs;

  List<ArtikelModel> getRandomArtikel() {
    var list = artikelList.toList();
    list.shuffle();
    return list.take(6).toList();
  }

  List<TokoBayiModel> getRandomTokoBayi() {
    var list = tokoBayiList.toList();
    list.shuffle();
    return list.take(4).toList();
  }

  List<DoulaModel> getRandomDoula() {
    var list = doulaList.toList();
    list.shuffle();
    return list.take(4).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Guard: hanya load jika belum ada data (aman untuk permanent controller)
    if (tokoBayiList.isNotEmpty && artikelList.isNotEmpty) return;

    TokoBayiService().getTokoBayi().then((raw) {
      if (raw.isNotEmpty) {
        tokoBayiList.assignAll(raw.map((m) => TokoBayiModel.fromMap(m)).toList());
      } else {
        tokoBayiList.assignAll(DummyData.tokoBayis);
      }
      isTokoBayiLoading.value = false;
    }).catchError((e) {
      tokoBayiList.assignAll(DummyData.tokoBayis);
      isTokoBayiLoading.value = false;
    });

    ArtikelService().getArtikel().then((list) {
      if (list.isNotEmpty) {
        artikelList.assignAll(list);
      } else {
        artikelList.assignAll(DummyData.artikels);
      }
      isArtikelLoading.value = false;
    }).catchError((e) {
      artikelList.assignAll(DummyData.artikels);
      isArtikelLoading.value = false;
    });

    DoulaService().getDoula().then((list) {
      if (list.isNotEmpty) {
        doulaList.assignAll(list);
      } else {
        doulaList.assignAll(DummyData.doulas);
      }
      isDoulaLoading.value = false;
    }).catchError((e) {
      doulaList.assignAll(DummyData.doulas);
      isDoulaLoading.value = false;
    });
  }
}
