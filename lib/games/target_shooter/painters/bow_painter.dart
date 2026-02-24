import 'dart:math';
import 'package:flutter/material.dart';
import '../models/bow.dart';

class BowPainter extends CustomPainter {
  final Bow bow;
  final double drawAmount;
  final int? moodIndex;

  BowPainter({
    required this.bow,
    this.drawAmount = 0,
    this.moodIndex,
  });

  List<Color> get _activeColors {
    if (bow.hasMoodMode && moodIndex != null) {
      final presets = MoodMode.presets;
      if (moodIndex! < presets.length) {
        return presets[moodIndex!].colors;
      }
    }
    return bow.colors;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bowRadius = size.width * 0.35;
    final colors = _activeColors;

    // Bow arc
    final bowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    if (colors.length > 1) {
      bowPaint.shader = SweepGradient(
        colors: [...colors, colors.first],
        center: Alignment.center,
      ).createShader(Rect.fromCircle(center: center, radius: bowRadius));
    } else {
      bowPaint.color = colors.first;
    }

    final bowRect = Rect.fromCircle(center: center, radius: bowRadius);
    canvas.drawArc(bowRect, -pi * 0.7, pi * 1.4, false, bowPaint);

    // String
    final stringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final topPoint = Offset(
      center.dx + bowRadius * cos(-pi * 0.7),
      center.dy + bowRadius * sin(-pi * 0.7),
    );
    final bottomPoint = Offset(
      center.dx + bowRadius * cos(pi * 0.7),
      center.dy + bowRadius * sin(pi * 0.7),
    );

    final stringPull = drawAmount * bowRadius * 0.5;
    final stringMid = Offset(center.dx - stringPull, center.dy);

    final stringPath = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(stringMid.dx, stringMid.dy)
      ..lineTo(bottomPoint.dx, bottomPoint.dy);
    canvas.drawPath(stringPath, stringPaint);

    // Arrow
    if (drawAmount > 0.1) {
      final arrowPaint = Paint()
        ..color = colors.first.withValues(alpha: 0.9)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final arrowStart = stringMid;
      final arrowEnd = Offset(
        center.dx + bowRadius * 0.8,
        center.dy,
      );
      canvas.drawLine(arrowStart, arrowEnd, arrowPaint);

      // Arrow head
      final headPaint = Paint()
        ..color = colors.first
        ..style = PaintingStyle.fill;
      final headPath = Path()
        ..moveTo(arrowEnd.dx + 8, arrowEnd.dy)
        ..lineTo(arrowEnd.dx - 4, arrowEnd.dy - 5)
        ..lineTo(arrowEnd.dx - 4, arrowEnd.dy + 5)
        ..close();
      canvas.drawPath(headPath, headPaint);
    }

    // Glow effect for legendary
    if (bow.rarity == BowRarity.legendary) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      if (colors.length > 1) {
        glowPaint.shader = SweepGradient(
          colors: [...colors, colors.first],
          center: Alignment.center,
        ).createShader(Rect.fromCircle(center: center, radius: bowRadius));
      } else {
        glowPaint.color = colors.first.withValues(alpha: 0.3);
      }
      canvas.drawArc(bowRect, -pi * 0.7, pi * 1.4, false, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BowPainter oldDelegate) => true;
}

class BowPreviewWidget extends StatelessWidget {
  final Bow bow;
  final double size;
  final int? moodIndex;

  const BowPreviewWidget({
    super.key,
    required this.bow,
    this.size = 80,
    this.moodIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BowPainter(
          bow: bow,
          drawAmount: 0.5,
          moodIndex: moodIndex,
        ),
      ),
    );
  }
}
