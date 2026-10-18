import 'dart:math' as math;

import 'package:flutter/material.dart';



class MapRadarScreen extends StatefulWidget { 
  const MapRadarScreen({super.key});

  @override
  State<MapRadarScreen> createState() => _MapRadarScreenState();
}

class _MapRadarScreenState extends State<MapRadarScreen>
    with SingleTickerProviderStateMixin {
  bool isOnline = true;
  int currentTabIndex = 0;
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    // Continuous 360-degree radar sweep animation
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Header)
            _buildAppBar(),

            // Main Body: Full Map Radar Scanner with sweep & beacon
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Coordinate Grid & Concentric Circles
                  const RadarGridBackground(),

                  // 2. Animated Rotating Green Radar Sector Sweep
                  AnimatedBuilder(
                    animation: _radarController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: RadarSweepPainter(
                          angle: _radarController.value * 2 * math.pi,
                          isOnline: isOnline,
                        ),
                      );
                    },
                  ),

                  // 3. Central Position Marker / Driver Location Beacon
                  _buildCenterDriverBeacon(),

                  // 4. Subtle Ambient Radar Ping Ripples
                  _buildPulsingRings(),
                ],
              ),
            ),

            // Persistent Bottom Tab Navigation Bar
            _buildBottomTabBar(),
          ],
        ),
      ),
    );
  }

  /// Top App Bar matching Kinetic Courier specifications
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF051424),
        border: Border(
          bottom: BorderSide(color: Color(0xFF0D1C2D), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Header Text Titles
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLEETRUNNER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'Map Radar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Online / Offline Switch Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnline
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFF2C3A4C),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline
                        ? const Color(0xFF10B981)
                        : const Color(0xFF64748B),
                    boxShadow: isOnline
                        ? [
                            const BoxShadow(
                              color: Color(0xFF10B981),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isOnline
                        ? const Color(0xFF10B981)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.65,
                  child: Switch(
                    value: isOnline,
                    onChanged: (val) {
                      setState(() {
                        isOnline = val;
                        if (isOnline) {
                          _radarController.repeat();
                        } else {
                          _radarController.stop();
                        }
                      });
                    },
                    activeThumbColor: const Color(0xFF10B981),
                    inactiveThumbColor: const Color(0xFF94A3B8),
                    inactiveTrackColor: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Driver Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2C3A4C), width: 1.5),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Center Driver Location Target with orientation arrow
  Widget _buildCenterDriverBeacon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Upward heading triangle indicator
        CustomPaint(
          size: const Size(12, 10),
          painter: TrianglePointerPainter(
            color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 3),
        // Central circular beacon target
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF051424),
            border: Border.all(
              color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
              width: 3,
            ),
            boxShadow: [
              if (isOnline)
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Ambient background glow rings
  Widget _buildPulsingRings() {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (isOnline ? const Color(0xFF10B981) : const Color(0xFF2C3A4C))
                    .withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0.3, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  /// Persistent Bottom Navigation Bar
  Widget _buildBottomTabBar() {
    final navItems = [
      {'icon': Icons.radar_rounded, 'label': 'Radar'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Tasks'},
      {'icon': Icons.access_time_rounded, 'label': 'History'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF030D18),
        border: Border(
          top: BorderSide(color: Color(0xFF0D1C2D), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = index == currentTabIndex;
          final color = isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                currentTabIndex = index;
              });
            },
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    navItems[index]['icon'] as IconData,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    navItems[index]['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Custom Painter for Background Grid & Concentric Distance Rings
class RadarGridBackground extends StatelessWidget {
  const RadarGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _RadarBackgroundPainter(),
        );
      },
    );
  }
}

class _RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Subtle dotted/dashed coordinate grid
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.2)
      ..strokeWidth = 1;

    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Concentric Radar Distance Rings
    final ringPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radii = [80.0, 160.0, 240.0, 320.0, 400.0];
    for (final r in radii) {
      canvas.drawCircle(center, r, ringPaint);
    }

    // 3. Subtle Crosshair Lines through center
    final crosshairPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), crosshairPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), crosshairPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Painter for the Rotating Green Radar Sweep Sector
class RadarSweepPainter extends CustomPainter {
  final double angle;
  final bool isOnline;

  RadarSweepPainter({
    required this.angle,
    required this.isOnline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isOnline) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.48;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // Draw the 60-degree gradient sweep cone
    const sweepAngle = math.pi / 3; // 60 degrees
    final rect = Rect.fromCircle(center: Offset.zero, radius: maxRadius);

    final sweepGradient = SweepGradient(
      startAngle: 0.0,
      endAngle: sweepAngle,
      colors: [
        const Color(0xFF10B981).withValues(alpha: 0.0),
        const Color(0xFF10B981).withValues(alpha: 0.28),
      ],
    );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      rect,
      0,
      sweepAngle,
      true,
      sweepPaint,
    );

    // Leading crisp edge line of the radar beam
    final edgePaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.85)
      ..strokeWidth = 1.5;

    final edgeX = maxRadius * math.cos(sweepAngle);
    final edgeY = maxRadius * math.sin(sweepAngle);
    canvas.drawLine(Offset.zero, Offset(edgeX, edgeY), edgePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RadarSweepPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.isOnline != isOnline;
  }
}

/// Heading triangle orientation pointer
class TrianglePointerPainter extends CustomPainter {
  final Color color;

  TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
