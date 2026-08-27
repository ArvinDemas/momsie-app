import 'package:douce/app/app_routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:douce/features/forgot/forgot_page.dart';
import 'package:douce/features/forgot/password_page.dart';
import 'package:douce/features/forgot/verification_page.dart';
import 'package:douce/features/login/login_page.dart';
import 'package:douce/features/mitra/akun/mitra_akun_page.dart';
import 'package:douce/features/mitra/akun/mitra_datadiri_page.dart';
import 'package:douce/features/mitra/pendapatan/mitra_pendapatan_page.dart';
import 'package:douce/features/mitra/profil/mitra_aturjadwal_page.dart';
import 'package:douce/features/verify_email/verify_email_page.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/features/mitra/main_mitra.dart';
import 'package:douce/features/mitra_register/confirmation_register_page.dart';
import 'package:douce/features/mitra_register/mitra_register_page.dart';
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
import 'package:douce/features/user/beranda/detail_toko_page.dart';
import 'package:douce/features/user/beranda/see_more_page.dart';
import 'package:douce/features/user/beranda/user_notifikasi_page.dart';
import 'package:douce/features/user/akun/user_akun_page.dart';
import 'package:douce/features/user/pesanan/user_pesanan_page.dart';
import 'package:douce/features/user/search/user_search_page.dart';
import 'package:douce/features/user/edukasi/user_artikel_page.dart';
import 'package:douce/features/user/edukasi/user_detailgerakan_page.dart';
import 'package:douce/features/user/edukasi/user_detailprogram_page.dart';
import 'package:douce/features/user/edukasi/user_programbulan_page.dart';
import 'package:douce/features/user/edukasi/user_programminggu_page.dart';
import 'package:douce/features/user/kesehatan/booking_doula_page.dart';
import 'package:douce/features/user/chat/chat_page.dart';
import 'package:douce/features/user/kesehatan/confirm_booking_page.dart';
import 'package:douce/features/user/kesehatan/detail_doula_page.dart';
import 'package:douce/features/user/kesehatan/detail_rumahsakit_page.dart';
import 'package:douce/features/user/main_user.dart';
import 'package:douce/features/user/obat/detail_obat_page.dart';
import 'package:douce/features/admin/login/admin_login_page.dart';
import 'package:douce/features/admin/dashboard/admin_dashboard_page.dart';
import 'package:douce/features/user/checklist/checklist_page.dart';
import 'package:douce/features/user/babynames/baby_names_page.dart';
import 'package:douce/features/user/birthplan/birth_plan_page.dart';
import 'package:douce/features/user/postpartum/postpartum_wellbeing_page.dart';
import 'package:douce/features/user/theme/theme_picker_page.dart';
import 'package:douce/features/user/diary/diary_list_page.dart';
import 'package:douce/features/user/diary/diary_form_page.dart';
import 'package:douce/features/user/diary/diary_detail_page.dart';
import 'package:douce/features/user/diary/diary_pdf_page.dart';
import 'package:douce/features/sop/sop_form_page.dart';
import 'package:douce/features/sop/sop_waiting_page.dart';
import 'package:douce/features/sop/sop_cs_message_page.dart';
import 'package:douce/features/user/sizeguide/sizeguide_page.dart';
import 'package:douce/features/user/ai_chat/ai_chat_page.dart';
import 'package:douce/features/onboarding/onboarding_page.dart';
import 'package:douce/features/pin/pin_entry_page.dart';
import 'package:douce/features/user/kesehatan/payment_success_page.dart';
import 'package:douce/features/user/pesanan/booking_detail_page.dart';
import 'package:douce/shared/theme/theme_service.dart';

class AppWidget extends StatelessWidget {
  final Bindings? initialBinding;

  const AppWidget({super.key, this.initialBinding});

  @override
  Widget build(BuildContext context) {  
    return GetMaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Momsie',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      initialBinding: BindingsBuilder(() {
        initialBinding?.dependencies();
        Get.put<ThemeService>(ThemeService(), permanent: true);
        Get.put<PinAuthService>(PinAuthService(), permanent: true);
      }),
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: AppRoutes.register,
          page: () => const RegisterPage(),
        ),
        GetPage(
          name: AppRoutes.registerSuccess,
          page: () => const SuccessRegisterPage(),
        ),
        GetPage(
          name: AppRoutes.verifyEmail,
          page: () => const VerifyEmailPage(),
        ),
        GetPage(
          name: AppRoutes.forgotPassword,
          page: () => const ForgotPasswordPage(),
        ),
        GetPage(
          name: AppRoutes.verificationForgot,
          page: () => const VerificationPage(),
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
          name: AppRoutes.mitraAkun,
          page: () => const MitraAkunPage(),
        ),
        GetPage(
          name: AppRoutes.mitraPendapatan,
          page: () => const MitraPendapatanPage(),
        ),
        GetPage(
          name: AppRoutes.mitraAturJadwal,
          page: () => const MitraAturJadwalPage(),
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
          name: AppRoutes.userAkun,
          page: () => const UserAkunPage(),
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
        ),
        GetPage(
          name: AppRoutes.detailRumahSakit,
          page: () => const DetailRumahSakitPage(),
        ),
        GetPage(
          name: AppRoutes.detailDoula,
          page: () => const DetailDoulaPage(),
        ),
        GetPage(
          name: AppRoutes.bookingDoula,
          page: () => const BookingDoulaPage(),
        ),
        GetPage(
          name: AppRoutes.confirmBooking,
          page: () => const ConfirmBookingPage(),
        ),
        GetPage(
          name: AppRoutes.chatPage,
          page: () => const ChatPage(),
        ),
        GetPage(
          name: AppRoutes.seeMore,
          page: () => const SeeMorePage(),
        ),
        GetPage(
          name: AppRoutes.userSearch,
          page: () => const UserSearchPage(),
        ),
        GetPage(
          name: AppRoutes.mitraRegister,
          page: () => const MitraRegisterPage(),
        ),
        GetPage(
          name: AppRoutes.userPesanan,
          page: () => const UserPesananPage(),
        ),
        GetPage(
          name: AppRoutes.confirmRegister,
          page: () => const ConfirmationRegisterPage(),
        ),
        GetPage(
          name: AppRoutes.adminLogin,
          page: () => const AdminLoginPage(),
        ),
        GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const AdminDashboardPage(),
        ),
        GetPage(
          name: AppRoutes.checklist,
          page: () => const ChecklistPage(),
        ),
        GetPage(
          name: AppRoutes.babyNames,
          page: () => const BabyNamesPage(),
        ),
        GetPage(
          name: AppRoutes.birthPlan,
          page: () => const BirthPlanPage(),
        ),
        GetPage(
          name: AppRoutes.postpartumWellbeing,
          page: () => const PostpartumWellbeingPage(),
        ),
        GetPage(
          name: AppRoutes.themePicker,
          page: () => const ThemePickerPage(),
        ),
        GetPage(
          name: AppRoutes.diary,
          page: () => const DiaryListPage(),
        ),
        GetPage(
          name: AppRoutes.diaryForm,
          page: () => const DiaryFormPage(),
        ),
        GetPage(
          name: AppRoutes.diaryDetail,
          page: () => const DiaryDetailPage(),
        ),
        GetPage(
          name: AppRoutes.diaryPdf,
          page: () => const DiaryPdfPage(),
        ),
        GetPage(
          name: AppRoutes.aiChat,
          page: () => const AiChatPage(),
        ),
        GetPage(
          name: AppRoutes.sizeGuide,
          page: () => const SizeGuidePage(),
        ),
        GetPage(
          name: AppRoutes.onboarding,
          page: () => const OnboardingPage(),
        ),
        GetPage(
          name: AppRoutes.sopForm,
          page: () => const SopFormPage(),
        ),
        GetPage(
          name: AppRoutes.sopWaiting,
          page: () => const SopWaitingPage(),
        ),
        GetPage(
          name: AppRoutes.sopCsMessage,
          page: () => const SopCsMessagePage(),
        ),
        GetPage(
          name: AppRoutes.pinEntry,
          page: () => const PinEntryPage(),
        ),
        GetPage(
          name: AppRoutes.paymentSuccess,
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            return PaymentSuccessPage(
              transactionId: args?['transactionId'] ?? '',
              bookingId: args?['bookingId'],
              nominal: args?['nominal'],
              layanan: args?['layanan'],
            );
          },
        ),
        GetPage(
          name: AppRoutes.bookingDetail,
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            return BookingDetailPage(
              bookingId: args?['bookingId'] ?? '',
            );
          },
        ),
      ],
      initialRoute: AppRoutes.splash,
    );
  }
}
