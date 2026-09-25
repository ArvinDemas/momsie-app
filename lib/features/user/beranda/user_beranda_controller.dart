import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/service/doula_service.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
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
      final combined = <TokoBayiModel>[...DummyData.tokoBayis];
      for (var m in raw) {
        final remote = TokoBayiModel.fromMap(m);
        if (!combined.any((existing) => existing.nama.toLowerCase() == remote.nama.toLowerCase())) {
          combined.add(remote);
        }
      }
      tokoBayiList.assignAll(combined);
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

    _loadDoulaData();
  }

  static int _doulaPriority(DoulaModel d) {
    final name = d.name.toLowerCase();
    if (name.contains('dewi riana')) return 0;
    if (name.contains('laily')) return 1;
    if (name.contains('arvin')) return 9999;
    return 100;
  }

  void _loadDoulaData() {
    DoulaService().getDoula().then((list) {
      final combined = <DoulaModel>[...DummyData.doulas];
      for (var d in list) {
        if (!combined.any((existing) => existing.name.toLowerCase() == d.name.toLowerCase())) {
          combined.add(d);
        }
      }
      combined.sort((a, b) => _doulaPriority(a).compareTo(_doulaPriority(b)));
      doulaList.assignAll(combined);
      isDoulaLoading.value = false;
    }).catchError((e) {
      final fallback = <DoulaModel>[...DummyData.doulas];
      fallback.sort((a, b) => _doulaPriority(a).compareTo(_doulaPriority(b)));
      doulaList.assignAll(fallback);
      isDoulaLoading.value = false;
    });
  }
}
