import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';

class YogaStreakBadge extends StatelessWidget {
  final int streak;
  final bool compact;

  const YogaStreakBadge({
    super.key,
    required this.streak,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color flameColor;
    Color bgColor;
    Color borderColor;
    String streakLabel;

    if (streak == 0) {
      flameColor = const Color(0xFF94A3B8); // Slate Gray
      bgColor = const Color(0xFFF1F5F9);
      borderColor = const Color(0xFFE2E8F0);
      streakLabel = 'Belum Ada Streak';
    } else if (streak < 4) {
      flameColor = const Color(0xFFFF6B00); // Warm Orange (Level 1)
      bgColor = const Color(0xFFFFF3E0);
      borderColor = const Color(0xFFFFB74D);
      streakLabel = '$streak Hari Streak';
    } else if (streak < 8) {
      flameColor = const Color(0xFFFF2A55); // Crimson Red (Level 2)
      bgColor = const Color(0xFFFFEBEE);
      borderColor = const Color(0xFFFF8A80);
      streakLabel = '$streak Hari Membara!';
    } else {
      flameColor = const Color(0xFFFFB300); // Shimmering Gold (Level 3)
      bgColor = const Color(0xFFFFF8E1);
      borderColor = const Color(0xFFFFD54F);
      streakLabel = '🔥 $streak Hari Super Streak!';
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            if (streak > 0)
              BoxShadow(
                color: flameColor.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: flameColor,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '$streak',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: streak == 0 ? AppSemanticColors.textSecondary : flameColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          if (streak > 0)
            BoxShadow(
              color: flameColor.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: flameColor,
            size: 22,
          ),
          const SizedBox(width: 6),
          Text(
            streakLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: streak == 0 ? AppSemanticColors.textDarkSecondary : flameColor,
            ),
          ),
        ],
      ),
    );
  }
}
