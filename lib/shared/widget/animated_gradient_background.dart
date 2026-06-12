import 'dart:math';
import 'package:flutter/material.dart';

/// Widget latar belakang animasi gradient orb —
/// mereplikasi efek orb dari tema aktif Momsie.
/// Cukup bungkus konten dengan [Stack] dan letakkan widget ini di bawah.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    this.orbColors,
    this.bgBase,
  });

  /// 4 warna orb override (ambil dari ThemeService jika null).
  final List<Color>? orbColors;
  /// Warna latar dasar override.
  final Color? bgBase;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _xAnims;
  late final List<Animation<double>> _yAnims;
  late final List<Animation<double>> _scaleAnims;

  // Konfigurasi tiap orb: [durasi(detik), ukuran relatif layar]
  // Warna diambil dari widget.orbColors (tema aktif) atau default pink
  static const List<double> _durations  = [25, 30, 22, 28];
  static const List<double> _sizeFactors = [0.80, 0.95, 0.65, 0.55];

  static const List<Color> _defaultOrbColors = [
    Color(0x66f9a8d4),
    Color(0x4ffda4af),
    Color(0x66e879f9),
    Color(0x33f472b6),
  ];

  // Koordinat awal tiap orb (persentase layar)
  final _startPositions = const [
    Offset(-0.15, -0.10), // kiri atas
    Offset(0.55, 0.70),  // kanan bawah
    Offset(0.10, 0.35),  // kiri tengah
    Offset(0.55, 0.40),  // kanan tengah
  ];

  // Keyframe pergerakan tiap orb (delta persentase layar)
  final _movements = const [
    [Offset(0, 0), Offset(0.20, 0.13), Offset(-0.14, -0.20), Offset(0, 0)],
    [Offset(0, 0), Offset(-0.20, -0.13), Offset(0.10, 0.16), Offset(0, 0)],
    [Offset(0, 0), Offset(0.16, -0.16), Offset(-0.16, 0.10), Offset(0, 0)],
    [Offset(0, 0), Offset(-0.13, 0.20), Offset(0.13, -0.13), Offset(0, 0)],
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(seconds: _durations[i].toInt()),
      )..repeat(),
    );

    // Animasi X
    _xAnims = List.generate(4, (i) {
      final moves = _movements[i];
      return TweenSequence<double>([
        for (int j = 0; j < moves.length - 1; j++)
          TweenSequenceItem(
            tween: Tween<double>(begin: moves[j].dx, end: moves[j + 1].dx),
            weight: 1.0,
          ),
      ]).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeInOut,
      ));
    });

    // Animasi Y
    _yAnims = List.generate(4, (i) {
      final moves = _movements[i];
      return TweenSequence<double>([
        for (int j = 0; j < moves.length - 1; j++)
          TweenSequenceItem(
            tween: Tween<double>(begin: moves[j].dy, end: moves[j + 1].dy),
            weight: 1.0,
          ),
      ]).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeInOut,
      ));
    });

    // Animasi skala
    final scaleKeyframes = [
      [1.0, 1.2, 0.8, 1.0],
      [1.0, 1.4, 0.9, 1.0],
      [1.0, 0.8, 1.3, 1.0],
      [1.0, 1.2, 0.8, 1.0],
    ];
    _scaleAnims = List.generate(4, (i) {
      final keys = scaleKeyframes[i];
      return TweenSequence<double>([
        for (int j = 0; j < keys.length - 1; j++)
          TweenSequenceItem(
            tween: Tween<double>(begin: keys[j], end: keys[j + 1]),
            weight: 1.0,
          ),
      ]).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeInOut,
      ));
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.orbColors ?? _defaultOrbColors;
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge(_controllers),
        builder: (context, _) {
          return CustomPaint(
            painter: _OrbPainter(
              orbColors: colors,
              sizeFactors: _sizeFactors,
              bgBase: widget.bgBase ?? const Color(0xFFFFF0F3),
              startPositions: _startPositions,
              xValues: _xAnims.map((a) => a.value).toList(),
              yValues: _yAnims.map((a) => a.value).toList(),
              scaleValues: _scaleAnims.map((a) => a.value).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final List<Color> orbColors;
  final List<double> sizeFactors;
  final Color bgBase;
  final List<Offset> startPositions;
  final List<double> xValues;
  final List<double> yValues;
  final List<double> scaleValues;

  _OrbPainter({
    required this.orbColors,
    required this.sizeFactors,
    required this.bgBase,
    required this.startPositions,
    required this.xValues,
    required this.yValues,
    required this.scaleValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Latar belakang dasar
    final bgPaint = Paint()..color = bgBase;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Gambar tiap orb
    final baseDimension = min(size.width, size.height);
    for (int i = 0; i < orbColors.length; i++) {
      final color = orbColors[i];
      final baseOrbSize = baseDimension * sizeFactors[i];
      final start = startPositions[i];
      final scale = scaleValues[i];
      final orbSize = baseOrbSize * scale;
      final radius = orbSize / 2;

      final dx = (start.dx + xValues[i]) * size.width;
      final dy = (start.dy + yValues[i]) * size.height;
      final center = Offset(dx, dy);

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) => true;
}
