import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/service/rumahsakit_service.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
import 'package:get/get.dart';

class UserBerandaController extends GetxController {
  RxList<TokoBayiModel> tokoBayiList = <TokoBayiModel>[].obs;
  RxBool isTokoBayiLoading = true.obs;

  RxList<ArtikelModel> artikelList = <ArtikelModel>[].obs;
  RxBool isArtikelLoading = true.obs;

  RxList<RumahSakitModel> rumahSakitList = <RumahSakitModel>[].obs;
  RxBool isRumahSakitLoading = true.obs;

  List<RumahSakitModel> getRandomRumahSakit() {
    var list = rumahSakitList.toList();
    list.shuffle();
    return list.take(2).toList();
  }

  List<ArtikelModel> getRandomArtikel() {
    var list = artikelList.toList();
    list.shuffle();
    return list.take(6).toList();
  }

  List<TokoBayiModel> getRandomTokoBayi() {
    var list = tokoBayiList.toList();
    list.shuffle();
    return list.take(2).toList();
  }

  @override
  void onInit() {
    getTokoBayi().then((_) {
      isTokoBayiLoading.value = false;
    });
    getArtikel().then((_) {
      isArtikelLoading.value = false;
    });
    getRumahSakit().then((_) {
      isRumahSakitLoading.value = false;
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
      final List<ArtikelModel> artikel = await ArtikelService().getArtikel();
      if (artikel.isNotEmpty) {
        artikelList.assignAll(artikel);
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> getRumahSakit() async {
    try {
      final List<RumahSakitModel> rumahSakit =
          await RumahSakitService().getRumahSakit();
      if (rumahSakit.isNotEmpty) {
        rumahSakitList.assignAll(rumahSakit);
      }
    } catch (e) {
      // print(e);
    }
  }
}
