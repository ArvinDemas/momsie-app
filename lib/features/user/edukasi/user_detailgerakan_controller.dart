import 'dart:async';
import 'package:get/get.dart';

class UserDetailGerakanController extends GetxController {
  final RxBool explanationState = true.obs;
  Timer? _timer;
  Function? onTimeEnd;
  final RxBool isPlaying = false.obs;
  RxInt timerSecond = 0.obs;

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
        onTimeEnd!();
      }
    });
  }

  void pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }
}
