import 'dart:math';
import 'package:flutter/material.dart';

/// Widget latar belakang animasi gradient orb —
/// mereplikasi efek orb pink/rose/fuchsia dari website Momsie.
/// Cukup bungkus konten dengan [Stack] dan letakkan widget ini di bawah.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

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

  // Konfigurasi tiap orb: [durasi(detik), warna, ukuran relatif layar]
  final _orbConfigs = const [
    _OrbConfig(duration: 25, color: Color(0x66f9a8d4), sizeFactor: 0.80), // pink-300/40
    _OrbConfig(duration: 30, color: Color(0x4ffda4af), sizeFactor: 0.95), // rose-300/30
    _OrbConfig(duration: 22, color: Color(0x66e879f9), sizeFactor: 0.65), // fuchsia-400/40
    _OrbConfig(duration: 28, color: Color(0x33f472b6), sizeFactor: 0.55), // pink-400/20
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
      _orbConfigs.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(seconds: _orbConfigs[i].duration),
      )..repeat(),
    );

    // Animasi X
    _xAnims = List.generate(_orbConfigs.length, (i) {
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
    _yAnims = List.generate(_orbConfigs.length, (i) {
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
    _scaleAnims = List.generate(_orbConfigs.length, (i) {
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
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge(_controllers),
        builder: (context, _) {
          return CustomPaint(
            painter: _OrbPainter(
              orbConfigs: _orbConfigs,
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
  final List<_OrbConfig> orbConfigs;
  final List<Offset> startPositions;
  final List<double> xValues;
  final List<double> yValues;
  final List<double> scaleValues;

  _OrbPainter({
    required this.orbConfigs,
    required this.startPositions,
    required this.xValues,
    required this.yValues,
    required this.scaleValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Latar belakang dasar pink sangat muda
    final bgPaint = Paint()..color = const Color(0xFFFFF0F3);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Gambar tiap orb
    final baseDimension = min(size.width, size.height);
    for (int i = 0; i < orbConfigs.length; i++) {
      final config = orbConfigs[i];
      final start = startPositions[i];
      final baseOrbSize = baseDimension * config.sizeFactor;
      final scale = scaleValues[i];
      final orbSize = baseOrbSize * scale;
      final radius = orbSize / 2;

      final dx = (start.dx + xValues[i]) * size.width;
      final dy = (start.dy + yValues[i]) * size.height;
      final center = Offset(dx, dy);

      // Radial gradient untuk efek glow/blur
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            config.color,
            config.color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    // Selalu repaint karena nilai koordinat/skala berubah setiap frame
    return true;
  }
}

class _OrbConfig {
  final int duration;
  final Color color;
  final double sizeFactor;
  const _OrbConfig({
    required this.duration,
    required this.color,
    required this.sizeFactor,
  });
}
