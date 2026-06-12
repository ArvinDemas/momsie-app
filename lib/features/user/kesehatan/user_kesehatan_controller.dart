import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/doula_model.dart';
import 'package:get/get.dart';

class UserKesehatanController extends GetxController {
  final RxList<DoulaModel> doulaList = <DoulaModel>[].obs;
  final RxList<DoulaModel> listFilteredDoula = <DoulaModel>[].obs;

  final RxBool isLoading = true.obs;

  RxString kesehatanType = "Doula".obs;
  RxString searchValue = "".obs;

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 600), () {
      doulaList.assignAll(DummyData.doulas);
      isLoading.value = false;
    });
    super.onInit();
  }

  void changeType(String value) {
    kesehatanType.value = value;
    update();
  }

  void onSearch(String value) {
    searchValue.value = value;
    if (value.isEmpty) {
      listFilteredDoula.clear();
      return;
    }
    listFilteredDoula.value = doulaList
        .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
