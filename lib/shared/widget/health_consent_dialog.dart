import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget dialog persetujuan pengumpulan data kesehatan.
/// Hanya muncul sekali saat pertama kali pengguna login/register.
/// Simpan status persetujuan di SharedPreferences dengan key 'health_consent_given'.
class HealthConsentDialog extends StatelessWidget {
  /// Callback dipanggil saat pengguna menekan "Saya Setuju"
  final VoidCallback onConsented;

  const HealthConsentDialog({super.key, required this.onConsented});

  /// Cek apakah pengguna sudah pernah memberikan consent.
  static Future<bool> isConsentGiven() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('health_consent_given') ?? false;
  }

  /// Tampilkan dialog jika belum pernah ada consent.
  /// [context] BuildContext untuk menampilkan dialog.
  /// [onConsented] callback yang dipanggil setelah pengguna setuju.
  static Future<void> showIfNeeded(
    BuildContext context, {
    required VoidCallback onConsented,
  }) async {
    final alreadyConsented = await isConsentGiven();
    if (!alreadyConsented && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => HealthConsentDialog(onConsented: onConsented),
      );
    } else {
      onConsented();
    }
  }

  Future<void> _onAgree() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_consent_given', true);
    Get.back();
    onConsented();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.health_and_safety, color: ColorDouce.douceBase),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "Persetujuan Penggunaan Data",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sebelum melanjutkan, mohon baca dan setujui ketentuan berikut:",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 16),
              _ConsentItem(
                icon: Icons.info_outline,
                text:
                    "Informasi kesehatan dalam aplikasi ini bersifat EDUKATIF dan bukan pengganti saran medis profesional.",
              ),
              _ConsentItem(
                icon: Icons.data_usage,
                text:
                    "Kami akan mengumpulkan data kesehatan Anda (seperti riwayat program kehamilan) untuk meningkatkan pengalaman penggunaan aplikasi.",
              ),
              _ConsentItem(
                icon: Icons.lock_outline,
                text:
                    "Data Anda disimpan secara aman dan tidak akan dijual kepada pihak ketiga.",
              ),
              _ConsentItem(
                icon: Icons.location_on_outlined,
                text:
                    "Kami mengakses lokasi Anda (hanya saat aplikasi aktif) untuk menampilkan fasilitas kesehatan terdekat.",
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Get.toNamed('/user-kebijakan-privasi'),
                child: Text(
                  "Baca Kebijakan Privasi lengkap →",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorDouce.douceBase,
                    fontFamily: 'OpenSans',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onAgree,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Saya Setuju & Lanjutkan",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ConsentItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontFamily: 'OpenSans',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
