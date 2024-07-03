import 'package:douce/app/app_routes.dart';
import 'package:douce/features/forgot/forgot_page.dart';
import 'package:douce/features/forgot/password_page.dart';
import 'package:douce/features/forgot/verification_page.dart';
import 'package:douce/features/login/login_page.dart';
import 'package:douce/features/mitra/akun/mitra_datadiri_page.dart';
import 'package:douce/features/mitra/akun/mitra_pendapatan_page.dart';
import 'package:douce/features/mitra/akun/mitra_riwayat_page.dart';
import 'package:douce/features/mitra/main_mitra.dart';
import 'package:douce/features/register/register_page.dart';
import 'package:douce/features/register/success_register_page.dart';
import 'package:douce/features/splash/splash_screen.dart';
import 'package:douce/features/user/akun/settings/user_bantuan_page.dart';
import 'package:douce/features/user/akun/settings/user_kebijakanprivasi_page.dart';
import 'package:douce/features/user/akun/settings/user_settingakun_page.dart';
import 'package:douce/features/user/akun/settings/user_settingbahasa_page.dart';
import 'package:douce/features/user/akun/settings/user_settingnotifikasi_page.dart';
import 'package:douce/features/user/akun/settings/user_tentangdoula_page.dart';
import 'package:douce/features/user/akun/user_datadiri_page.dart';
import 'package:douce/features/user/akun/user_hubungi_page.dart';
import 'package:douce/features/user/akun/progress/user_program_page.dart';
import 'package:douce/features/user/akun/progress/user_progress_page.dart';
import 'package:douce/features/user/akun/progress/user_riwayat_page.dart';
import 'package:douce/features/user/akun/settings/user_settings_page.dart';
import 'package:douce/features/user/beranda/detail_toko_page.dart.dart';
import 'package:douce/features/user/beranda/uesr_notifikasi.dart';
import 'package:douce/features/user/edukasi/user_artikel_page.dart';
import 'package:douce/features/user/edukasi/user_detailgerakan_page.dart';
import 'package:douce/features/user/edukasi/user_detailprogram_page.dart';
import 'package:douce/features/user/edukasi/user_programbulan_page.dart';
import 'package:douce/features/user/edukasi/user_programminggu_page.dart';
import 'package:douce/features/user/main_user.dart';
import 'package:douce/features/user/obat/detail_obat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Douce',
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: () => LoginPage(),
        ),
        GetPage(
          name: AppRoutes.splash,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: AppRoutes.register,
          page: () => RegisterPage(),
        ),
        GetPage(
          name: AppRoutes.registerSuccess,
          page: () => const SuccessRegisterPage(),
        ),
        GetPage(
          name: AppRoutes.forgotPassword,
          page: () => const ForgotPasswordPage(),
        ),
        GetPage(
          name: AppRoutes.verificationForgot,
          page: () => VerificationPage(),
        ),
        GetPage(
          name: AppRoutes.createPassword,
          page: () => const CreatePasswordPage(),
        ),
        GetPage(
          name: AppRoutes.mitra,
          page: () => const MainMitraPage(),
        ),
        GetPage(
          name: AppRoutes.mitraDataDiri,
          page: () => const MitraDataDiriPage(),
        ),
        GetPage(
          name: AppRoutes.mitraPendapatan,
          page: () => const MitraPendapatanPage(),
        ),
        GetPage(
          name: AppRoutes.mitraRiwayat,
          page: () => const MitraRiwayatPage(),
        ),
        GetPage(
          name: AppRoutes.user,
          page: () => const MainUserPage(),
        ),
        GetPage(
          name: AppRoutes.detailObat,
          page: () => const DetailObatPage(),
        ),
        GetPage(
          name: AppRoutes.detailToko,
          page: () => const DetailTokoPage(),
        ),
        GetPage(
          name: AppRoutes.userDataDiri,
          page: () => const UserDataDiriPage(),
        ),
        GetPage(
          name: AppRoutes.userProgress,
          page: () => const UserProgressPage(),
        ),
        GetPage(
          name: AppRoutes.userProgram,
          page: () => const UserProgramPage(),
        ),
        GetPage(
          name: AppRoutes.userRiwayat,
          page: () => const UserRiwayatPage(),
        ),
        GetPage(
          name: AppRoutes.userHubungi,
          page: () => const UserHubungiPage(),
        ),
        GetPage(
          name: AppRoutes.userSettings,
          page: () => const UserSettingsPage(),
        ),
        GetPage(
          name: AppRoutes.userKebijakanPrivasi,
          page: () => const UserKebijakanPrivasiPage(),
        ),
        GetPage(
          name: AppRoutes.userSettingAkun,
          page: () => const UserSettingAkunPage(),
        ),
        GetPage(
          name: AppRoutes.userSettingBahasa,
          page: () => const UserSettingBahasaPage(),
        ),
        GetPage(
          name: AppRoutes.userTentangDoula,
          page: () => const UserTentangDoulaPage(),
        ),
        GetPage(
          name: AppRoutes.userSettingNotifikasi,
          page: () => const UserSettingNotifikasiPage(),
        ),
        GetPage(
          name: AppRoutes.userBantuan,
          page: () => const UserBantuanPage(),
        ),
        GetPage(
          name: AppRoutes.userArtikel,
          page: () => const UserArtikelPage(),
        ),
        GetPage(
          name: AppRoutes.userDetailProgram,
          page: () => const UserDetailProgramPage(),
        ),
        GetPage(
          name: AppRoutes.userProgramBulan,
          page: () => const UserProgramBulanPage(),
        ),
        GetPage(
          name: AppRoutes.userProgramMinggu,
          page: () => const UserProgramMingguPage(),
        ),
        GetPage(
          name: AppRoutes.userDetailGerakan,
          page: () => const UserDetailGerakanPage(),
        ),
        GetPage(
          name: AppRoutes.userNotification,
          page: () => const UserNotifikasiPage(),
        )
      ],
      initialRoute: AppRoutes.login,
    );
  }
}
