import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
import 'package:get/get.dart';

class UserBerandaController extends GetxController {
  RxList<TokoBayiModel> tokoBayiList = <TokoBayiModel>[].obs;
  RxBool isTokoBayiLoading = true.obs;

  RxList<ArtikelModel> artikelList = <ArtikelModel>[].obs;
  RxBool isArtikelLoading = true.obs;
  @override
  void onInit() {
    getTokoBayi().then((_) {
      isTokoBayiLoading.value = false;
    });
    getArtikel().then((_) {
      isArtikelLoading.value = false;
    });
    super.onInit();
  }

  Future<void> getTokoBayi() async {
    try {
      final tokoBayi = await TokoBayiService().getTokoBayi();
      if (tokoBayi.isNotEmpty) {
        tokoBayiList.assignAll(
            tokoBayi.map((item) => TokoBayiModel.fromJson(item)).toList());
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> getArtikel() async {
    try {
      final artikel = await ArtikelService().getArtikel();
      if (artikel.isNotEmpty) {
        artikelList.assignAll(
            artikel.map((item) => ArtikelModel.fromJson(item)).toList());
      }
    } catch (e) {
      // print(e);
    }
  }
}
