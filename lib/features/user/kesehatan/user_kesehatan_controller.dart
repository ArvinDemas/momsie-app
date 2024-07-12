import 'package:get/get.dart';

class UserKesehatanController extends GetxController {
  UserKesehatanController({this.title = "Rumah Sakit"});

  final String title;

  RxString kesehatanType = "".obs;

  @override
  void onInit() {
    kesehatanType.value = title;
    super.onInit();
  }

  void changeType(String value) {
    kesehatanType.value = value;
    update();
  }
}
