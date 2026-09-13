import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/sizeguide/sizeguide_controller.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeGuidePage extends StatefulWidget {
  const SizeGuidePage({super.key});

  @override
  State<SizeGuidePage> createState() => _SizeGuidePageState();
}

class _SizeGuidePageState extends State<SizeGuidePage> {
  late final SizeGuideController _c;
  double _selectedWeek = 20.0;
  String _selectedCategory = 'Buah-buahan';

  @override
  void initState() {
    super.initState();
    _c = Get.put(SizeGuideController());
    _selectedWeek = _c.pregnancyWeek.value.toDouble();
  }

  final List<String> _categories = [
    'Buah-buahan',
    'Makanan Manis',
  ];

  final Map<int, Map<String, Map<String, String>>> _comparisonData = {
    1: {
      'Buah-buahan': {'name': 'Biji Wijen', 'image': 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=500'},
      'Makanan Manis': {'name': 'Butir Gula', 'image': 'https://images.unsplash.com/photo-1581441363689-1f3c3c414635?w=500'},
    },
    4: {
      'Buah-buahan': {'name': 'Biji Poppy', 'image': 'https://images.unsplash.com/photo-1509358271058-acd01cc9386a?w=500'},
      'Makanan Manis': {'name': 'Butir Meises', 'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500'},
    },
    8: {
      'Buah-buahan': {'name': 'Buah Beri', 'image': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=500'},
      'Makanan Manis': {'name': 'Kue Macaron', 'image': 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=500'},
    },
    12: {
      'Buah-buahan': {'name': 'Buah Lemon', 'image': 'https://images.unsplash.com/photo-1534531141161-e4160499e9b0?w=500'},
      'Makanan Manis': {'name': 'Cupcake Vanila', 'image': 'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=500'},
    },
    16: {
      'Buah-buahan': {'name': 'Buah Alpukat', 'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500'},
      'Makanan Manis': {'name': 'Donat Cokelat', 'image': 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500'},
    },
    20: {
      'Buah-buahan': {'name': 'Buah Pisang', 'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500'},
      'Makanan Manis': {'name': 'Waffle Cokelat', 'image': 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=500'},
    },
    24: {
      'Buah-buahan': {'name': 'Jagung Manis', 'image': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=500'},
      'Makanan Manis': {'name': 'Pancake Sirup', 'image': 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=500'},
    },
    28: {
      'Buah-buahan': {'name': 'Buah Terong', 'image': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500'},
      'Makanan Manis': {'name': 'Pie Apel', 'image': 'https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?w=500'},
    },
    32: {
      'Buah-buahan': {'name': 'Kelapa Muda', 'image': 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=500'},
      'Makanan Manis': {'name': 'Cake Ulang Tahun', 'image': 'https://images.unsplash.com/photo-1535141192574-5d4897c13136?w=500'},
    },
    36: {
      'Buah-buahan': {'name': 'Buah Pepaya', 'image': 'https://images.unsplash.com/photo-1517282009859-f000ec3b26fe?w=500'},
      'Makanan Manis': {'name': 'Tart Buah Besar', 'image': 'https://images.unsplash.com/photo-1519869325930-281384150729?w=500'},
    },
    40: {
      'Buah-buahan': {'name': 'Buah Semangka', 'image': 'https://images.unsplash.com/photo-1587049352847-4a222e784d38?w=500'},
      'Makanan Manis': {'name': 'Puding Cokelat Besar', 'image': 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=500'},
    },
  };

  Map<String, String> _getComparison(int week, String category) {
    int matchedWeek = 1;
    for (var w in [1, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40]) {
      if (week >= w) matchedWeek = w;
    }
    return _comparisonData[matchedWeek]?[category] ?? {
      'name': 'Seukuran Biji',
      'image': 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=500'
    };
  }

  double _getCalculatedLength(int week) {
    if (week < 4) return 0.1;
    return (week * 1.15).clamp(0.2, 51.0);
  }

  int _getCalculatedWeight(int week) {
    if (week < 4) return 1;
    if (week < 12) return (week * 2);
    if (week < 24) return (week * 25);
    return (week * 85);
  }

  @override
  Widget build(BuildContext context) {
    final int weekInt = _selectedWeek.round();
    final bool isTooSmall = weekInt < 4;
    final comp = _getComparison(weekInt, _selectedCategory);
    final double lengthCm = _getCalculatedLength(weekInt);
    final int weightGrams = _getCalculatedWeight(weekInt);

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Custom Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppSemanticColors.textDark),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Perkembangan Janin',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Week Selector Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppElevation.level2,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Usia Kehamilan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppSemanticColors.textSecondary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: ColorDouce.douceBase,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      weekInt < 1 ? '<1 Minggu' : 'Minggu $weekInt',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: ColorDouce.douceBase,
                                  inactiveTrackColor: ColorDouce.veryLightPink,
                                  thumbColor: ColorDouce.douceBase,
                                  overlayColor: ColorDouce.douceBase.withValues(alpha: 0.2),
                                ),
                                child: Slider(
                                  value: _selectedWeek,
                                  min: 1,
                                  max: 41,
                                  divisions: 40,
                                  label: 'Minggu $weekInt',
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedWeek = val;
                                    });
                                    _c.setWeek(val.round());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Dropdown Kategori Perbandingan (Zero Emoji)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.category_rounded, color: Color(0xFFFF6972), size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Perbandingan:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppSemanticColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF6972)),
                                  style: const TextStyle(
                                    color: AppSemanticColors.textDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  items: _categories.map((String cat) {
                                    return DropdownMenuItem<String>(
                                      value: cat,
                                      child: Text(cat),
                                    );
                                  }).toList(),
                                  onChanged: (String? newCat) {
                                    if (newCat != null) {
                                      setState(() {
                                        _selectedCategory = newCat;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Visual Artwork Display Container (Apple Card Style)
                        Container(
                          width: double.infinity,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppElevation.level3,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (isTooSmall)
                                  Container(
                                    color: const Color(0xFFF1F5F9),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.visibility_off_rounded, size: 54, color: AppSemanticColors.textSecondary),
                                        SizedBox(height: 12),
                                        Text(
                                          'Belum Ada Ukuran Visual',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppSemanticColors.textDark,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Janin baru mengalami pembuahan mikroskopis',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppSemanticColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  CachedNetworkImage(
                                    imageUrl: comp['image']!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) {
                                      return Container(
                                        color: ColorDouce.veryLightPink,
                                        child: const Center(
                                          child: Icon(Icons.child_care_rounded, size: 64, color: Color(0xFFFF6972)),
                                        ),
                                      );
                                    },
                                  ),

                                // Overlay Frosted Gradient Text at bottom
                                if (!isTooSmall)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.75),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Seukuran ${comp['name']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Minggu $weekInt kehamilan Bunda',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Metrics Cards Row (Panjang & Berat)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.straighten_rounded,
                                title: 'Panjang Janin',
                                value: isTooSmall ? '< 0.1 cm' : '${lengthCm.toStringAsFixed(1)} cm',
                                accentColor: ColorDouce.douceBase,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.monitor_weight_rounded,
                                title: 'Berat Janin',
                                value: isTooSmall ? '< 1 gram' : '$weightGrams gram',
                                accentColor: const Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppElevation.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppSemanticColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
