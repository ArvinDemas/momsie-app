import 'package:get/get.dart';

class UserController extends GetxController {
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString uid = ''.obs;
  RxString image = ''.obs;

  void setUser(String username, String email, String uid, String image) {
    this.username.value = username;
    this.email.value = email;
    this.uid.value = uid;
    this.image.value = image;
  }

  void updateUser(String username) {
    this.username.value = username;
  }
}
