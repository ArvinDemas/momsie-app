import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<Offset> _points = <Offset>[];
  final Paint _paint = Paint()
    ..color = const Color(0xFF1A1A2E)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2.5;

  void _addPoint(Offset point) {
    setState(() {
      _points.add(point);
    });
  }

  void _clearSignature() {
    setState(() {
      _points.clear();
    });
  }

  bool get isEmpty => _points.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onPanUpdate: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition = renderBox.globalToLocal(details.globalPosition);
              _addPoint(localPosition);
            },
            onPanEnd: (details) {
              _points.add(const Offset(0, 0));
            },
            child: CustomPaint(
              painter: _SignaturePainter(_points),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _clearSignature,
          icon: const Icon(Icons.delete_outline, size: 16),
          label: const Text('Hapus Tanda Tangan', style: TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red.shade400,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], Paint()
          ..color = const Color(0xFF1A1A2E)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.5);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
