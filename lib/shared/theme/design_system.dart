import 'package:flutter/material.dart';
import 'color.dart';

/// Momsie Design System Matrix
/// Dibuat oleh Chief Architect sebagai referensi tunggal standar visual Momsie.

/// 1. Spacing Scale (Grid 4px)
class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Insets Standar
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets pagePaddingWide = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(sm);
}

/// 2. Border Radius Scale
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(full));
}

/// 3. Typography Hierarchy
class AppTypography {
  static const String fontFamily = 'Poppins';

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

/// 4. Elevation & Shadow Scale
class AppElevation {
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> level3 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> softColor(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}

/// 5. Standard Animation Durations & Curves
class AppAnimation {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bouncyCurve = Curves.easeOutBack;
}

/// 6. Semantic Color Tokens
class AppSemanticColors {
  static Color get primary => ColorDouce.douceBase;
  static Color get primaryLight => ColorDouce.lightPink;
  static Color get secondary => const Color(0xFF6C63FF);
  static Color get surface => Colors.white;
  static Color get background => const Color(0xFFFAFAFA);
  static Color get error => const Color(0xFFE53935);
  static Color get warning => const Color(0xFFFFA000);
  static Color get success => const Color(0xFF43A047);
  static Color get textPrimary => const Color(0xFF3D2020);
  static Color get textSecondary => const Color(0xFF64748B);
  static Color get textMuted => const Color(0xFF94A3B8);
  static const Color textDark = const Color(0xFF1E1215);
  static const Color textDarkSecondary = const Color(0xFF334155);
  static const Color accentGold = const Color(0xFFD4A574);
  static const Color softTeal = const Color(0xFF5B9A8B);
}
