import 'dart:async';
import 'package:douce/app/app_routes.dart';
import 'package:douce/features/user/kesehatan/user_kesehatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/doula_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKesehatanPage extends StatefulWidget {
  const UserKesehatanPage({super.key});

  @override
  State<UserKesehatanPage> createState() => _UserKesehatanPageState();
}

class _UserKesehatanPageState extends State<UserKesehatanPage> {
  final PageController _carouselController = PageController();
  Timer? _carouselTimer;
  int _activeSlideIndex = 0;
  late UserKesehatanController controller;

  static const List<Map<String, String>> _promoBanners = [
    {
      'image': 'assets/images/promo_doula_1_chat.jpg',
      'title': 'Konsultasi Online via Chat',
    },
    {
      'image': 'assets/images/promo_doula_2_prenatal.jpg',
      'title': 'Kelas Online: Materi Prenatal',
    },
    {
      'image': 'assets/images/promo_doula_3_yoga.jpg',
      'title': 'Kelas Online: Prenatal Yoga',
    },
    {
      'image': 'assets/images/promo_doula_4_bundling.jpg',
      'title': 'Kelas Online: Bundling Edukasi & Yoga',
    },
    {
      'image': 'assets/images/promo_doula_5_fulljourney.jpg',
      'title': 'Full Journey Doula Care',
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserKesehatanController());

    // Auto-Play Carousel Promo Doula (Pergeseran Tenang & Nyaman setiap 6 detik)
    _carouselTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_activeSlideIndex + 1) % _promoBanners.length;
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
      searchHint: "Cari Doula...",
      onSearchChanged: controller.onSearch,
      childWidget: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _doulaColumn(context);
      }),
    );
  }

  /// Body Column Doula Page (4:3 Promo Carousel + Pesanan Card + Doula Grid)
  Widget _doulaColumn(BuildContext context) {
    final list = controller.searchValue.value.isEmpty
        ? controller.doulaList
        : controller.listFilteredDoula;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 16),

        // 4:3 Promo Carousel Banner (Visual Info Only)
        _buildPromoCarousel(context),

        const SizedBox(height: 20),

        // 2. Banner Cek Pesanan Saya & Status Aktif (Compact Sleek Size)
        InkWell(
          onTap: () => Get.toNamed('/user-pesanan'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF43F5E), Color(0xFFFB7185)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pesanan Saya & Status Aktif",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Cek status layanan Doula & riwayat transaksi",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. Section Title: Mitra Doula Terpercaya
        const Text(
          "Mitra Doula Terpercaya",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // 4. Doula Grid
        if (list.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "Tidak ada doula ditemukan",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          )
        else
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return DoulaContainer(doula: list[index]);
            },
          ),
        const SizedBox(height: 110),
      ],
    );
  }

  /// Carousel Banner Promo (Aspek Rasio 4:3 - Non-clickable Visual Info)
  Widget _buildPromoCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promo & Paket Spesial Doula",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // 4:3 AspectRatio PageView Container (Bebas Klik)
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: _carouselController,
                onPageChanged: (index) {
                  setState(() {
                    _activeSlideIndex = index;
                  });
                },
                itemCount: _promoBanners.length,
                itemBuilder: (context, index) {
                  final banner = _promoBanners[index];
                  return Image.asset(
                    banner['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: ColorDouce.veryLightPink,
                      child: Center(
                        child: Text(
                          banner['title']!,
                          style: TextStyle(
                            color: ColorDouce.douceBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Carousel Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (index) {
            final bool isActive = index == _activeSlideIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? ColorDouce.douceBase : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }
}
