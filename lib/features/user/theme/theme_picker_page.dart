import 'package:douce/shared/theme/theme_service.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemePickerPage extends StatelessWidget {
  const ThemePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService ts = Get.find<ThemeService>();

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Tema Aplikasi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              'Tampilan & warna seluruh aplikasi akan berubah',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Grid tema
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: ThemeService.presets.length,
                    itemBuilder: (context, i) {
                      final theme = ThemeService.presets[i];
                      return Obx(() {
                        final isActive =
                            ts.current.value.id == theme.id;
                        return GestureDetector(
                          onTap: () => ts.setTheme(theme),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive
                                    ? theme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primary.withValues(
                                      alpha: isActive ? 0.35 : 0.12),
                                  blurRadius: isActive ? 16 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Stack(
                                children: [
                                  // Mini orb preview
                                  _OrbPreview(theme: theme),

                                  // Content overlay
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Active indicator
                                        if (isActive)
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3),
                                            decoration: BoxDecoration(
                                              color: theme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              mainAxisSize:
                                                  MainAxisSize.min,
                                              children: [
                                                Icon(Icons.check_rounded,
                                                    color: Colors.white,
                                                    size: 12),
                                                SizedBox(width: 3),
                                                Text(
                                                  'Aktif',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        else
                                          const SizedBox(height: 22),

                                        const Spacer(),

                                        // Emoji + Name
                                        Text(
                                          theme.emoji,
                                          style: const TextStyle(
                                              fontSize: 28),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          theme.name,
                                          style: TextStyle(
                                            color: theme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        // Color swatches
                                        Row(
                                          children: [
                                            _swatch(theme.primary),
                                            const SizedBox(width: 4),
                                            _swatch(theme.secondary),
                                            const SizedBox(width: 4),
                                            _swatch(theme.orbColors[2]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _swatch(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Mini preview dari animasi orb untuk setiap kartu tema (static — hanya gradien).
class _OrbPreview extends StatelessWidget {
  final AppThemeData theme;
  const _OrbPreview({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bgBase,
      ),
      child: CustomPaint(
        painter: _StaticOrbPainter(theme: theme),
        child: Container(),
      ),
    );
  }
}

class _StaticOrbPainter extends CustomPainter {
  final AppThemeData theme;
  const _StaticOrbPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.7, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.5),
    ];
    final radii = [size.width * 0.5, size.width * 0.6, size.width * 0.35];

    for (int i = 0; i < 3; i++) {
      final color = theme.orbColors[i];
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(
            Rect.fromCircle(center: positions[i], radius: radii[i]));
      canvas.drawCircle(positions[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
