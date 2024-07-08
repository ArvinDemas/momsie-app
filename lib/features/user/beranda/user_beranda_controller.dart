import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:douce/shared/util/service/tokobayi_service.dart';
import 'package:get/get.dart';

class UserBerandaController extends GetxController {
  List<TokoBayiModel> tokoBayiList = [];
  RxBool isTokoBayiLoading = true.obs;

  @override
  void onInit() {
    getTokoBayi().then((_) {
      isTokoBayiLoading.value = false;
    });
    super.onInit();
  }

  Future<void> getTokoBayi() async {
    try {
      final tokoBayi = await TokoBayiService().getTokoBayi();
      if (tokoBayi.isNotEmpty) {
        tokoBayiList =
            tokoBayi.map((item) => TokoBayiModel.fromJson(item)).toList();
      }
    } catch (e) {
      // print(e);
    }
  }
}
