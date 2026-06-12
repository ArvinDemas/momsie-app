import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
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
    final UserController userController = Get.find<UserController>();
    var list =
        doulaList.where((e) => e.uid != userController.uid.value).toList();
    list.shuffle();
    return list.take(4).toList();
  }

  @override
  void onInit() {
    // Simulasi loading 800ms dari dummy data (UI tidak berubah)
    Future.delayed(const Duration(milliseconds: 800), () {
      tokoBayiList.assignAll(DummyData.tokoBayis);
      isTokoBayiLoading.value = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      artikelList.assignAll(DummyData.artikels);
      isArtikelLoading.value = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      doulaList.assignAll(DummyData.doulas);
      isDoulaLoading.value = false;
    });

    super.onInit();
  }
}
