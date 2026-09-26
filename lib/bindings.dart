import 'package:douce/features/forgot/forgot_controller.dart';
import 'package:douce/features/forgot/verification_controller.dart';
import 'package:douce/features/login/login_controller.dart';
import 'package:douce/features/mitra/dashboard/mitra_dashboard_controller.dart';
import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/features/register/register_controller.dart';
import 'package:douce/features/splash/splash_controller.dart';
import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/features/user/obat/user_obat_controller.dart';
import 'package:douce/shared/util/service/subscription_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<RegisterController>(RegisterController(), permanent: true);
    Get.put<ForgotController>(ForgotController(), permanent: true);
    Get.put<VerificationController>(VerificationController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<UserBerandaController>(UserBerandaController(), permanent: true);
    Get.put<UserKesehatanController>(UserKesehatanController(), permanent: true);
    Get.put<UserObatController>(UserObatController(), permanent: true);
    Get.put<MitraDashboardController>(MitraDashboardController(), permanent: true);
    Get.put<MitraPekerjaanController>(MitraPekerjaanController(), permanent: true);
    Get.put<SubscriptionService>(SubscriptionService(), permanent: true);
  }
}
