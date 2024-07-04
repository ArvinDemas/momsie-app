import 'dart:async';
import 'package:get/get.dart';

class UserDetailGerakanController extends GetxController {
  final RxBool explanationState = true.obs;
  final RxInt timerSecond = 60.obs;
  Timer? _timer;
  final RxBool isPlaying = false.obs;

  void changeExplanationState() {
    explanationState.value = !explanationState.value;
  }

  String timerString() {
    final minutes = timerSecond.value ~/ 60;
    final seconds = timerSecond.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void timerClick(){
    isPlaying.value = !isPlaying.value;
    if(isPlaying.value){
      startTimer();
    }else{
      pauseTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerSecond.value > 0) {
        timerSecond.value--;
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
