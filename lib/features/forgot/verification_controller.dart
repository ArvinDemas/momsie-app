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

  final RxBool isLoading = false.obs;

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

  /// Get the full 4-digit code from all controllers
  String getVerificationCode() {
    return '${firstController.text}${secondController.text}${thirdController.text}${fourthController.text}';
  }

  /// Check if all 4 digits have been entered
  bool isCodeComplete() {
    return firstController.text.isNotEmpty &&
        secondController.text.isNotEmpty &&
        thirdController.text.isNotEmpty &&
        fourthController.text.isNotEmpty;
  }

  /// Store the 4-digit verification code for later use in password reset.
  String? storedCode;

  /// Verify the 4-digit code: checks completeness and stores it.
  /// Returns true if all 4 digits are entered (client-side validation).
  /// The actual Firebase OOB code validation happens in CreatePasswordPage
  /// when confirmPasswordReset() is called with the stored code and new password.
  bool verifyCode() {
    if (!isCodeComplete()) return false;
    storedCode = getVerificationCode();
    return true;
  }

  @override
  void onClose() {
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.onClose();
  }
}
