import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_world.dart';

class WorldBackgroundPainter extends CustomPainter {
  final GameWorld world;
  final int level;

  WorldBackgroundPainter({required this.world, required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = world.backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    switch (world.id) {
      case 'playground':
        _paintPlayground(canvas, size);
      case 'jupiter':
        _paintJupiter(canvas, size);
      case 'backrooms':
        _paintBackrooms(canvas, size);
    }
  }

  void _paintPlayground(Canvas canvas, Size size) {
    // Night sky gradient
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0A0A2E),
          const Color(0xFF1A1A4E),
          const Color(0xFF0D1B2A),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // Stars
    final starPaint = Paint()..color = Colors.white;
    final random = Random(42);
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.6;
      final r = random.nextDouble() * 2 + 0.5;
      starPaint.color = Colors.white.withValues(
        alpha: 0.3 + random.nextDouble() * 0.7,
      );
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }

    // Moon
    final moonPaint = Paint()..color = const Color(0xFFF0E68C);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.12),
      30,
      moonPaint,
    );
    final moonShadow = Paint()..color = const Color(0xFF0A0A2E);
    canvas.drawCircle(
      Offset(size.width * 0.8 + 8, size.height * 0.12 - 5),
      26,
      moonShadow,
    );

    // Ground
    final groundPaint = Paint()..color = const Color(0xFF1A3320);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.85, size.width, size.height * 0.15),
      groundPaint,
    );

    // Swing set silhouette
    final structPaint = Paint()
      ..color = const Color(0xFF0A1A10)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final sx = size.width * 0.2;
    final sy = size.height * 0.85;
    canvas.drawLine(Offset(sx - 30, sy), Offset(sx, sy - 80), structPaint);
    canvas.drawLine(Offset(sx + 30, sy), Offset(sx, sy - 80), structPaint);
    canvas.drawLine(
        Offset(sx + 60, sy), Offset(sx + 90, sy - 80), structPaint);
    canvas.drawLine(
        Offset(sx + 120, sy), Offset(sx + 90, sy - 80), structPaint);
    canvas.drawLine(Offset(sx, sy - 80), Offset(sx + 90, sy - 80), structPaint);

    // Slide silhouette
    final slidePaint = Paint()
      ..color = const Color(0xFF0A1A10)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final slx = size.width * 0.7;
    canvas.drawLine(Offset(slx, sy), Offset(slx, sy - 70), slidePaint);
    canvas.drawLine(Offset(slx, sy - 70), Offset(slx + 60, sy), slidePaint);
    canvas.drawLine(
        Offset(slx + 10, sy), Offset(slx + 10, sy - 60), slidePaint);
  }

  void _paintJupiter(Canvas canvas, Size size) {
    // Space background
    final spacePaint = Paint()..color = const Color(0xFF050510);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), spacePaint);

    // Distant stars
    final starPaint = Paint();
    final random = Random(77);
    for (int i = 0; i < 60; i++) {
      starPaint.color = Colors.white.withValues(
        alpha: 0.2 + random.nextDouble() * 0.5,
      );
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 1.5 + 0.3,
        starPaint,
      );
    }

    // Jupiter atmosphere bands
    final bandColors = [
      const Color(0xFFD4A76A),
      const Color(0xFFC08040),
      const Color(0xFFE8C88A),
      const Color(0xFFB07030),
      const Color(0xFFD4A060),
      const Color(0xFFA06828),
      const Color(0xFFDDB870),
    ];

    final bandHeight = size.height / bandColors.length;
    for (int i = 0; i < bandColors.length; i++) {
      final bandPaint = Paint()
        ..color = bandColors[i].withValues(alpha: 0.25);
      final path = Path();
      final y = i * bandHeight;
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x += 20) {
        path.lineTo(
          x,
          y + sin(x * 0.02 + i * 0.5) * 8 + bandHeight * 0.1,
        );
      }
      path.lineTo(size.width, y + bandHeight);
      path.lineTo(0, y + bandHeight);
      path.close();
      canvas.drawPath(path, bandPaint);
    }

    // Great Red Spot suggestion
    final spotPaint = Paint()
      ..color = const Color(0xFFC04020).withValues(alpha: 0.2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.4),
        width: 80,
        height: 40,
      ),
      spotPaint,
    );
  }

  void _paintBackrooms(Canvas canvas, Size size) {
    // Fluorescent yellow background
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF4A4220),
          const Color(0xFF3D3520),
          const Color(0xFF35301A),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Wall grid pattern
    final wallPaint = Paint()
      ..color = const Color(0xFF5A5230).withValues(alpha: 0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Vertical lines (walls)
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), wallPaint);
    }
    // Horizontal lines
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), wallPaint);
    }

    // Fluorescent ceiling lights
    final lightPaint = Paint()
      ..color = const Color(0xFFD4C85A).withValues(alpha: 0.15);
    for (double x = 30; x < size.width; x += 120) {
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, 20), width: 60, height: 8),
        lightPaint,
      );
      // Light glow
      final glowPaint = Paint()
        ..color = const Color(0xFFD4C85A).withValues(alpha: 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
      canvas.drawCircle(Offset(x, 20), 50, glowPaint);
    }

    // Carpet floor
    final floorPaint = Paint()
      ..color = const Color(0xFF2A2510).withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.9, size.width, size.height * 0.1),
      floorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant WorldBackgroundPainter oldDelegate) {
    return oldDelegate.world.id != world.id || oldDelegate.level != level;
  }
}
