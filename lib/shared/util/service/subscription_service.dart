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

  @override
  void onInit() {
    super.onInit();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Untuk keperluan testing, pastikan isPremium ter-reset
    isPremium.value = false;
    await prefs.setBool('is_momsie_premium', false);
  }

  Future<void> setPremium(bool status) async {
    isPremium.value = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_momsie_premium', status);
  }

  Future<void> resetPremium() async {
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
    if (isPremium.value) {
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
