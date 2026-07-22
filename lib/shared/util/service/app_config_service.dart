import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

/// Service untuk membaca feature flags dari Firestore.
///
/// Cara pakai di Firebase Console:
/// Buat collection: config
/// Buat document:   app_settings
/// Tambahkan field boolean:
///   - showPaymentFlow  (true/false) -> kontrol halaman transfer OVO
///   - showBookingFlow  (true/false) -> kontrol booking doula
///
/// Default: jika document tidak ada, semua flag = true (aktif normal).
/// Untuk review Google Play, set showPaymentFlow = false.
class AppConfigService extends GetxController {
  final RxBool showPaymentFlow = true.obs;
  final RxBool showBookingFlow = true.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConfig();
  }

  Future<void> loadConfig() async {
    isLoading.value = true;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('app_settings')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        showPaymentFlow.value = data['showPaymentFlow'] ?? true;
        showBookingFlow.value = data['showBookingFlow'] ?? true;
      }
    } catch (e) {
      // Jika gagal baca config, gunakan default (semua aktif)
      showPaymentFlow.value = true;
      showBookingFlow.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
