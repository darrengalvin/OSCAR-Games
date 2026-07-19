import 'package:flutter/material.dart';

enum SpaceEffect {
  none,
  back3,
  forward3,
  goStart,
  goLast,
}

extension SpaceEffectX on SpaceEffect {
  String get label {
    switch (this) {
      case SpaceEffect.none:
        return '';
      case SpaceEffect.back3:
        return '-3';
      case SpaceEffect.forward3:
        return '+3';
      case SpaceEffect.goStart:
        return 'START';
      case SpaceEffect.goLast:
        return 'LAST';
    }
  }

  String get description {
    switch (this) {
      case SpaceEffect.none:
        return '';
      case SpaceEffect.back3:
        return 'Go back 3 spaces';
      case SpaceEffect.forward3:
        return 'Go forward 3 spaces';
      case SpaceEffect.goStart:
        return 'Go to start';
      case SpaceEffect.goLast:
        return 'Go to last square';
    }
  }

  Color get tint {
    switch (this) {
      case SpaceEffect.none:
        return Colors.transparent;
      case SpaceEffect.back3:
        return const Color(0xFFFC8181);
      case SpaceEffect.forward3:
        return const Color(0xFF48BB78);
      case SpaceEffect.goStart:
        return const Color(0xFFED8936);
      case SpaceEffect.goLast:
        return const Color(0xFF9F7AEA);
    }
  }
}

/// One square space on the lucky board track.
class BoardCell {
  final int id;
  final int ring; // 0 = outermost, ringCount = center finish
  final int indexOnRing;
  final Offset norm; // 0..1 board space
  final bool isCenter;
  SpaceEffect effect;

  BoardCell({
    required this.id,
    required this.ring,
    required this.indexOnRing,
    required this.norm,
    this.isCenter = false,
    this.effect = SpaceEffect.none,
  });
}

/// Nested squares raced as a track: side → down → side → up, then inward.
class NestedSquareBoard {
  final int ringCount;
  final int midsPerSide;

  late final List<BoardCell> cells;
  late final List<List<BoardCell>> rings;
  /// Ordered race path: outer ring circuit, next ring, …, center (finish).
  late final List<BoardCell> path;

  NestedSquareBoard({
    this.ringCount = 6,
    this.midsPerSide = 1,
  }) {
    assert(ringCount >= 2);
    assert(midsPerSide >= 0);
    cells = [];
    rings = [];
    path = [];
    _build();
    _placeSpecials();
  }

  int get finishIndex => path.length - 1;

  /// Square just before the winning center.
  int get lastBeforeWinIndex => finishIndex - 1;

  void _build() {
    var id = 0;

    for (var ring = 0; ring < ringCount; ring++) {
      final half = ringHalf(ring);
      final ringCells = <BoardCell>[];
      final points = _squarePerimeter(half, midsPerSide);

      for (var i = 0; i < points.length; i++) {
        final cell = BoardCell(
          id: id++,
          ring: ring,
          indexOnRing: i,
          norm: points[i],
        );
        ringCells.add(cell);
        cells.add(cell);
        path.add(cell);
      }
      rings.add(ringCells);
    }

    final center = BoardCell(
      id: id,
      ring: ringCount,
      indexOnRing: 0,
      norm: const Offset(0.5, 0.5),
      isCenter: true,
    );
    cells.add(center);
    path.add(center);
  }

  /// Scatter special squares along the track (never start or finish).
  void _placeSpecials() {
    final usable = <int>[
      for (var i = 1; i < finishIndex; i++) i,
    ];
    if (usable.length < 8) return;

    // Even-ish spread of the four effect types, repeating around the board.
    const pattern = [
      SpaceEffect.back3,
      SpaceEffect.forward3,
      SpaceEffect.goStart,
      SpaceEffect.goLast,
    ];
    final step = (usable.length / 10).floor().clamp(3, 6);
    var effectI = 0;
    for (var i = step; i < usable.length; i += step) {
      final idx = usable[i];
      // Don't put "go to last" on the last square itself.
      var effect = pattern[effectI % pattern.length];
      if (idx == lastBeforeWinIndex && effect == SpaceEffect.goLast) {
        effect = SpaceEffect.forward3;
      }
      path[idx].effect = effect;
      effectI++;
    }
  }

  List<Offset> _squarePerimeter(double half, int mids) {
    const c = 0.5;
    final left = c - half;
    final right = c + half;
    final top = c - half;
    final bottom = c + half;

    Offset lerp(Offset a, Offset b, double u) => Offset(
          a.dx + (b.dx - a.dx) * u,
          a.dy + (b.dy - a.dy) * u,
        );

    final corners = <Offset>[
      Offset(left, top),
      Offset(right, top),
      Offset(right, bottom),
      Offset(left, bottom),
    ];

    final points = <Offset>[];
    for (var s = 0; s < 4; s++) {
      final a = corners[s];
      final b = corners[(s + 1) % 4];
      points.add(a);
      for (var m = 1; m <= mids; m++) {
        points.add(lerp(a, b, m / (mids + 1)));
      }
    }
    return points;
  }

  double ringHalf(int ring) {
    final t = ring / (ringCount - 1);
    return 0.48 - t * 0.36;
  }
}

Color ringColor(int ring) {
  const palette = <Color>[
    Color(0xFF66FCF1),
    Color(0xFF4299E1),
    Color(0xFF9F7AEA),
    Color(0xFFED64A6),
    Color(0xFFED8936),
    Color(0xFF48BB78),
    Color(0xFFFFD166), // center
  ];
  return palette[ring % palette.length];
}
