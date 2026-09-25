import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpotlightStep {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const SpotlightStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

/// Pop-up Modal Onboarding Tour
/// Menggantikan spotlight cutout dengan modal pop-up yang bersih, elegan, dan bebas glitch visual.
class SpotlightTourOverlay extends StatefulWidget {
  final List<SpotlightStep> steps;
  final VoidCallback onComplete;
  final VoidCallback? onDismiss;
  final Widget? targetWidget;
  final Offset? targetOffset;
  final Size? targetSize;

  const SpotlightTourOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
    this.onDismiss,
    this.targetWidget,
    this.targetOffset,
    this.targetSize,
  });

  @override
  State<SpotlightTourOverlay> createState() => _SpotlightTourOverlayState();

  static Future<void> showOnce({
    required BuildContext context,
    required List<SpotlightStep> steps,
    GlobalKey? targetKey,
    required String prefsKey,
    required VoidCallback onComplete,
    VoidCallback? onDismiss,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(prefsKey) ?? false;
    if (hasSeen || !context.mounted) return;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Onboarding',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => SpotlightTourOverlay(
        steps: steps,
        onComplete: () async {
          await prefs.setBool(prefsKey, true);
          if (ctx.mounted) Navigator.of(ctx).pop();
          onComplete();
        },
        onDismiss: () async {
          await prefs.setBool(prefsKey, true);
          if (ctx.mounted) Navigator.of(ctx).pop();
          onDismiss?.call();
        },
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  /// Utility untuk mereset status tour agar bisa diuji ulang
  static Future<void> resetTour(String prefsKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsKey);
  }
}

class _SpotlightTourOverlayState extends State<SpotlightTourOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  SpotlightStep get _step => widget.steps[_currentStep];

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
      _animCtrl.reset();
      _animCtrl.forward();
    } else {
      widget.onComplete();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _animCtrl.reset();
      _animCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLastStep = _currentStep == widget.steps.length - 1;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: (screenSize.width - 48).clamp(280.0, 400.0),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header Row: Tag Badge & Close Button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorDouce.douceBase.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 13, color: ColorDouce.douceBase),
                        const SizedBox(width: 4),
                        Text(
                          'Panduan Fitur',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ColorDouce.douceBase,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppSemanticColors.textMuted,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 18,
                    onPressed: () {
                      if (widget.onDismiss != null) {
                        widget.onDismiss!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Step Content with Fade Transition ──
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Circle
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _step.iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_step.icon, size: 30, color: _step.iconColor),
                    ),
                    const SizedBox(height: 14),

                    // Step counter
                    Text(
                      'Langkah ${_currentStep + 1} dari ${widget.steps.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppSemanticColors.textMuted,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      _step.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppSemanticColors.textDarkSecondary,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      _step.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppSemanticColors.textSecondary,
                        height: 1.45,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Dot Indicators ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.steps.length, (index) {
                  final isActive = index == _currentStep;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: isActive ? 22 : 6,
                    decoration: BoxDecoration(
                      color: isActive ? ColorDouce.douceBase : Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),

              // ── Buttons Row ──
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppSemanticColors.textSecondary,
                            fontFamily: AppTypography.fontFamily,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLastStep ? widget.onComplete : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        elevation: 2,
                        shadowColor: ColorDouce.douceBase.withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isLastStep ? 'Selesai' : 'Lanjut',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
