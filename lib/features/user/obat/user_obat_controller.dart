import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/service/obat_service.dart';
import 'package:get/get.dart';

class UserObatController extends GetxController {
  final RxBool isObatLoading = true.obs;
  RxList<ObatModel> obatList = <ObatModel>[].obs;

  @override
  void onInit() {
    _loadData();
    super.onInit();
  }

  void _loadData() {
    ObatService().getObat().then((raw) {
      obatList.assignAll(raw.map((m) => ObatModel.fromMap(m)).toList());
      isObatLoading.value = false;
    });
  }
}
