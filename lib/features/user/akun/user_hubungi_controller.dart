import 'package:get/get.dart';

class UserHubungiController extends GetxController {
  final RxBool customerServiceToggle = false.obs;
  final RxBool whatsAppToggle = false.obs;
  final RxBool websiteToggle = false.obs;
  final RxBool facebookToggle = false.obs;
  final RxBool instagramToggle = false.obs;

  void toggleCustomerService() {
    customerServiceToggle.value = !customerServiceToggle.value;
  }

  void toggleWhatsApp() {
    whatsAppToggle.value = !whatsAppToggle.value;
  }

  void toggleWebsite() {
    websiteToggle.value = !websiteToggle.value;
  }

  void toggleFacebook() {
    facebookToggle.value = !facebookToggle.value;
  }

  void toggleInstagram() {
    instagramToggle.value = !instagramToggle.value;
  }
}
