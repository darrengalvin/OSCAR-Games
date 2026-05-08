import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'fishing_models.dart';

/// Decorative boat for shop cards ([tier] 0–4).
class BoatShopPreview extends StatelessWidget {
  const BoatShopPreview({super.key, required this.tier});

  final int tier;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BoatShopPainter(tier: tier.clamp(0, 4)),
      child: const SizedBox.expand(),
    );
  }
}

/// Decorative rod/reel for shop cards ([tier] 0–4).
class RodShopPreview extends StatelessWidget {
  const RodShopPreview({super.key, required this.tier});

  final int tier;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RodShopPainter(tier: tier.clamp(0, 4)),
      child: const SizedBox.expand(),
    );
  }
}

/// Larger fish artwork for catch popup & cooler thumbnails.
class FishCatchArt extends StatelessWidget {
  const FishCatchArt({
    super.key,
    required this.species,
    this.size = 160,
    this.softGlow = false,
  });

  final FishSpecies species;
  final double size;
  final bool softGlow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: species.rarity.color.withValues(alpha: 0.45),
          ),
          boxShadow: softGlow
              ? [
                  BoxShadow(
                    color: species.rarity.color.withValues(alpha: 0.35),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                ]
              : null,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              species.rarity.color.withValues(alpha: 0.12),
              AppTheme.surface.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CustomPaint(
            painter: _FishPortraitPainter(species: species),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _BoatShopPainter extends CustomPainter {
  _BoatShopPainter({required this.tier});

  final int tier;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final bg = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.blue.withValues(alpha: 0.16 + tier * 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, size.height * 0.52), radius: size.width * (0.76 + tier * 0.05)));
    canvas.drawRect(Offset.zero & size, bg);

    final waterTop = size.height * 0.54;
    final water = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF1565C0).withValues(alpha: 0.55),
          const Color(0xFF0D47A1).withValues(alpha: 0.9),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, waterTop, size.width, size.height - waterTop));
    canvas.drawRect(Rect.fromLTWH(0, waterTop, size.width, size.height - waterTop), water);

    final scale = switch (tier) {
      0 => 1.0,
      1 => 1.16,
      2 => 1.34,
      3 => 1.52,
      _ => 1.68,
    };
    final bw = size.width * 0.33 * scale;
    final sternY = waterTop + size.height * 0.02 + tier * 0.8;
    final bowY = waterTop + size.height * 0.12 + tier;
    final freeboardTop = sternY - size.height * (0.1 + tier * 0.01);

    Paint hullFill(List<Color> hi) => Paint()
      ..shader = LinearGradient(
        colors: hi,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCenter(center: Offset(cx, bowY), width: bw * 2.2, height: size.height * 0.35));

    void rubRail(Path hull) {
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = const Color(0xFFB0BEC5).withValues(alpha: 0.85),
      );
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFF546E7A),
      );
    }

    switch (tier) {
      case 0: // fiberglass dinghy tub
        final hull = Path()
          ..moveTo(cx - bw, bowY + 10)
          ..quadraticBezierTo(cx - bw * 0.9, freeboardTop, cx, freeboardTop - 3)
          ..quadraticBezierTo(cx + bw * 0.9, freeboardTop, cx + bw, bowY + 10)
          ..lineTo(cx + bw * 0.88, sternY + 14)
          ..quadraticBezierTo(cx, sternY + 22, cx - bw * 0.88, sternY + 14)
          ..close();
        canvas.drawShadow(hull, Colors.black54, 5.5 + tier * 1.15, false);
        canvas.drawPath(hull, hullFill(const [Color(0xFFECEFF1), Color(0xFFB0BEC5), Color(0xFFECEFF1)]));
        rubRail(hull);
        canvas.drawCircle(Offset(cx, bowY), 4.5, Paint()..color = const Color(0xFF546E7A)); // drain
        break;
      case 1: // plank rowboat
        final hull = Path()
          ..moveTo(cx - bw * 0.92, sternY + 18)
          ..lineTo(cx - bw * 0.95, bowY + 18)
          ..quadraticBezierTo(cx, freeboardTop - 8, cx + bw * 0.95, bowY + 18)
          ..lineTo(cx + bw * 0.92, sternY + 18)
          ..quadraticBezierTo(cx, sternY + 26, cx - bw * 0.92, sternY + 18)
          ..close();
        canvas.drawShadow(hull, Colors.black54, 6 + tier * 1.2, false);
        canvas.drawPath(hull, Paint()..color = const Color(0xFF6D4C41));
        for (var i = 1; i < 6; i++) {
          final t = i / 6;
          final y = bowY + (sternY + 14 - bowY) * t;
          canvas.drawLine(
            Offset(cx - bw * 0.88, y),
            Offset(cx + bw * 0.85, y + 4),
            Paint()
              ..color = const Color(0xFF8D6E63)
              ..strokeWidth = 1.8,
          );
        }
        rubRail(hull);
        final thwart = Paint()..color = const Color(0xFF795548);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(cx, bowY + 34), width: bw * 1.4, height: 6),
          thwart,
        );
        break;
      case 2: // deep‑V fiberglass + outboard
        final hull = Path()
          ..moveTo(cx - bw * 0.85, sternY + 12)
          ..lineTo(cx - bw * 0.75, bowY + 8)
          ..quadraticBezierTo(cx, freeboardTop - 10, cx + bw * 0.82, bowY + 14)
          ..lineTo(cx + bw * 0.78, sternY + 14)
          ..quadraticBezierTo(cx, sternY + 20, cx - bw * 0.85, sternY + 12)
          ..close();
        canvas.drawShadow(hull, Colors.black54, 7 + tier * 1.1, false);
        canvas.drawPath(hull, hullFill(const [Color(0xFFECEFF1), Color(0xFF607D8B), Color(0xFFCFD8DC)]));
        canvas.drawLine(
          Offset(cx + bw * 0.15, sternY),
          Offset(cx + bw * 1.08, sternY),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.45)
            ..strokeWidth = 2,
        );
        final motorBody = RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx + bw * 1.12, sternY), width: bw * 0.38, height: size.height * 0.13),
          const Radius.circular(5));
        canvas.drawRRect(motorBody, Paint()..color = const Color(0xFF263238));
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + bw * 1.22, sternY), width: bw * 0.2, height: bw * 0.2),
          Paint()
            ..color = const Color(0xFF455A64)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        ); // cav plate
        break;
      case 3: // cabin cruiser-style
        final hull = Path()
          ..moveTo(cx - bw * 1.05, sternY + 10)
          ..quadraticBezierTo(cx - bw * 1.08, sternY + 4, cx - bw * 0.92, bowY + 22)
          ..quadraticBezierTo(cx, freeboardTop - 12, cx + bw * 0.95, bowY + 18)
          ..lineTo(cx + bw * 1.0, sternY + 14)
          ..quadraticBezierTo(cx + bw * 0.4, sternY + 26, cx - bw * 1.05, sternY + 10)
          ..close();
        canvas.drawShadow(hull, Colors.black54, 8 + tier * 1.05, false);
        canvas.drawPath(
            hull,
            hullFill(const [Color(0xFFFFFFFF), Color(0xFFB0BEC5), Color(0xFFECEFF1)]));
        canvas.drawPath(
          hull,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5
            ..color = const Color(0xFF1565C0),
        );
        final cabin = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + bw * 0.15, sternY - 26), width: bw * 0.78, height: size.height * 0.22),
          const Radius.circular(6),
        );
        canvas.drawRRect(cabin, Paint()..color = const Color(0xFFEEF2F8));
        for (var wi = -1; wi <= 2; wi++) {
          canvas.drawRect(
            Rect.fromCenter(center: Offset(cx + bw * 0.06 + wi * 16.0, sternY - 28), width: 10, height: 14),
            Paint()..color = const Color(0xFF263238),
          );
        }
        break;
      default: // trawler
        final hull = Path()
          ..moveTo(cx - bw * 1.35, sternY + 8)
          ..lineTo(cx - bw * 0.82, sternY + 4)
          ..lineTo(cx - bw * 0.88, bowY + 38)
          ..quadraticBezierTo(cx, freeboardTop - 6, cx + bw * 1.08, sternY + 6)
          ..lineTo(cx + bw * 0.92, sternY + 26)
          ..quadraticBezierTo(cx, sternY + 36, cx - bw * 1.35, sternY + 8)
          ..close();
        canvas.drawShadow(hull, Colors.black54, 9 + tier * 0.9, false);
        canvas.drawPath(hull, Paint()..color = const Color(0xFF546E7A));
        canvas.drawPath(
          hull,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = const Color(0xFF37474F),
        );
        final house = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx - bw * 0.12, sternY - 26), width: bw * 0.92, height: size.height * 0.26),
          const Radius.circular(4),
        );
        canvas.drawRRect(house, Paint()..color = const Color(0xFF78909C));
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            house.outerRect.shift(const Offset(-2, -3)),
            const Radius.circular(4),
          ),
          Paint()..color = const Color(0xFF455A64).withValues(alpha: 0.6),
        );
        final boomBase = Offset(cx - bw * 0.5, sternY - 54);
        canvas.drawLine(boomBase, boomBase.translate(0, -34), Paint()..color = const Color(0xFFB0BEC5)..strokeWidth = 3);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RodShopPainter extends CustomPainter {
  _RodShopPainter({required this.tier});

  final int tier;

  static void paintSpinningRod(
    Canvas canvas,
    Size size,
    Offset seat,
    Offset tipGoal,
    double blankWidth,
    Color blank,
    int rodTierForGuides,
  ) {
    /// Rod blank tapered path (rear grip → skinny tip stopping short of bobber).
    final tipStop = Offset.lerp(seat, tipGoal, 0.88)!;
    final butt = Offset(seat.dx - size.width * 0.06, seat.dy + 8);
    final blankPath = Path()
      ..moveTo(butt.dx - 12, butt.dy + 6)
      ..quadraticBezierTo(seat.dx - 6, seat.dy + 24, tipStop.dx + 8, tipStop.dy - 2)
      ..lineTo(tipStop.dx + 4, tipStop.dy + 14)
      ..quadraticBezierTo(seat.dx, seat.dy + 42, butt.dx + 14, butt.dy + 26)
      ..close();

    canvas.drawPath(blankPath, Paint()..color = const Color(0xFF37474F).withValues(alpha: 0.08));
    final fill = Paint()
      ..color = blank
      ..style = PaintingStyle.fill;
    canvas.drawPath(blankPath, fill);
    canvas.drawPath(
      blankPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = Colors.black.withValues(alpha: 0.22),
    );

    // EVA‑style grips
    for (var gx = butt.dx + 12; gx < seat.dx + 44; gx += 6) {
      canvas.drawLine(Offset(gx, butt.dy + 28), Offset(gx + 2, butt.dy + 36), Paint()..color = const Color(0xFF5D4037)..strokeWidth = 3);
    }

    final guidePts = List.generate(
      4 + rodTierForGuides,
      (k) => Offset.lerp(butt.translate(44, -32), tipStop.translate(-4, 6), k / math.max(1, (3 + rodTierForGuides)))!,
    );
    for (final g in guidePts) {
      canvas.drawCircle(g, blankWidth * 0.28, Paint()..color = Colors.white.withValues(alpha: 0.6));
      canvas.drawArc(Rect.fromCircle(center: g, radius: blankWidth * 0.52), math.pi / 9, math.pi * 5 / 5, false,
          Paint()
            ..color = const Color(0xFF90A4AE)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8);
    }

    /// Spinning reel body
    final reelCtr = butt.translate(size.width * 0.06, size.height * 0.045);
    final reelOuter = Rect.fromCircle(center: reelCtr, radius: blankWidth + 22);
    canvas.drawOval(reelOuter.inflate(6), Paint()..color = const Color(0xFF546E7A));
    canvas.drawOval(reelOuter, Paint()..color = const Color(0xFFB0BEC5));
    canvas.drawOval(reelOuter.deflate(7), Paint()..color = const Color(0xFF263238).withValues(alpha: 0.35));
    final handleAngle = rodTierForGuides * math.pi / 10;
    final hh = reelCtr.translate(math.cos(handleAngle + math.pi / 4) * 28, math.sin(handleAngle + math.pi / 4) * 28);
    canvas.drawLine(
      reelCtr,
      hh,
      Paint()
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF37474F),
    );
    canvas.drawCircle(hh, 6.5, Paint()..color = Colors.black.withValues(alpha: 0.5));

    // Mono line thin
    canvas.drawLine(
      guidePts.last.translate(0, 3),
      tipGoal,
      Paint()
        ..strokeWidth = 1.05
        ..color = const Color(0xFFE0F7FA).withValues(alpha: 0.7),
    );
    // Stripped bobber
    canvas.drawCircle(tipGoal, 14, Paint()..color = Colors.white.withValues(alpha: 0.9));
    canvas.drawCircle(tipGoal, 14, Paint()..style = PaintingStyle.stroke..color = Colors.redAccent..strokeWidth = 12);
    canvas.drawCircle(tipGoal, 4, Paint()..color = const Color(0xFFFF5252));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bgCtr = Offset(size.width * 0.92, size.height * 0.38);
    final bg = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.success.withValues(alpha: 0.16),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: bgCtr, radius: size.width * 1.05));
    canvas.drawRect(Offset.zero & size, bg);

    final seat = Offset(size.width * 0.44, size.height * 0.58);
    final tipGoal = Offset(size.width * 0.74, size.height * 0.2 + tier * 1.8);
    final blank = switch (tier) {
      0 => const Color(0xFFBCAAA4),
      1 => const Color(0xFF546E7A),
      2 => const Color(0xFF212121),
      3 => const Color(0xFFC62828),
      _ => const Color(0xFF6A1B9A),
    };
    paintSpinningRod(canvas, size, seat, tipGoal, 14 + tier * 3.6, blank, tier);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FishPortraitPainter extends CustomPainter {
  _FishPortraitPainter({required this.species});

  final FishSpecies species;

  @override
  void paint(Canvas canvas, Size size) {
    final r = species.rarity;
    final idHash = species.id.codeUnits.fold<int>(0, (a, b) => a ^ b);

    final body = Paint()..shader = RadialGradient(
      colors: [
        Color.lerp(r.color, Colors.white, 0.35)!,
        Color.lerp(r.color, Colors.black, 0.42)!,
      ],
      center: const Alignment(0.2, -0.2),
    ).createShader(Rect.fromLTWH(-size.width * 0.1, 0, size.width * 1.15, size.height));

    final midY = size.height * 0.52;
    final noseX = size.width * (0.86 + (idHash % 7) * 0.008);
    final fat = size.height * 0.2;

    final fishPath = Path()
      ..moveTo(size.width * 0.12, midY)
      ..quadraticBezierTo(size.width * 0.28, midY - fat * 1.1, size.width * 0.55, midY - fat)
      ..quadraticBezierTo(size.width * 0.82, midY - fat * 0.45, noseX, midY)
      ..quadraticBezierTo(size.width * 0.82, midY + fat * 0.45, size.width * 0.55, midY + fat)
      ..quadraticBezierTo(size.width * 0.28, midY + fat * 1.1, size.width * 0.12, midY);

    canvas.drawShadow(fishPath, Colors.black.withValues(alpha: 0.55), species.rarity == FishRarity.special ? 14 : 7, false);
    canvas.drawPath(fishPath, body);
    canvas.drawPath(
      fishPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.25),
    );

    final tail = Path()
      ..moveTo(size.width * 0.12, midY)
      ..lineTo(size.width * 0.02, midY - fat * 0.85)
      ..lineTo(size.width * 0.02, midY + fat * 0.85)
      ..close();
    canvas.drawPath(tail, body);

    final eye = Offset(size.width * 0.72, midY - fat * 0.25);
    canvas.drawCircle(eye, 6, Paint()..color = Colors.white);
    canvas.drawCircle(eye.translate(1.5, -0.5), 3, Paint()..color = Colors.black87);

    if (species.rarity.index >= FishRarity.legendary.index) {
      for (var i = 0; i < 2 + species.rarity.index; i++) {
        final spark = Offset(
          size.width * (0.2 + math.sin(idHash / 40 + i) * 0.35),
          size.height * (0.22 + math.cos(idHash / 33 + i) * 0.18),
        );
        canvas.drawCircle(
          spark,
          1.8,
          Paint()..color = AppTheme.warning.withValues(alpha: 0.75 - i * 0.08),
        );
      }
    }

    final fin = Paint()
      ..color = Color.lerp(r.color, Colors.white, 0.5)!
      ..style = PaintingStyle.fill;
    final dorsal = Path()
      ..moveTo(size.width * 0.46, midY - fat * 0.75)
      ..lineTo(size.width * 0.52, midY - fat * 1.3)
      ..lineTo(size.width * 0.62, midY - fat * 0.82)
      ..close();
    canvas.drawPath(dorsal, fin);
  }

  @override
  bool shouldRepaint(covariant _FishPortraitPainter oldDelegate) =>
      oldDelegate.species.id != species.id;
}

/// Distinct hull per boat tier on the lake — **higher tiers read larger**, with glow + wakes on nicer boats.
void _paintGameplayBoatHull(Canvas canvas, Size size, double waterY, int tier) {
  final t = tier.clamp(0, 4);
  final cx = size.width * 0.5;
  final sh = math.max(size.height, 120.0);

  // Dinghy baseline → Research clearly massive on screen (~+75% hull width span).
  final tierMul = 1.0 + 0.096 * t + 0.024 * t * t;
  final bw = size.width * (0.152 + t * 0.02) * tierMul;

  final bowY = waterY + sh * (0.058 + t * 0.014);
  final sternY = waterY + sh * (0.158 + t * 0.032);
  final freeboardTop = bowY - sh * (0.046 + t * 0.0075);

  Paint hullShader(List<Color> hi, double hPad) => Paint()
    ..shader = LinearGradient(
      colors: hi,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(
      Rect.fromCenter(center: Offset(cx - bw * 0.04 * t, bowY), width: bw * hPad, height: sh * (0.3 + t * 0.02)),
    );

  final shadowElev = 5.0 + t * 2.1 + (t >= 4 ? 1.8 : 0);

  void waterHaloBehind() {
    if (t < 1) return;
    final halo = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(const Color(0xFF4FC3F7), AppTheme.accent, (t - 2).clamp(0, 2) / 2.2)!
              .withValues(alpha: (t >= 2 ? 0.08 : 0.035) + t * 0.025),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, sternY + 18), radius: bw * (1.35 + t * 0.1)));
    canvas.drawCircle(Offset(cx, sternY + 16), bw * (1.25 + t * 0.11), halo);
  }

  void wakeRibbons() {
    if (t < 2) return;
    final wk = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 + t * 0.45
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.05 + t * 0.018);
    for (var k = -1; k <= 1; k++) {
      final p = Path()
        ..moveTo(cx - bw * 0.75 + k * bw * 0.45, sternY + 18)
        ..quadraticBezierTo(cx - bw * 0.15 + k * 10, sternY + 56, cx + bw * 0.35 + k * 14, waterY + sh * (0.28 + t * 0.02));
      canvas.drawPath(p, wk);
    }
  }

  void rubRail(Path hull, {double outerW = 2.4}) {
    canvas.drawPath(
      hull,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = outerW + (t >= 3 ? 1.1 : (t >= 2 ? 0.35 : 0))
        ..color =
            Color.lerp(const Color(0xFFB0BEC5), Colors.white, t >= 4 ? 0.55 : (t >= 3 ? 0.35 : 0))!.withValues(alpha: 0.9),
    );
    canvas.drawPath(
      hull,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = const Color(0xFF263238).withValues(alpha: 0.42 + (4 - t) * 0.03),
    );
    if (t >= 3) {
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = Colors.white.withValues(alpha: 0.06 + t * 0.025),
      );
    }
  }

  waterHaloBehind();

  switch (t) {
    case 0: // Dinghy tub
      final hull = Path()
        ..moveTo(cx - bw, bowY + 9)
        ..quadraticBezierTo(cx - bw * 0.9, freeboardTop, cx, freeboardTop - 2)
        ..quadraticBezierTo(cx + bw * 0.9, freeboardTop, cx + bw, bowY + 9)
        ..lineTo(cx + bw * 0.87, sternY + 12)
        ..quadraticBezierTo(cx, sternY + 20, cx - bw * 0.87, sternY + 12)
        ..close();
      canvas.drawShadow(hull, Colors.black54, shadowElev, false);
      canvas.drawPath(
        hull,
        hullShader(const [Color(0xFFF5F7FA), Color(0xFFCFD8DC), Color(0xFFB0BEC5)], 2.2),
      );
      rubRail(hull, outerW: 2);
      canvas.drawCircle(Offset(cx, bowY), 4, Paint()..color = const Color(0xFF546E7A));
      break;

    case 1: // Wood rowboat + thwarts
      final hull = Path()
        ..moveTo(cx - bw * 0.9, sternY + 16)
        ..lineTo(cx - bw * 0.93, bowY + 16)
        ..quadraticBezierTo(cx, freeboardTop - 7, cx + bw * 0.93, bowY + 16)
        ..lineTo(cx + bw * 0.9, sternY + 16)
        ..quadraticBezierTo(cx, sternY + 23, cx - bw * 0.9, sternY + 16)
        ..close();
      canvas.drawShadow(hull, Colors.black54, shadowElev, false);
      canvas.drawPath(hull, Paint()..color = const Color(0xFF6D4C41));
      for (var i = 1; i < 6; i++) {
        final y = bowY + (sternY + 11 - bowY) * (i / 6);
        canvas.drawLine(
          Offset(cx - bw * 0.84, y),
          Offset(cx + bw * 0.82, y + 3),
          Paint()
            ..color = const Color(0xFF8D6E63)
            ..strokeWidth = 1.6,
        );
      }
      rubRail(hull);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, bowY + 28), width: bw * 1.32, height: 5),
        Paint()..color = const Color(0xFF5D4037),
      );
      break;

    case 2: // Deep‑V hull + outboard
      final hull = Path()
        ..moveTo(cx - bw * 0.84, sternY + 10)
        ..lineTo(cx - bw * 0.73, bowY + 6)
        ..quadraticBezierTo(cx, freeboardTop - 9, cx + bw * 0.8, bowY + 12)
        ..lineTo(cx + bw * 0.76, sternY + 11)
        ..quadraticBezierTo(cx, sternY + 18, cx - bw * 0.84, sternY + 10)
        ..close();
      canvas.drawShadow(hull, Colors.black54, shadowElev, false);
      canvas.drawPath(
        hull,
        hullShader(const [Color(0xFFEEF2FB), Color(0xFF90A4AE), Color(0xFF607D8B)], 2.25),
      );
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..color = Colors.black.withValues(alpha: 0.22),
      );
      canvas.drawLine(
        Offset(cx + bw * 0.12, sternY - 2),
        Offset(cx + bw * 1.02, sternY),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.42)
          ..strokeWidth = 1.8,
      );
      final motorBody = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + bw * 1.05, sternY),
          width: bw * 0.36,
          height: sh * 0.11,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(motorBody, Paint()..color = const Color(0xFF263238));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + bw * 1.14, sternY),
          width: bw * 0.18,
          height: bw * 0.18,
        ),
        Paint()
          ..color = const Color(0xFF455A64)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      break;

    case 3: // Cabin cruiser — white gel + blue boot stripe
      final hull = Path()
        ..moveTo(cx - bw * 1.02, sternY + 8)
        ..quadraticBezierTo(cx - bw * 1.05, sternY + 2, cx - bw * 0.9, bowY + 19)
        ..quadraticBezierTo(cx, freeboardTop - 11, cx + bw * 0.93, bowY + 15)
        ..lineTo(cx + bw * 0.98, sternY + 11)
        ..quadraticBezierTo(cx + bw * 0.38, sternY + 23, cx - bw * 1.02, sternY + 8)
        ..close();
      canvas.drawShadow(hull, Colors.black.withValues(alpha: 0.5), shadowElev + 1, false);
      canvas.drawPath(
        hull,
        hullShader(const [Color(0xFFFFFFFF), Color(0xFFE3E8EE), Color(0xFFB0BEC5)], 2.35),
      );
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5
          ..color = const Color(0xFF1565C0),
      );
      final cabin = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + bw * 0.14, sternY - 24 - t * 0.8),
          width: bw * (0.76 + t * 0.02),
          height: sh * (0.2 + t * 0.018),
        ),
        const Radius.circular(5),
      );
      canvas.drawRRect(cabin, Paint()..color = const Color(0xFFE8EEF6));
      for (var wi = -1; wi <= 2; wi++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx + bw * 0.05 + wi * 14.0, sternY - 25 - t * 0.85),
              width: 9,
              height: 12,
            ),
            const Radius.circular(2),
          ),
          Paint()..color = const Color(0xFF1C2540),
        );
      }
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cx + bw * 0.55, sternY - 38), width: bw * 0.14, height: 4),
        Paint()..color = const Color(0xFFFFB300).withValues(alpha: 0.85),
      );
      break;

    default: // Research trawler — workboat superstructure + mast
      final hull = Path()
        ..moveTo(cx - bw * 1.28, sternY + 6)
        ..lineTo(cx - bw * 0.8, sternY + 2)
        ..lineTo(cx - bw * 0.85, bowY + 34)
        ..quadraticBezierTo(cx, freeboardTop - 5, cx + bw * 1.04, sternY + 4)
        ..lineTo(cx + bw * 0.88, sternY + 22)
        ..quadraticBezierTo(cx, sternY + 32, cx - bw * 1.28, sternY + 6)
        ..close();
      canvas.drawShadow(hull, Colors.black.withValues(alpha: 0.62), shadowElev + 3, false);
      canvas.drawPath(hull, Paint()..color = const Color(0xFF546E7A));
      canvas.drawPath(
        hull,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..color = const Color(0xFF263238),
      );
      final house = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - bw * 0.1, sternY - 24),
          width: bw * 0.88,
          height: sh * 0.26,
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(house, Paint()..color = const Color(0xFF78909C));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          house.outerRect.shift(const Offset(-2, -2)),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFF455A64).withValues(alpha: 0.55),
      );
      final boomBase = Offset(cx - bw * 0.48, sternY - 48);
      canvas.drawLine(
        boomBase,
        boomBase.translate(0, -30),
        Paint()
          ..color = const Color(0xFFB0BEC5)
          ..strokeWidth = 3,
      );
      canvas.drawCircle(
        boomBase.translate(0, -32),
        3.5,
        Paint()..color = const Color(0xFFFF7043).withValues(alpha: 0.9),
      );
      canvas.drawLine(
        Offset(cx + bw * 0.95, sternY - 18),
        Offset(cx + bw * 1.18, sternY - 50),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.4)
          ..strokeWidth = 1.3,
      );
      canvas.drawLine(
        Offset(cx + bw * 1.02, sternY - 6),
        Offset(cx + bw * 1.15, sternY - 24),
        Paint()
          ..color = AppTheme.accent.withValues(alpha: 0.65)
          ..strokeWidth = 1.8,
      );
      break;
  }
  wakeRibbons();
}

/// Main fishing view: sky & water, zone guides, tiered boat hulls, spinning tackle.
class LakeFishingScenePainter extends CustomPainter {
  LakeFishingScenePainter({
    required this.bobberBob,
    required this.aimX,
    required this.boatTier,
    required this.rodTier,
    this.showRodZones = true,
  });

  final double bobberBob;
  final double aimX;
  final int boatTier;
  final int rodTier;
  final bool showRodZones;

  static double bobberX(Size size, double aim) =>
      size.width * (0.48 + aim.clamp(-1.0, 1.0) * 0.26);

  void _zoneGuides(Canvas canvas, Size size, double waterY) {
    if (!showRodZones) return;
    const labels = ['LEFT', 'MID', 'RIGHT'];
    for (var i = -1; i <= 1; i++) {
      final x = bobberX(size, i.toDouble());
      final dashPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.2);
      for (double y = waterY + 12; y < size.height - 32; y += 16) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 8), dashPaint);
      }
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i + 1],
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 26));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final tier = boatTier.clamp(0, 4);
    final rt = rodTier.clamp(0, 4);
    final aim = aimX.clamp(-1.0, 1.0);
    final waterY = size.height * 0.42;

    final sky = Paint()
      ..shader = LinearGradient(
        colors: const [Color(0xFF5B7DB1), Color(0xFF3561A3), Color(0xFF173A66)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, waterY + 24));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, waterY + 24), sky);

    canvas.drawCircle(
      Offset(size.width * 0.82, waterY * 0.45),
      math.min(36, size.shortestSide * 0.07),
      Paint()..color = const Color(0xFFFFFDE7).withValues(alpha: 0.18),
    );

    final water = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF0F4C81),
          Color(0xFF0F6AA0),
          Color(0xFF094169),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, waterY, size.width, size.height - waterY));
    canvas.drawRect(Rect.fromLTWH(0, waterY, size.width, size.height - waterY), water);

    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.08);
    for (var h = waterY + 21.0; h < size.height - 10; h += 31) {
      final sp = Path()..moveTo(0, h);
      for (var xPos = 0.0; xPos <= size.width + 4; xPos += 5) {
        sp.lineTo(xPos, h + math.sin((xPos + h) / 36) * 3);
      }
      canvas.drawPath(sp, wavePaint);
    }

    canvas.drawLine(
      Offset(0, waterY),
      Offset(size.width, waterY),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..strokeWidth = 2,
    );

    _zoneGuides(canvas, size, waterY);

    _paintGameplayBoatHull(canvas, size, waterY, tier);

    final seat = Offset(size.width * (0.30 + tier * 0.016), size.height * (0.476 - tier * 0.0045));
    final bobberPt = Offset(LakeFishingScenePainter.bobberX(size, aim), size.height * 0.624 + bobberBob);
    final blank = switch (rt) {
      0 => const Color(0xFFA1887F),
      1 => const Color(0xFF546E7A),
      2 => const Color(0xFF37474F),
      3 => const Color(0xFFC62828),
      _ => const Color(0xFF6A1B9A),
    };

    _RodShopPainter.paintSpinningRod(canvas, size, seat, bobberPt, 12 + rt * 2.6, blank, rt);
  }

  @override
  bool shouldRepaint(covariant LakeFishingScenePainter oldDelegate) =>
      oldDelegate.bobberBob != bobberBob ||
      oldDelegate.aimX != aimX ||
      oldDelegate.boatTier != boatTier ||
      oldDelegate.rodTier != rodTier ||
      oldDelegate.showRodZones != showRodZones;
}
