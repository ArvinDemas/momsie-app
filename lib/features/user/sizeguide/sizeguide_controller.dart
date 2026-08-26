import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/database/local_db_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizeGuideController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxInt pregnancyWeek = 20.obs;
  final Rx<DateTime?> hphtDate = Rx<DateTime?>(null);

  // sizeguide fields
  final RxString fruitName = ''.obs;
  final RxString lengthMetric = ''.obs;
  final RxString weightMetric = ''.obs;
  final RxString animalName = ''.obs;
  final RxString sweetsName = ''.obs;

  // today_tips fields (random 1 tip per category)
  final RxString tipBayi = ''.obs;
  final RxString tipTubuh = ''.obs;
  final RxString tipNutrisi = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final UserController userController = Get.find<UserController>();
      final uid = userController.uid.value;

      final prefs = await SharedPreferences.getInstance();
      int week = 20;

      // 1. Cek simpanan minggu manual pengguna di SharedPreferences
      final savedWeek = prefs.getInt('pregnancy_week');
      if (savedWeek != null && savedWeek >= 1 && savedWeek <= 42) {
        week = savedWeek;
      } else {
        // 2. Cek HPHT di SharedPreferences
        final hphtStr = prefs.getString('hpht_date');
        if (hphtStr != null) {
          final date = DateTime.tryParse(hphtStr);
          if (date != null) {
            hphtDate.value = date;
            final diffDays = DateTime.now().difference(date).inDays;
            week = (diffDays / 7).floor() + 1;
            week = week.clamp(1, 42);
          }
        } else if (uid.isNotEmpty) {
          // 3. Fallback ke Firestore
          try {
            final doc = await FirebaseFirestore.instance
                .collection('user')
                .doc(uid)
                .get();
            if (doc.exists && doc.data()!.containsKey('pregnancyWeek')) {
              week = (doc.data()!['pregnancyWeek'] as num).toInt().clamp(1, 42);
            }
          } catch (e) {
            debugPrint('Week load from Firestore error: $e');
          }
        }
      }
      pregnancyWeek.value = week;

      // Query SQLite untuk data visual & tips minggu ini
      await _loadMetricsAndTips(week);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMetricsAndTips(int week) async {
    final sg = await LocalDbService.getSizeGuide(week);
    if (sg != null) {
      fruitName.value = sg['fruit_name'] ?? '';
      lengthMetric.value = sg['length_metric'] ?? '';
      weightMetric.value = sg['weight_metric'] ?? '';
      animalName.value = sg['animal_name'] ?? '';
      sweetsName.value = sg['sweets_name'] ?? '';
    }

    final tt = await LocalDbService.getTodayTips(week);
    if (tt != null) {
      tipBayi.value = tt['your_baby'] ?? '';
      tipTubuh.value = tt['your_body'] ?? '';
      tipNutrisi.value = tt['nutrition_tips'] ?? '';
    }
  }

  /// Atur dan simpan minggu kehamilan pengguna secara permanen
  Future<void> setWeek(int week) async {
    final clampedWeek = week.clamp(1, 42);
    pregnancyWeek.value = clampedWeek;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pregnancy_week', clampedWeek);

    // Simpan juga ke Firestore
    final UserController userController = Get.find<UserController>();
    final uid = userController.uid.value;
    if (uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set({'pregnancyWeek': clampedWeek}, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Week save to Firestore error: $e');
      }
    }

    await _loadMetricsAndTips(clampedWeek);
  }

  Future<void> showHphtDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = hphtDate.value ?? now.subtract(const Duration(days: 140));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
      helpText: 'Pilih Tanggal HPHT Anda',
      confirmText: 'Pilih',
      cancelText: 'Batal',
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('hpht_date', picked.toIso8601String());
      hphtDate.value = picked;

      final diffDays = DateTime.now().difference(picked).inDays;
      int newWeek = (diffDays / 7).floor() + 1;
      newWeek = newWeek.clamp(1, 42);

      await setWeek(newWeek);
      Get.snackbar(
        'Berhasil diatur',
        'Usia kehamilan disesuaikan menjadi Minggu $newWeek.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> reloadData() => _loadData();
}
