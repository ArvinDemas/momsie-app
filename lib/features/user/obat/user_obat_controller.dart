import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/service/obat_service.dart';
import 'package:get/get.dart';

class UserObatController extends GetxController {
  final RxBool isObatLoading = true.obs;
  RxList<ObatModel> obatList = <ObatModel>[].obs;

  @override
  void onInit() {
    getObat().then((_) {
      isObatLoading.value = false;
    });
    super.onInit();
  }

  Future<void> getObat() async {
    try {
      final obat = await ObatService().getObat();
      if (obat.isNotEmpty) {
        obatList
            .assignAll(obat.map((item) => ObatModel.fromJson(item)).toList());
      }
    } catch (e) {
      // print(e);
    }
  }
}
