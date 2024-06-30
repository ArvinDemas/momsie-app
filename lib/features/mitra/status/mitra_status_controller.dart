import 'package:get/get.dart';

class MitraStatusController extends GetxController {
  final status = "Berjalan".obs;

  void changeStatus(String newStatus) {
    status.value = newStatus;
  }
}
