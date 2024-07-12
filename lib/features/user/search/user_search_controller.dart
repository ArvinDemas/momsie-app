import 'package:douce/features/user/search/user_search_service.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';
import 'package:get/get.dart';

class UserSearchController extends GetxController {
  final RxString querySearch = ''.obs;

  final RxList<TokoBayiModel> tokoBayiList = <TokoBayiModel>[].obs;
  final RxList<ObatModel> obatList = <ObatModel>[].obs;

  final RxBool isLoading = false.obs;

  void onSearch(String query) {
    querySearch.value = query;
    isLoading.value = true;

    tokoBayiList.clear();
    obatList.clear();

    searchQuery().then((_) {
      isLoading.value = false;
    });
  }

  Future<void> searchQuery() async {
    try {
      final List<ObatModel> listObat =
          await SearchService().searchObat(querySearch.value);
      final List<TokoBayiModel> listTokoBayi =
          await SearchService().searchTokoBayi(querySearch.value);

      if (listObat.isNotEmpty) {
        obatList.assignAll(listObat);
      }

      if (listTokoBayi.isNotEmpty) {
        tokoBayiList.assignAll(listTokoBayi);
      }
    } catch (e) {
      // print(e);
    }
  }
}
