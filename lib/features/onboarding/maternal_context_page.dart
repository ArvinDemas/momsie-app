import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaternalContextPage extends StatefulWidget {
  const MaternalContextPage({super.key});

  @override
  State<MaternalContextPage> createState() => _MaternalContextPageState();
}

class _MaternalContextPageState extends State<MaternalContextPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;
  int _currentStep = 0;
  final List<String> _roles = [
    'Ibu Hamil / Bunda',
    'Ayah / Suami',
    'Keluarga / Pendamping',
  ];
  final List<String> _pregnancyStages = [
    'Belum Hamil (Merencanakan)',
    'Trimester 1 (1-13 Minggu)',
    'Trimester 2 (14-27 Minggu)',
    'Trimester 3 (28-40 Minggu)',
    'Sudah Lahir',
  ];
  final List<String> _babySexOptions = ['Laki-laki', 'Perempuan', 'Belum Tahu'];

  String? _selectedRole;
  String? _selectedStage;
  String? _selectedBabySex;
  final TextEditingController _babyNameController = TextEditingController();
  String? _selectedAgeGroup;
  final List<String> _ageGroups = ['20-25', '26-30', '31-35', '36-40', '41+'];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: AppAnimation.normal);
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _babyNameController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (_selectedRole == null || _selectedStage == null) return;
    setState(() {});

    final prefs = await SharedPreferences.getInstance();
    final userController = Get.find<UserController>();

    await prefs.setString('onboarded_role', _selectedRole ?? '');
    await prefs.setString('onboarded_stage', _selectedStage ?? '');
    await prefs.setString('onboarded_baby_sex', _selectedBabySex ?? '');
    await prefs.setString('onboarded_baby_name', _babyNameController.text.trim());
    await prefs.setString('onboarded_age_group', _selectedAgeGroup ?? '');

    userController.updateRelationship(_selectedRole!);
    await userController.updatePregnancyStage(
      _selectedStage!.contains('Trimester 1')
          ? 'trimester1'
          : _selectedStage!.contains('Trimester 2')
              ? 'trimester2'
              : _selectedStage!.contains('Trimester 3')
                  ? 'trimester3'
                  : 'none',
    );
    await userController.setMaternalContextComplete();



    if (mounted) {
      Get.offAllNamed('/user');
    }
  }

  void _skip() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('has_completed_maternal_context', true);
    if (mounted) {
      Get.offAllNamed('/user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Lewati',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppSemanticColors.textMuted,
                    ),
                  ),
                ),
              ),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedContainer(
                    duration: AppAnimation.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: _currentStep >= index ? 20 : 6,
                    decoration: BoxDecoration(
                      color: _currentStep >= index
                          ? ColorDouce.douceBase
                          : Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Step content with animation
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    textDirection: TextDirection.ltr,
                    position: Tween<Offset>(
                      begin: const Offset(0.15, 0.0),
                      end: Offset.zero,
                    ).animate(_slideAnim),
                    child: _buildStepContent(),
                  ),
                ),
              ),

              // Bottom action area
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _currentStep < 4 ? _nextStep : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorDouce.douceBase,
                          elevation: 4,
                          shadowColor:
                              ColorDouce.douceBase.withValues(alpha: 0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.roundedFull,
                          ),
                        ),
                        child: Text(
                          _currentStep < 4 ? 'Lanjut' : 'Mulai Perjalanan Bersama',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Lewati & Masuk Beranda',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppSemanticColors.textMuted,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _StepQuestion(
          icon: Icons.person_rounded,
          iconColor: ColorDouce.douceBase,
          title: 'Siapa yang menggunakan Momsie?',
          subtitle: 'Kami ingin menyesuaikan pengalaman untuk kamu.',
          children: _roles.map((role) => _OptionCard(
            label: role,
            icon: role.contains('Ibu')
                ? Icons.female_rounded
                : role.contains('Ayah')
                    ? Icons.male_rounded
                    : Icons.family_restroom_rounded,
            isSelected: _selectedRole == role,
            onTap: () => setState(() => _selectedRole = role),
          )).toList(),
        );
      case 1:
        return _StepQuestion(
          icon: Icons.calendar_today_rounded,
          iconColor: const Color(0xFF0D9488),
          title: 'Di tahap kehamilan apa kamu?',
          subtitle: 'Ini membantu kami memberikan konten yang sesuai.',
          children: _pregnancyStages.map((stage) => _OptionCard(
            label: stage,
            icon: stage.contains('Belum')
                ? Icons.eco_rounded
                : stage.contains('Trimester')
                    ? Icons.favorite_rounded
                    : Icons.child_care_rounded,
            isSelected: _selectedStage == stage,
            onTap: () => setState(() => _selectedStage = stage),
          )).toList(),
        );
      case 2:
        return _StepQuestion(
          icon: Icons.cake_rounded,
          iconColor: const Color(0xFFF43F5E),
          title: 'Berapa usia bunda?',
          subtitle: 'Untuk rekomendasi yang lebih personal.',
          children: _ageGroups.map((age) => _OptionCard(
            label: '$age tahun',
            icon: Icons.numbers_rounded,
            isSelected: _selectedAgeGroup == age,
            onTap: () => setState(() => _selectedAgeGroup = age),
          )).toList(),
        );
      case 3:
        return _StepQuestion(
          icon: Icons.male_rounded,
          iconColor: const Color(0xFF3B82F6),
          title: 'Apakah sudah tahu jenis kelamin bayinya?',
          subtitle: 'Opsional — kamu bisa melewati ini.',
          children: _babySexOptions.map((sex) => _OptionCard(
            label: sex,
            icon: sex == 'Laki-laki'
                ? Icons.male_rounded
                : sex == 'Perempuan'
                    ? Icons.female_rounded
                    : Icons.visibility_off_rounded,
            isSelected: _selectedBabySex == sex,
            onTap: () => setState(() => _selectedBabySex = sex),
          )).toList(),
        );
      case 4:
        return _StepQuestion(
          icon: Icons.kitchen_rounded,
          iconColor: const Color(0xFFD97706),
          title: 'Sudah punya nama untuk baby?',
          subtitle: 'Kalau belum, nanti bisa diisi di Profil.',
          children: [
            TextField(
              controller: _babyNameController,
              decoration: InputDecoration(
                hintText: 'Ketik nama bayi...',
                hintStyle: TextStyle(color: AppSemanticColors.textMuted),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedLg,
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.roundedLg,
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.roundedLg,
                  borderSide: BorderSide(color: ColorDouce.douceBase, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            const SizedBox(height: 12),
            _OptionCard(
              label: 'Belum punya nama',
              icon: Icons.auto_awesome_rounded,
              isSelected: _babyNameController.text.trim().isEmpty,
              onTap: () {
                setState(() {
                  _babyNameController.clear();
                  _selectedBabySex = _selectedBabySex;
                });
              },
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _animCtrl.reset();
      _animCtrl.forward();
    } else {
      _saveAndContinue();
    }
  }
}

class _StepQuestion extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _StepQuestion({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon circle
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 36, color: iconColor),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppSemanticColors.textDarkSecondary,
            height: 1.25,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppSemanticColors.textSecondary,
            height: 1.5,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        const SizedBox(height: 32),

        // Options
        ...children,
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.roundedLg,
          child: AnimatedContainer(
            duration: AppAnimation.fast,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorDouce.douceBase.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: AppRadius.roundedLg,
              border: Border.all(
                color: isSelected
                    ? ColorDouce.douceBase
                    : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? AppElevation.softColor(ColorDouce.douceBase)
                  : AppElevation.level1,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorDouce.douceBase.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? ColorDouce.douceBase
                        : AppSemanticColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? ColorDouce.douceBase
                          : AppSemanticColors.textDarkSecondary,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: ColorDouce.douceBase,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
