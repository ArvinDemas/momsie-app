import 'dart:async';
import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/features/user/main_user.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/features/user/sizeguide/sizeguide_card.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/widget/feedback_dialog.dart';
import 'package:douce/shared/widget/onboarding_modal.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/widget/tokobayi_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBerandaPage extends StatefulWidget {
  const UserBerandaPage({
    super.key,
    required this.changeNavigation,
  });

  final Function(String) changeNavigation;

  @override
  State<UserBerandaPage> createState() => _UserBerandaPageState();
}

class _UserBerandaPageState extends State<UserBerandaPage> {
  final PageController _carouselController = PageController();
  Timer? _carouselTimer;
  int _activeSlideIndex = 0;
  late UserBerandaController controller;

  @override
  void initState() {
    super.initState();
    // Controller sudah di-register permanent di main_user.dart, cukup Get.find()
    controller = Get.find<UserBerandaController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      OnboardingModal.checkAndShow(context);
    });

    // Auto-Play Carousel Banner (Pergeseran Otomatis setiap 6 detik agar lebih tenang & nyaman)
    _carouselTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_activeSlideIndex + 1) % 4;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Memory Leak Guardrail: Pembatalan Timer.periodic secara eksplisit saat dispose
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BasePage(
      onAvatarTap: () {
        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController());
        }
        Get.toNamed(AppRoutes.userAkun);
      },
      childWidget: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 16),

          // ── 1. Top 3D Carousel Banner (Apple Aesthetic + Auto-Play) ──
          _buildBannerCarousel(),

          const SizedBox(height: 20),

          // ── 2. Size Guide Card (Ukuran Bayi Minggu Ini) ─────────────
          const SizeGuideCard(),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section Title ─────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Layanan & Fitur Utama",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () => FeedbackDialog.show(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B8B).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star_rate_rounded, size: 14, color: Color(0xFFFF6B8B)),
                            SizedBox(width: 4),
                            Text(
                              "Ulasan",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B8B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── 3. Apple Bento Grid Layout (Bebas Emoji) ──────────
                _buildBentoGrid(),

                const SizedBox(height: 36),

                // ── 4. Toko Perlengkapan Bayi Jogja ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pusat Perlengkapan Bayi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: controller.isTokoBayiLoading.value
                            ? () {}
                            : () {
                                Get.toNamed(
                                  '/see-more',
                                  arguments: {
                                    'title': 'Toko Bayi',
                                    'tokoBayi': controller.tokoBayiList,
                                  },
                                );
                              },
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 14),
                // Horizontal scroll toko bayi — width card bounded 300px
                Obx(() {
                  if (controller.isTokoBayiLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tokos = controller.getRandomTokoBayi();
                  if (tokos.isEmpty) return const SizedBox();
                  return SizedBox(
                    height: 270,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: tokos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 300,
                          child: TokoBayiContainer(tokoBayi: tokos[index]),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 28),

                // ── 5. Artikel Terkini ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edukasi & Artikel Terkini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: controller.isArtikelLoading.value
                            ? () {}
                            : () {
                                Get.toNamed(
                                  '/see-more',
                                  arguments: {
                                    'title': 'Artikel',
                                    'artikel': controller.artikelList,
                                  },
                                );
                              },
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorDouce.douceBase,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Cache list artikel SEKALI agar tidak di-shuffle 2x oleh itemCount + itemBuilder
                Obx(() {
                  if (controller.isArtikelLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final artikels = controller.getRandomArtikel();
                  if (artikels.isEmpty) return const SizedBox();
                  // Bangun grid secara manual dengan Row berpasangan
                  // (menghindari GridView shrinkWrap di dalam ListView yang menyebabkan lag)
                  final rows = <Widget>[];
                  for (int i = 0; i < artikels.length; i += 2) {
                    final hasSecond = i + 1 < artikels.length;
                    rows.add(
                      Row(
                        children: [
                          Expanded(child: ArtikelContainer(artikel: artikels[i])),
                          const SizedBox(width: 14),
                          hasSecond
                              ? Expanded(child: ArtikelContainer(artikel: artikels[i + 1]))
                              : const Expanded(child: SizedBox()),
                        ],
                      ),
                    );
                    if (i + 2 < artikels.length) rows.add(const SizedBox(height: 16));
                  }
                  return Column(children: rows);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ── Top 3D Carousel Banner Component ─────────────────────────────────────
  Widget _buildBannerCarousel() {
    final List<Map<String, dynamic>> slides = [
      {
        'title': 'Pendamping Persalinan Professional',
        'subtitle': 'Pesan Doula Bersertifikat Door-to-Door langsung ke lokasi Bunda',
        'cta': 'Momsie Ecosystem',
        'image': 'assets/images/banner_doula.jpg',
        'gradient': const [Color(0xFFF43F5E), Color(0xFFFB7185)],
        'icon': Icons.medical_services_rounded,
        'action': () {
          if (!Get.isRegistered<MainUserController>()) {
            Get.put(MainUserController());
          }
          Get.find<MainUserController>().switchTab(1);
        },
      },
      {
        'title': 'Momsie AI Assistant 24/7',
        'subtitle': 'Konsultasikan keluhan kehamilan & nutrisi kapan saja bersama AI',
        'cta': 'Tanya AI',
        'image': 'assets/images/banner_ai.jpg',
        'gradient': const [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFF43F5E)],
        'icon': Icons.smart_toy_rounded,
        'action': () => Get.toNamed(AppRoutes.aiChat),
      },
      {
        'title': 'Hospital Bag Checklist',
        'subtitle': 'Checklist perlengkapan bersalin lengkap untuk Ibu & Si Kecil',
        'cta': 'Cek Tas Bersalin',
        'image': 'assets/images/banner_hospital_bag.jpg',
        'gradient': const [Color(0xFF7C3AED), Color(0xFFC084FC)],
        'icon': Icons.backpack_rounded,
        'action': () => Get.toNamed(AppRoutes.checklist),
      },
      {
        'title': 'Birth Plan Rencana Persalinan',
        'subtitle': 'Susun keinginan persalinan nyaman & aman bersama Bidan/Dokter',
        'cta': 'Buat Birth Plan',
        'image': 'assets/images/banner_birth_plan.jpg',
        'gradient': const [Color(0xFF0D9488), Color(0xFF2DD4BF)],
        'icon': Icons.assignment_rounded,
        'action': () => Get.toNamed(AppRoutes.checklist),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) => setState(() => _activeSlideIndex = index),
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (slide['gradient'][0] as Color).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: slide['action'] as VoidCallback,
                    child: Image.asset(
                      slide['image'] as String,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: slide['gradient'] as List<Color>,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slide['title'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      slide['subtitle'] as String,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (index) {
            final isActive = index == _activeSlideIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? ColorDouce.douceBase : Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Apple Bento Grid Layout Component ─────────────────────────────────────
  Widget _buildBentoGrid() {
    return Column(
      children: [
        // Row 1: Hospital Bag & Birth Plan
        Row(
          children: [
            Expanded(
              child: _bentoCard(
                title: 'Hospital Bag',
                subtitle: 'Checklist Bersalin',
                icon: Icons.backpack_rounded,
                color: const Color(0xFFF43F5E),
                onTap: () => Get.toNamed(AppRoutes.checklist),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bentoCard(
                title: 'Birth Plan',
                subtitle: 'Rencana Persalinan',
                icon: Icons.description_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () => Get.toNamed(AppRoutes.birthPlan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Diary & Postpartum Wellbeing
        Row(
          children: [
            Expanded(
              child: _bentoCard(
                title: 'Diary Hamil',
                subtitle: 'Jurnal Kehamilan',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFFF97316),
                onTap: () => Get.toNamed(AppRoutes.diary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bentoCard(
                title: 'Postpartum',
                subtitle: 'Pemulihan Nifas',
                icon: Icons.favorite_rounded,
                color: const Color(0xFFEC4899),
                onTap: () => Get.toNamed(AppRoutes.postpartumWellbeing),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3: Nama Bayi
        Row(
          children: [
            Expanded(
              child: _bentoCard(
                title: 'Nama Bayi',
                subtitle: 'Inspirasi Nama Islami & Modern',
                icon: Icons.auto_awesome_rounded,
                color: const Color(0xFF06B6D4),
                onTap: () => Get.toNamed(AppRoutes.babyNames),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 4: Full Width AI Chatbot (Gemini Dynamic Gradient)
        _bentoCardWide(
          title: 'Momsie AI Chatbot Assistant 24/7',
          subtitle: 'Tanya keluhan kehamilan & rekomendasi medis instan',
          icon: Icons.smart_toy_rounded,
          colorsList: const [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFF43F5E)],
          onTap: () => Get.toNamed(AppRoutes.aiChat),
        ),
      ],
    );
  }

  Widget _bentoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 14),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bentoCardWide({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colorsList,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorsList,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorsList.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

}

