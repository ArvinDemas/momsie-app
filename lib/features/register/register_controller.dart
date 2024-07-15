import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isSetuju = false.obs;
  final Rx<TextEditingController> usernameController =
      TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  Future<void> tryRegister() async {
    if (usernameController.value.text == '' ||
        emailController.value.text == '' ||
        passwordController.value.text == '') {
      Get.snackbar(
        'Empty fields',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (!isSetuju.value) {
      Get.snackbar(
        'Terms and Conditions',
        'Please agree to the terms and conditions',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (passwordController.value.text.length < 6) {
      Get.snackbar(
        'Password',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text,
      );

      Map<String, dynamic> userData = {
        'username': usernameController.value.text,
        'email': emailController.value.text,
        'uid': userCredential.user!.uid,
        'image': '',
        'isDoula': false,
      };

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set(userData);

      final UserController userController = Get.find<UserController>();
      userController.setUser(
        usernameController.value.text,
        emailController.value.text,
        userCredential.user!.uid,
        '',
        false,
      );

      Get.toNamed('/register-success');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  void onCheckBox() {
    isSetuju.value = !isSetuju.value;
  }
}
