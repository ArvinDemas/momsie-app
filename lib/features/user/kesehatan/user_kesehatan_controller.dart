import 'package:get/get.dart';

class UserKesehatanController extends GetxController {
  RxString kesehatanType = "Rumah Sakit".obs;

  void changeType(String value) {
    kesehatanType.value = value;
  }
}
