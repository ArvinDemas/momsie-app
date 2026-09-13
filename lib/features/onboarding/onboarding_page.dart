import 'dart:math' as math;
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSlide {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String tag;
  final IconData tagIcon;

  OnboardingSlide({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagIcon,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCtrl;
  late final AnimationController _floatAnimCtrl;
  int _currentIndex = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      imageAsset: 'assets/images/onboarding_3d_1.png',
      title: 'Pantau Janin & Kebahagiaan Bunda',
      subtitle:
          'Dapatkan panduan mingguan perkembangan janin, estimasi HPL, serta gambaran ukuran buah hati dengan tampilan 3D yang hangat.',
      tag: 'TUMBUH KEMBANG',
      tagIcon: Icons.child_care_rounded,
    ),
    OnboardingSlide(
      imageAsset: 'assets/images/onboarding_3d_2.png',
      title: 'Pendampingan Doula Profesional',
      subtitle:
          'Dapatkan pendampingan langsung oleh Mitra Doula berpengalaman selama masa kehamilan hingga persalinan secara praktis dan fleksibel.',
      tag: 'LAYANAN DOULA',
      tagIcon: Icons.favorite_rounded,
    ),
    OnboardingSlide(
      imageAsset: 'assets/images/onboarding_3d_3.png',
      title: 'Diary Kehamilan & Album PDF',
      subtitle:
          'Abadikan setiap momen indah kehamilan dalam diary digital dan cetak Album PDF kenangan berharga untuk keluarga.',
      tag: 'MEMORI BERHARGA',
      tagIcon: Icons.auto_stories_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _floatAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _floatAnimCtrl.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    Get.offAllNamed('/login');
  }

  void _nextPage() {
    if (_currentIndex < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: Stack(
        children: [
          // Background Soft Decorative Circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorDouce.lightPink.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorDouce.douceBase.withValues(alpha: 0.12),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Header (Logo & Skip Button)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/logo.png', height: 28),
                          const SizedBox(width: 8),
                          Text(
                            'momsie',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorDouce.douceBase,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          'Lewati',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Carousel Slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Gentle Floating 3D Animated Illustration
                            AnimatedBuilder(
                              animation: _floatAnimCtrl,
                              builder: (context, child) {
                                final floatY = math.sin(
                                        _floatAnimCtrl.value * 2 * math.pi) *
                                    8.0;
                                return Transform.translate(
                                  offset: Offset(0, floatY),
                                  child: child,
                                );
                              },
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorDouce.douceBase
                                          .withValues(alpha: 0.15),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Image.asset(
                                    slide.imageAsset,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.pink.shade50,
                                      child: Icon(
                                        slide.tagIcon,
                                        size: 80,
                                        color: ColorDouce.douceBase,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Tag Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: ColorDouce.douceBase
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    slide.tagIcon,
                                    size: 14,
                                    color: ColorDouce.douceBase,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    slide.tag,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: ColorDouce.douceBase,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Title
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textDarkSecondary,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subtitle
                            Text(
                              slide.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Navigation Area (Indicators & Button)
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
                  child: Column(
                    children: [
                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentIndex == index ? 28 : 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? ColorDouce.douceBase
                                  : Colors.pink.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorDouce.douceBase,
                            elevation: 4,
                            shadowColor:
                                ColorDouce.douceBase.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentIndex == _slides.length - 1
                                    ? 'Mulai Sekarang'
                                    : 'Lanjut',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
