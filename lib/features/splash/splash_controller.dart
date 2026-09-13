import 'dart:async';
import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/health_consent_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  StreamSubscription<User?>? _authSubscription;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
        if (hasSeenOnboarding) {
          Get.offNamed('/login');
        } else {
          Get.offNamed('/onboarding');
        }
        return;
      }

      final UserController userController = Get.find<UserController>();

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc;
      try {
        userDoc = await firestore.collection('user').doc(user.uid).get();
      } catch (e) {
        debugPrint('Splash: failed to get user doc: $e');
        Get.offNamed('/login');
        return;
      }
      if (!userDoc.exists) {
        Get.offNamed('/login');
        return;
      }

      userController.setUser(
        userDoc['username'],
        user.email!,
        user.uid,
        userDoc['image'],
        userDoc['isDoula'],
      );

      // Cek email verified
      if (!user.emailVerified) {
        Get.offNamed('/verify-email');
        return;
      }

      // Cek mode aktif terakhir yang disimpan di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final lastActiveMode = prefs.getString('last_active_mode') ?? 'user';

      // Redirect ke maternal context page jika belum mengisi profil kehamilan
      if (lastActiveMode == 'user' && !userDoc['isDoula']) {
        final hasMaternalContext =
            prefs.getBool('has_completed_maternal_context') ?? false;
        if (!hasMaternalContext) {
          Get.offNamed(AppRoutes.maternalContext);
          return;
        }
      }

      // Cek apakah consent sudah pernah diberikan.
      final alreadyConsented = await HealthConsentDialog.isConsentGiven();
      final targetRoute = (lastActiveMode == 'mitra' && userDoc['isDoula'] == true)
          ? '/mitra'
          : '/user';

      if (alreadyConsented) {
        Get.offNamed(targetRoute);
      } else {
        await Get.dialog(
          HealthConsentDialog(
            onConsented: () => Get.offNamed(targetRoute),
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
