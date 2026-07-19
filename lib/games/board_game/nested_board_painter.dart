import 'package:flutter/material.dart';
import 'board_models.dart';

class NestedBoardPainter extends CustomPainter {
  final NestedSquareBoard board;
  final List<int> playerPathIndex;
  final List<Color> playerColors;
  final List<String> tokenLabels;
  final int? highlightPathIndex;

  NestedBoardPainter({
    required this.board,
    required this.playerPathIndex,
    this.tokenLabels = const [],
    this.highlightPathIndex,
    this.playerColors = const [
      Color(0xFF66FCF1),
      Color(0xFFFC8181),
      Color(0xFF9F7AEA),
      Color(0xFFED8936),
      Color(0xFF48BB78),
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final origin = Offset(
      (size.width - side) / 2,
      (size.height - side) / 2,
    );

    final wood = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1F3044), Color(0xFF152536), Color(0xFF0D1B2A)],
      ).createShader(Rect.fromLTWH(origin.dx, origin.dy, side, side));

    final boardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(origin.dx, origin.dy, side, side),
      const Radius.circular(18),
    );
    canvas.drawRRect(boardRect, wood);
    canvas.drawRRect(
      boardRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF66FCF1).withValues(alpha: 0.25),
    );

    for (var ring = 0; ring < board.ringCount; ring++) {
      final half = board.ringHalf(ring);
      final color = ringColor(ring);
      final rect = Rect.fromCenter(
        center: origin + Offset(side * 0.5, side * 0.5),
        width: side * half * 2,
        height: side * half * 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0 ? 3.2 : 2.4
          ..color = color.withValues(alpha: 0.7),
      );
    }

    final cellSize = side / (board.ringCount * 3.6);
    for (var i = 0; i < board.path.length; i++) {
      final cell = board.path[i];
      final pos = origin + Offset(cell.norm.dx * side, cell.norm.dy * side);
      final baseColor = ringColor(cell.ring);
      final special = cell.effect != SpaceEffect.none;
      final color = special ? cell.effect.tint : baseColor;
      final highlighted = i == highlightPathIndex;
      final sizeFactor = cell.isCenter ? 1.4 : (special ? 1.12 : 1.0);
      final rect = Rect.fromCenter(
        center: pos,
        width: cellSize * sizeFactor,
        height: cellSize * sizeFactor,
      );
      final radius = Radius.circular(cell.isCenter ? 7 : 5);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()
          ..color = color.withValues(
            alpha: highlighted ? 0.55 : (cell.isCenter || special ? 0.34 : 0.22),
          ),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = highlighted || cell.isCenter || special ? 2.6 : 2
          ..color = color.withValues(alpha: highlighted ? 1 : 0.95),
      );

      if (special) {
        final label = cell.effect.label;
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: label.length > 2 ? cellSize * 0.22 : cellSize * 0.32,
              fontWeight: FontWeight.w900,
              letterSpacing: label.length > 2 ? -0.3 : 0,
            ),
          ),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout(maxWidth: cellSize * sizeFactor * 0.92);
        tp.paint(
          canvas,
          pos - Offset(tp.width / 2, tp.height / 2),
        );
      }
    }

    for (var p = 0; p < playerPathIndex.length; p++) {
      final idx = playerPathIndex[p].clamp(0, board.finishIndex);
      final cell = board.path[idx];
      final base = origin + Offset(cell.norm.dx * side, cell.norm.dy * side);
      final sharers = [
        for (var q = 0; q < playerPathIndex.length; q++)
          if (playerPathIndex[q] == idx) q,
      ];
      final slot = sharers.indexOf(p);
      final spread = cellSize * 0.24;
      final pos = base + Offset((slot - (sharers.length - 1) / 2) * spread, 0);

      final pc = playerColors[p % playerColors.length];
      canvas.drawCircle(pos, cellSize * 0.34, Paint()..color = pc);
      canvas.drawCircle(
        pos,
        cellSize * 0.34,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..color = Colors.white.withValues(alpha: 0.7),
      );
      final label = p < tokenLabels.length && tokenLabels[p].isNotEmpty
          ? tokenLabels[p]
          : '${p + 1}';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: const Color(0xFF0D1B2A),
            fontSize: cellSize * 0.3,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant NestedBoardPainter oldDelegate) {
    return oldDelegate.board != board ||
        oldDelegate.highlightPathIndex != highlightPathIndex ||
        !_listEq(oldDelegate.playerPathIndex, playerPathIndex) ||
        !_strListEq(oldDelegate.tokenLabels, tokenLabels);
  }

  bool _listEq(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _strListEq(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class NestedBoardView extends StatelessWidget {
  final NestedSquareBoard board;
  final List<int> playerPathIndex;
  final List<Color> playerColors;
  final List<String> tokenLabels;
  final int? highlightPathIndex;

  const NestedBoardView({
    super.key,
    required this.board,
    required this.playerPathIndex,
    this.playerColors = const [
      Color(0xFF66FCF1),
      Color(0xFFFC8181),
      Color(0xFF9F7AEA),
      Color(0xFFED8936),
      Color(0xFF48BB78),
    ],
    this.tokenLabels = const [],
    this.highlightPathIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        return CustomPaint(
          size: Size(side, side),
          painter: NestedBoardPainter(
            board: board,
            playerPathIndex: playerPathIndex,
            playerColors: playerColors,
            tokenLabels: tokenLabels,
            highlightPathIndex: highlightPathIndex,
          ),
        );
      },
    );
  }
}
