import 'package:douce/features/user/eksplor/user_eksplor_controller.dart';
import 'package:douce/shared/util/model/artikel_model.dart';
import 'package:douce/shared/util/service/artikel_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/artikel_container.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/widget/base_page.dart';
import 'package:douce/shared/widget/rumah_sakit_container.dart';
import 'package:douce/shared/widget/tokobayi_container.dart';
import 'package:douce/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEksplorPage extends StatelessWidget {
  const UserEksplorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEksplorController controller =
        Get.put(UserEksplorController());

    return BasePage(
      onAvatarTap: () {
        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController());
        }
        Get.toNamed(AppRoutes.userAkun);
      },
      searchHint: 'Cari Toko, Artikel, atau Rumah Sakit...',
      onSearchChanged: controller.onSearch,
      childWidget: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            const SizedBox(height: 16),
            // ══════════ Toko Bayi Section ══════════
            _tokoBayiSection(controller),
            const SizedBox(height: 28),

            // ══════════ Artikel Edukasi Section ══════════
            _artikelSection(context),
            const SizedBox(height: 28),

            // ══════════ Rumah Sakit Section ══════════
            _rumahSakitSection(controller),
          ],
        );
      }),
    );
  }

  Widget _tokoBayiSection(UserEksplorController controller) {
    final list = controller.searchValue.value.isEmpty
        ? controller.tokoBayiList
        : controller.filteredTokoBayi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            'Toko Bayi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppSemanticColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tidak ada toko bayi ditemukan',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200,
                  child: TokoBayiContainer(tokoBayi: list[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _artikelSection(BuildContext context) {
    return FutureBuilder<List<ArtikelModel>>(
      future: ArtikelService().getArtikel(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final artikels = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Artikel & Panduan Edukasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppSemanticColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: artikels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 280,
                    child: ArtikelContainer(artikel: artikels[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _rumahSakitSection(UserEksplorController controller) {
    final list = controller.searchValue.value.isEmpty
        ? controller.rumahSakitList
        : controller.filteredRumahSakit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            'Rumah Sakit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppSemanticColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tidak ada rumah sakit ditemukan',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return RumahSakitContainer(rumahSakit: list[index]);
            },
          ),
      ],
    );
  }
}
