import 'package:get/get.dart';

class UserDetailGerakanController extends GetxController {
  final RxBool explanationState = true.obs;

  void changeExplanationState() {
    explanationState.value = !explanationState.value;
  }
}
