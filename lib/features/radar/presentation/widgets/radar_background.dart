// features/radar/presentation/widgets/radar_background.dart
import 'package:flutter/material.dart';

class RadarBackground extends StatelessWidget {
  const RadarBackground({super.key});

  @override
  Widget build(BuildContext context) =>
      const SizedBox.expand(child: CustomPaint(painter: _RadarPainter()));
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 20);

    final grid = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final ring = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final r in const [90.0, 160.0, 240.0, 320.0]) {
      canvas.drawCircle(center, r, ring);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}