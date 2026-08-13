import 'package:douce/features/user/beranda/user_beranda_controller.dart';
import 'package:douce/features/user/sizeguide/sizeguide_card.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/feedback_dialog.dart';
import 'package:douce/shared/widget/onboarding_modal.dart';
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
  int _activeSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OnboardingModal.checkAndShow(context);
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserBerandaController controller = Get.put(UserBerandaController());

    return BasePage(
      childWidget: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 16),

          // ── 1. Top 3D Carousel Banner (Apple Aesthetic) ─────────────
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

                const SizedBox(height: 28),

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
                Obx(
                  () => controller.isTokoBayiLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 16,
                            children: controller
                                .getRandomTokoBayi()
                                .map(
                                  (tokoBayi) => TokoBayiContainer(
                                    tokoBayi: tokoBayi,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),

                const SizedBox(height: 28),

                // ── 5. Artikel Terkini ─────────────────────────────────
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
                Obx(
                  () => controller.isArtikelLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.getRandomArtikel().length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final artikel = controller.getRandomArtikel()[index];
                            return _buildArtikelTile(artikel);
                          },
                        ),
                ),
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
        'cta': 'Pesan Doula Now',
        'gradient': const [Color(0xFFF43F5E), Color(0xFFFB7185)],
        'icon': Icons.medical_services_rounded,
        'action': () => Get.toNamed('/booking-doula'),
      },
      {
        'title': 'Momsie AI Assistant 24/7',
        'subtitle': 'Konsultasikan keluhan kehamilan & nutrisi kapan saja bersama AI',
        'cta': 'Tanya AI Sekarang',
        'gradient': const [Color(0xFF0284C7), Color(0xFF38BDF8)],
        'icon': Icons.smart_toy_rounded,
        'action': () => Get.toNamed('/ai-chat'),
      },
      {
        'title': 'Hospital Bag & Birth Plan',
        'subtitle': 'Checklist perlengkapan bersalin lengkap untuk Ibu, Bayi, & Pendamping',
        'cta': 'Cek Checklist',
        'gradient': const [Color(0xFF7C3AED), Color(0xFFC084FC)],
        'icon': Icons.backpack_rounded,
        'action': () => Get.toNamed('/checklist'),
      },
      {
        'title': 'Toko Bayi & Faskes Terdekat',
        'subtitle': 'Temukan lokasi toko perlengkapan bayi & RSIA terpercaya di Jogja',
        'cta': 'Cari Lokasi',
        'gradient': const [Color(0xFFE11D48), Color(0xFFFDA4AF)],
        'icon': Icons.storefront_rounded,
        'action': () => Get.toNamed('/user-search'),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: slide['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (slide['gradient'][0] as Color).withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
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
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['subtitle'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white90,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // WCAG AAA Pristine White Pill Button (17.85:1 Contrast)
                          InkWell(
                            onTap: slide['action'] as VoidCallback,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    slide['cta'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Color(0xFF0F172A),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        slide['icon'] as IconData,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ],
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
                onTap: () => Get.toNamed('/checklist'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bentoCard(
                title: 'Birth Plan',
                subtitle: 'Rencana Persalinan',
                icon: Icons.description_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () => Get.toNamed('/birth-plan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Diary & Nama Bayi
        Row(
          children: [
            Expanded(
              child: _bentoCard(
                title: 'Diary Hamil',
                subtitle: 'Jurnal Kehamilan',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFFF97316),
                onTap: () => Get.toNamed('/diary'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bentoCard(
                title: 'Nama Bayi',
                subtitle: 'Inspirasi Nama',
                icon: Icons.auto_awesome_rounded,
                color: const Color(0xFF06B6D4),
                onTap: () => Get.toNamed('/baby-names'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3: Full Width AI Chatbot
        _bentoCardWide(
          title: 'Momsie AI Chatbot Assistant 24/7',
          subtitle: 'Tanya keluhan kehamilan & rekomendasi medis instan',
          icon: Icons.smart_toy_rounded,
          color: const Color(0xFF0284C7),
          onTap: () => Get.toNamed('/ai-chat'),
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
                color: Colors.slate,
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
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
                      color: Colors.white90,
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

  Widget _buildArtikelTile(ArtikelModel artikel) {
    return InkWell(
      onTap: () => Get.toNamed("/user-artikel", arguments: artikel),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                artikel.thumbnail,
                width: 90,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 75,
                  color: Colors.grey[200],
                  child: const Icon(Icons.article_rounded, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        artikel.pubDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
