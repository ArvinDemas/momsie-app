import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingModal extends StatelessWidget {
  const OnboardingModal({super.key});

  static Future<void> checkAndShow(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_onboarding_guide_v2') ?? false;

    if (!hasSeen && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const OnboardingModal(),
      );
      await prefs.setBool('has_seen_onboarding_guide_v2', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B8B).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                color: Color(0xFFFF6B8B),
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Selamat Datang di Momsie',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Platform Pendamping Kehamilan & Persalinan Digital Terpercaya Bunda Indonesia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _guideFeatureTile(
              icon: Icons.heart_broken_outlined,
              iconColor: const Color(0xFF10B981),
              title: 'Layanan Doula Door-to-Door',
              subtitle: 'Pesan pendamping persalinan profesional dan bersertifikasi langsung ke lokasi Bunda.',
            ),
            const SizedBox(height: 12),
            _guideFeatureTile(
              icon: Icons.forum_rounded,
              iconColor: const Color(0xFF0284C7),
              title: 'Momsie AI Chatbot 24/7',
              subtitle: 'Konsultasi keluhan kehamilan & rekomendasi nutrisi kapan saja bersama AI pintar.',
            ),
            const SizedBox(height: 12),
            _guideFeatureTile(
              icon: Icons.backpack_rounded,
              iconColor: const Color(0xFFF43F5E),
              title: 'Hospital Bag & Size Guide',
              subtitle: 'Pantau perkembangan ukuran janin minggu demi minggu & siapkan perlengkapan melahirkan.',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B8B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
                child: const Text(
                  'Mengerti, Jelajahi Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideFeatureTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
