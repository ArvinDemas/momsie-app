import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:get/get.dart';

class UserObatController extends GetxController {
  final RxBool isObatLoading = true.obs;
  RxList<ObatModel> obatList = <ObatModel>[].obs;

  @override
  void onInit() {
    // Simulasi loading dari dummy data
    Future.delayed(const Duration(milliseconds: 700), () {
      obatList.assignAll(DummyData.obats);
      isObatLoading.value = false;
    });
    super.onInit();
  }
}
