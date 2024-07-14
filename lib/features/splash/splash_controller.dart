import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.offNamed('/login');
        return;
      }

      final UserController userController = Get.find<UserController>();

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc =
          await firestore.collection('user').doc(user.uid).get();
      userDoc.data() as Map<String, dynamic>;

      userController.setUser(
        userDoc['username'],
        user.email!,
        user.uid,
        userDoc['image'],
      );
      Get.offNamed('/user');
    });
  }
}
