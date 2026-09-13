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

class SpotlightTourOverlay extends StatefulWidget {
  final List<SpotlightStep> steps;
  final Widget targetWidget;
  final Offset targetOffset;
  final Size targetSize;
  final VoidCallback onComplete;
  final VoidCallback? onDismiss;

  const SpotlightTourOverlay({
    super.key,
    required this.steps,
    required this.targetWidget,
    required this.targetOffset,
    required this.targetSize,
    required this.onComplete,
    this.onDismiss,
  });

  @override
  State<SpotlightTourOverlay> createState() => _SpotlightTourOverlayState();

  static Future<void> showOnce({
    required BuildContext context,
    required List<SpotlightStep> steps,
    required GlobalKey targetKey,
    required String prefsKey,
    required VoidCallback onComplete,
    VoidCallback? onDismiss,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(prefsKey) ?? false;
    if (hasSeen || !context.mounted) return;

    final renderObject = targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      await prefs.setBool(prefsKey, true);
      return;
    }

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;

    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, anim1, __) => SpotlightTourOverlay(
          steps: steps,
          targetWidget: const _PlaceholderTarget(),
          targetOffset: offset,
          targetSize: size,
          onComplete: onComplete,
          onDismiss: onDismiss,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
      ),
    );
  }
}

class _PlaceholderTarget extends StatelessWidget {
  const _PlaceholderTarget({super.key});

  @override
  Widget build(BuildContext context) => Container();
}

class _SpotlightTourOverlayState extends State<SpotlightTourOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: AppAnimation.normal);
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
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
    final clampedRect = Rect.fromLTWH(
      widget.targetOffset.dx.clamp(0.0, screenSize.width),
      widget.targetOffset.dy.clamp(0.0, screenSize.height),
      widget.targetSize.width.clamp(0.0, screenSize.width),
      widget.targetSize.height.clamp(0.0, screenSize.height),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomPaint(
            size: screenSize,
            painter: _SpotlightCutoutPainter(
              rect: clampedRect,
              radius: 20.0,
              overlayColor: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          Positioned(
            left: clampedRect.left,
            top: clampedRect.top,
            width: clampedRect.width,
            height: clampedRect.height,
            child: widget.targetWidget,
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: AnimatedBuilder(
              animation: _fadeAnim,
              builder: (context, child) => FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(_animCtrl),
                  child: child,
                ),
              ),
              child: _SpotlightCard(
                step: _step,
                currentStep: _currentStep,
                totalSteps: widget.steps.length,
                cardWidth: screenSize.width - 40,
                onPrev: _currentStep > 0 ? _prevStep : null,
                onNext: _nextStep,
                onComplete: widget.onComplete,
                onDismiss: widget.onDismiss,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightCutoutPainter extends CustomPainter {
  final Rect rect;
  final double radius;
  final Color overlayColor;

  _SpotlightCutoutPainter({
    required this.rect,
    required this.radius,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRRect(RRect.fromLTRBXY(
        rect.left, rect.top, rect.right, rect.bottom, radius, radius,
      ));

    final compositePath = Path.combine(PathOperation.difference, backgroundPath, holePath);
    canvas.drawPath(compositePath, Paint()..color = overlayColor);
  }

  @override
  bool shouldRepaint(covariant _SpotlightCutoutPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.overlayColor != overlayColor;
}

class _SpotlightCard extends StatelessWidget {
  final SpotlightStep step;
  final int currentStep;
  final int totalSteps;
  final double cardWidth;
  final VoidCallback? onPrev;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final VoidCallback? onDismiss;

  const _SpotlightCard({
    required this.step,
    required this.currentStep,
    required this.totalSteps,
    required this.cardWidth,
    this.onPrev,
    required this.onNext,
    required this.onComplete,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.roundedXl,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppSemanticColors.textMuted,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: step.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon, size: 28, color: step.iconColor),
            ),
            const SizedBox(height: 14),
            Text(
              'Langkah ${currentStep + 1} dari $totalSteps',
              style: TextStyle(fontSize: 12, color: AppSemanticColors.textMuted, fontFamily: AppTypography.fontFamily),
            ),
            const SizedBox(height: 8),
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppSemanticColors.textDarkSecondary, fontFamily: AppTypography.fontFamily),
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppSemanticColors.textSecondary, height: 1.5, fontFamily: AppTypography.fontFamily),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (index) {
                return AnimatedContainer(
                  duration: AppAnimation.fast,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: index == currentStep ? 20 : 6,
                  decoration: BoxDecoration(
                    color: index == currentStep ? ColorDouce.douceBase : Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (onPrev != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onPrev,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Kembali', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppSemanticColors.textSecondary, fontFamily: AppTypography.fontFamily)),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLastStep ? onComplete : onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorDouce.douceBase,
                      elevation: 2,
                      shadowColor: ColorDouce.douceBase.withValues(alpha: 0.35),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isLastStep ? 'Selesai' : 'Lanjut',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: AppTypography.fontFamily),
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
