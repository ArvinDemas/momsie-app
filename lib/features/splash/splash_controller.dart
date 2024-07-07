import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed('/login');
  }
}
