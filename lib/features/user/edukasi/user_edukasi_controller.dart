import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:get/get.dart';

class UserEdukasiController extends GetxController {
  final RxString edukasi = "Artikel".obs;
  final RxBool isLoadingArtikel = true.obs;
  RxList<ArtikelModel> artikelList = <ArtikelModel>[].obs;

  @override
  void onInit() {
    getArtikel().then((_) {
      isLoadingArtikel.value = false;
    });
    super.onInit();
  }

  void changeEdukasi(String value) {
    edukasi.value = value;
  }

  Future<void> getArtikel() async {
    final artikel = await ArtikelService().getArtikel();
    if (artikel.isNotEmpty) {
      artikelList
          .assignAll(artikel.map((e) => ArtikelModel.fromJson(e)).toList());
    }
  }
}
