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
import 'package:douce/features/user/beranda/detail_toko_page.dart.dart';
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
        )
      ],
      initialRoute: AppRoutes.user,
    );
  }
}
