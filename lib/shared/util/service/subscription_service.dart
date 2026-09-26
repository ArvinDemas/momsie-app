import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:douce/shared/widget/paywall_modal.dart';

class SubscriptionService extends GetxService {
  static SubscriptionService get to {
    if (!Get.isRegistered<SubscriptionService>()) {
      return Get.put(SubscriptionService());
    }
    return Get.find<SubscriptionService>();
  }

  final RxBool isPremium = false.obs;

  static const List<String> whitelistedKeywords = [
    'adnaryama',
    'adnaryama12',
    'adnaryama12@gmail.com',
    'adnaryama12gmail.com',
  ];

  static bool isWhitelistedEmail(String? email, [String? username]) {
    final e = (email ?? '').trim().toLowerCase().replaceAll(' ', '');
    final u = (username ?? '').trim().toLowerCase().replaceAll(' ', '');

    for (final kw in whitelistedKeywords) {
      if (e.contains(kw) || u.contains(kw)) {
        return true;
      }
    }
    return false;
  }

  bool isSubscribedUser() {
    // 1. Check current FirebaseAuth user email & displayName
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser != null) {
      if (isWhitelistedEmail(authUser.email, authUser.displayName)) return true;
    }

    // 2. Check UserController if registered
    if (Get.isRegistered<UserController>()) {
      final userCtrl = Get.find<UserController>();
      if (isWhitelistedEmail(userCtrl.email.value, userCtrl.username.value)) {
        return true;
      }
    }

    return false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPremium = prefs.getBool('is_momsie_premium') ?? false;

    if (savedPremium || isSubscribedUser()) {
      isPremium.value = true;
      await prefs.setBool('is_momsie_premium', true);
    } else {
      isPremium.value = false;
    }

    // Periksa Firestore jika user sudah login
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
        if (doc.exists && doc.data()?['isPremium'] == true) {
          isPremium.value = true;
          await prefs.setBool('is_momsie_premium', true);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Error checking user premium in Firestore: $e');
      }
    }
  }

  Future<void> checkSubscriptionStatus() async {
    if (isSubscribedUser()) {
      await setPremium(true);
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
        if (doc.exists && doc.data()?['isPremium'] == true) {
          await setPremium(true);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Error checking user premium status in firestore: $e');
      }
    }
  }

  Future<void> setPremium(bool status) async {
    isPremium.value = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_momsie_premium', status);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'isPremium': status,
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) debugPrint('Error saving isPremium to firestore: $e');
      }
    }
  }

  Future<void> resetPremium() async {
    if (isSubscribedUser()) {
      isPremium.value = true;
      return;
    }
    isPremium.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_momsie_premium', false);
  }

  /// Shows the Premium Paywall Modal Sheet.
  /// If [canDismissToAccess] is true, tapping X closes popup and lets user continue (e.g. Input Diary, AI Chat).
  /// If [canDismissToAccess] is false, user must unlock to access (e.g. Birth Plan, Postpartum Wellbeing, Export PDF).
  void showPaywall({
    required BuildContext context,
    required String featureName,
    bool canDismissToAccess = false,
    VoidCallback? onUnlocked,
  }) {
    if (isPremium.value || isSubscribedUser()) {
      isPremium.value = true;
      onUnlocked?.call();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaywallModal(
        featureName: featureName,
        canDismissToAccess: canDismissToAccess,
        onUnlocked: () async {
          await setPremium(true);
          Navigator.of(ctx).pop();
          onUnlocked?.call();
          Get.snackbar(
            'Momsie Premium Aktif! 🎉',
            'Selamat! Seluruh fitur premium Momsie telah terbuka 100%.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
          );
        },
      ),
    );
  }
}
