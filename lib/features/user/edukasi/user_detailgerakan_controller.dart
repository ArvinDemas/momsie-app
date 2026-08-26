import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailGerakanController extends GetxController {
  final RxBool explanationState = true.obs;
  Timer? _timer;
  Function? onTimeEnd;
  final RxBool isPlaying = false.obs;
  RxInt timerSecond = 0.obs;
  RxInt streakCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentStreak();
  }

  Future<void> _loadCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    streakCount.value = prefs.getInt('yoga_streak') ?? 0;
  }

  void changeExplanationState() {
    explanationState.value = !explanationState.value;
  }

  String timerString() {
    final minutes = timerSecond ~/ 60;
    final seconds = timerSecond % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void timerClick() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      startTimer();
    } else {
      pauseTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerSecond > 0) {
        timerSecond--;
      } else {
        onTimeEnd?.call();
      }
    });
  }

  void pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Catat penyelesaian gerakan yoga dan perbarui Streak Harian (Daily Streak Counter)
  Future<int> recordYogaCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String? lastDate = prefs.getString('last_yoga_date');
    int currentStreak = prefs.getInt('yoga_streak') ?? 0;

    if (lastDate == null) {
      currentStreak = 1;
    } else if (lastDate == todayStr) {
      currentStreak = currentStreak == 0 ? 1 : currentStreak;
    } else {
      try {
        final DateTime last = DateTime.parse(lastDate);
        final DateTime today = DateTime.parse(todayStr);
        final int diffDays = today.difference(last).inDays;

        if (diffDays == 1) {
          currentStreak += 1;
        } else {
          currentStreak = 1;
        }
      } catch (e) {
        debugPrint('recordYoga error: $e');
        currentStreak = 1;
      }
    }

    await prefs.setString('last_yoga_date', todayStr);
    await prefs.setInt('yoga_streak', currentStreak);
    streakCount.value = currentStreak;

    // Sinkronisasi ke Firestore
    try {
      final UserController userController = Get.find<UserController>();
      final uid = userController.uid.value;
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'yogaStreak': currentStreak,
          'lastYogaDate': todayStr,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Firestore streak sync error: $e');
    }

    return currentStreak;
  }
}
