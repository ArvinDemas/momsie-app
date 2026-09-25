import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:douce/shared/util/service/materi_access_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/yoga_streak_badge.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserDetailProgramPage extends StatefulWidget {
  const UserDetailProgramPage({super.key});

  @override
  State<UserDetailProgramPage> createState() => _UserDetailProgramPageState();
}

class _UserDetailProgramPageState extends State<UserDetailProgramPage> {
  bool _hasAccess = false;
  bool _isLoadingAccess = true;

  String _getLayananFromProgram(String programName) {
    final lower = programName.toLowerCase();
    if (lower.contains('materi') || lower.contains('bundling')) {
      return lower.contains('bundling') ? 'paket_bundling' : 'materi_online';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    final program = Get.arguments['program'] as ProgramModel;
    final UserController userController = Get.find<UserController>();
    final layanan = _getLayananFromProgram(program.name);

    if (layanan.isEmpty) {
      setState(() {
        _hasAccess = true;
        _isLoadingAccess = false;
      });
      return;
    }

    final hasAccess = await MateriAccessService().hasAccess(userController.uid.value, layanan);
    if (mounted) {
      setState(() {
        _hasAccess = hasAccess;
        _isLoadingAccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProgramModel program = Get.arguments['program'];
    final UserController userController = Get.find<UserController>();
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                Text(
                  "Detail Program",
                  style: AppTypography.h2,
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.roundedLg,
                    boxShadow: AppElevation.level1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Streak Yoga',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userController.yogaStreak.value == 0
                                  ? 'Yuk mulai sesi yoga hari ini!'
                                  : 'Rutinitas latihan terawat!',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppSemanticColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      YogaStreakBadge(streak: userController.yogaStreak.value),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            if (_isLoadingAccess)
              const Center(child: CircularProgressIndicator())
            else if (!_hasAccess)
              _buildAccessDeniedCard(program)
            else
              programKehamilanContainer(program),
            const SizedBox(height: 20),
            Text(
              "Deskripsi",
              style: AppTypography.h3,
            ),
            const SizedBox(height: 10),
            Text(
              program.desc,
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: 20),
            Text(
              "Program ${program.name}",
              style: AppTypography.h3,
            ),
            const SizedBox(height: 10),
            Column(
              children: program.months
                  .map((bulan) => monthContainer(bulan, program))
                  .toList(),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildAccessDeniedCard(ProgramModel program) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.roundedLg,
        boxShadow: AppElevation.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: AppSemanticColors.warning, size: 24),
              const SizedBox(width: 8),
              Text(
                "Program ${program.name}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: ColorDouce.douceBase,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Anda belum memiliki akses ke program ini. Silakan beli terlebih dahulu untuk mengakses materi.",
            style: AppTypography.bodyMd,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
            ),
            child: const Text(
              "Kembali",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget programKehamilanContainer(ProgramModel program) {
    final String yogaHeaderImage = (program.image.isNotEmpty && !program.image.contains('flowers'))
        ? program.image
        : 'assets/images/promo_doula_3_yoga.jpg';

    Widget buildHeaderImage() {
      if (yogaHeaderImage.startsWith('assets/')) {
        return Image.asset(
          yogaHeaderImage,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultHeaderFallback(),
        );
      }
      if (yogaHeaderImage.startsWith('http://') || yogaHeaderImage.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: yogaHeaderImage,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _defaultHeaderFallback(),
        );
      }
      return _defaultHeaderFallback();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Program ${program.name}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: ColorDouce.douceBase,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: buildHeaderImage(),
          )
        ],
      ),
    );
  }

  Widget _defaultHeaderFallback() {
    return Image.asset(
      'assets/images/promo_doula_3_yoga.jpg',
      width: 75,
      height: 75,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 75,
        height: 75,
        color: Colors.pink.shade50,
        child: Icon(Icons.self_improvement_rounded, size: 36, color: ColorDouce.douceBase),
      ),
    );
  }

  Widget monthContainer(Month bulan, ProgramModel program) {
    return InkWell(
      onTap: () => Get.toNamed('/user-program-bulan', arguments: {
        'month': bulan,
        'program': program,
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bulan ke - ${bulan.month}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
