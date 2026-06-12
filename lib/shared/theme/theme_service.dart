import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Satu paket tema visual untuk seluruh tampilan app.
class AppThemeData {
  final String id;
  final String name;
  final String emoji;
  final Color primary;        // Warna aksen utama (button, chip, dll)
  final Color secondary;      // Warna aksen kedua
  final Color bgBase;         // Warna latar paling muda
  final List<Color> orbColors; // 4 warna orb animasi latar

  const AppThemeData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.primary,
    required this.secondary,
    required this.bgBase,
    required this.orbColors,
  });
}

class ThemeService extends GetxService {
  static const _prefKey = 'selected_theme_id';

  /// Daftar tema bawaan
  static const List<AppThemeData> presets = [
    AppThemeData(
      id: 'blush',
      name: 'Blush Pink',
      emoji: '🌸',
      primary: Color(0xFFFF6972),
      secondary: Color(0xFFFF7A8F),
      bgBase: Color(0xFFFFF0F3),
      orbColors: [
        Color(0x66F9A8D4),
        Color(0x4FFDA4AF),
        Color(0x66E879F9),
        Color(0x33F472B6),
      ],
    ),
    AppThemeData(
      id: 'lavender',
      name: 'Lavender Dream',
      emoji: '💜',
      primary: Color(0xFF9B59B6),
      secondary: Color(0xFFBB8FCE),
      bgBase: Color(0xFFF5EEF8),
      orbColors: [
        Color(0x55C39BD3),
        Color(0x44A569BD),
        Color(0x44D2B4DE),
        Color(0x33BB8FCE),
      ],
    ),
    AppThemeData(
      id: 'ocean',
      name: 'Ocean Blue',
      emoji: '🌊',
      primary: Color(0xFF2980B9),
      secondary: Color(0xFF5DADE2),
      bgBase: Color(0xFFEBF5FB),
      orbColors: [
        Color(0x555DADE2),
        Color(0x442980B9),
        Color(0x4476D7C4),
        Color(0x33AED6F1),
      ],
    ),
    AppThemeData(
      id: 'mint',
      name: 'Mint Fresh',
      emoji: '🌿',
      primary: Color(0xFF1ABC9C),
      secondary: Color(0xFF48C9B0),
      bgBase: Color(0xFFE8F8F5),
      orbColors: [
        Color(0x5548C9B0),
        Color(0x441ABC9C),
        Color(0x44A9DFBF),
        Color(0x337DCEA0),
      ],
    ),
    AppThemeData(
      id: 'sunset',
      name: 'Warm Sunset',
      emoji: '🌅',
      primary: Color(0xFFE67E22),
      secondary: Color(0xFFF0B27A),
      bgBase: Color(0xFFFEF9E7),
      orbColors: [
        Color(0x55F0B27A),
        Color(0x44E67E22),
        Color(0x44FAD7A0),
        Color(0x33F5CBA7),
      ],
    ),
    AppThemeData(
      id: 'rose_gold',
      name: 'Rose Gold',
      emoji: '✨',
      primary: Color(0xFFB76E79),
      secondary: Color(0xFFD4A5A5),
      bgBase: Color(0xFFFDF0EE),
      orbColors: [
        Color(0x55D4A5A5),
        Color(0x44B76E79),
        Color(0x44E8BEBD),
        Color(0x33C49A9A),
      ],
    ),
    AppThemeData(
      id: 'midnight',
      name: 'Midnight Berry',
      emoji: '🫐',
      primary: Color(0xFF6C3483),
      secondary: Color(0xFFA569BD),
      bgBase: Color(0xFFF4ECF7),
      orbColors: [
        Color(0x55A569BD),
        Color(0x446C3483),
        Color(0x44BB8FCE),
        Color(0x337D3C98),
      ],
    ),
    AppThemeData(
      id: 'peach',
      name: 'Peach Blossom',
      emoji: '🍑',
      primary: Color(0xFFFF8C69),
      secondary: Color(0xFFFFB347),
      bgBase: Color(0xFFFFF5EE),
      orbColors: [
        Color(0x55FFB347),
        Color(0x44FF8C69),
        Color(0x44FFDAB9),
        Color(0x33FFA07A),
      ],
    ),
  ];

  final Rx<AppThemeData> current = presets.first.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_prefKey);
    if (savedId != null) {
      final found = presets.where((t) => t.id == savedId).toList();
      if (found.isNotEmpty) current.value = found.first;
    }
  }

  Future<void> setTheme(AppThemeData theme) async {
    current.value = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, theme.id);
  }

  /// Shortcut getters untuk dipakai di seluruh widget
  Color get primary => current.value.primary;
  Color get secondary => current.value.secondary;
  Color get bgBase => current.value.bgBase;
  List<Color> get orbColors => current.value.orbColors;
}
