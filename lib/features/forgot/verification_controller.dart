import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final firstFocusNode = FocusNode();
  final secondFocusNode = FocusNode();
  final thirdFocusNode = FocusNode();
  final fourthFocusNode = FocusNode();

  final firstController = TextEditingController();
  final secondController = TextEditingController();
  final thirdController = TextEditingController();
  final fourthController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    firstController.addListener(() {
      if (firstController.text.length == 1) {
        FocusScope.of(Get.context!).requestFocus(secondFocusNode);
      }
    });

    secondController.addListener(() {
      if (secondController.text.length == 1) {
        FocusScope.of(Get.context!).requestFocus(thirdFocusNode);
      }
    });

    thirdController.addListener(() {
      if (thirdController.text.length == 1) {
        FocusScope.of(Get.context!).requestFocus(fourthFocusNode);
      }
    });
  }
}
