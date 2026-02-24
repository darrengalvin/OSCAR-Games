import 'dart:math';
import 'package:flutter/material.dart';

enum MovePattern { stationary, linear, zigzag, circular, erratic }

class ShootingTarget {
  Offset position;
  double radius;
  bool isHit;
  final int points;
  final MovePattern pattern;

  // Movement state
  double _moveAngle;
  double _speed;
  double _time;
  final Offset _origin;
  final double _orbitRadius;
  double _zigzagTimer;
  final double _zigzagInterval;

  ShootingTarget({
    required this.position,
    required this.radius,
    this.isHit = false,
    this.points = 10,
    this.pattern = MovePattern.stationary,
    double speed = 0,
    double moveAngle = 0,
    double orbitRadius = 60,
    double zigzagInterval = 1.5,
  })  : _speed = speed,
        _moveAngle = moveAngle,
        _time = 0,
        _origin = position,
        _orbitRadius = orbitRadius,
        _zigzagTimer = 0,
        _zigzagInterval = zigzagInterval;

  bool containsPoint(Offset point) {
    return (point - position).distance <= radius;
  }

  void update(double dt, Size bounds) {
    if (isHit) return;
    _time += dt;

    switch (pattern) {
      case MovePattern.stationary:
        break;

      case MovePattern.linear:
        var nx = position.dx + cos(_moveAngle) * _speed;
        var ny = position.dy + sin(_moveAngle) * _speed;
        if (nx - radius < 0 || nx + radius > bounds.width) {
          _moveAngle = pi - _moveAngle;
          nx = nx.clamp(radius, bounds.width - radius);
        }
        if (ny - radius < 0 || ny + radius > bounds.height) {
          _moveAngle = -_moveAngle;
          ny = ny.clamp(radius, bounds.height - radius);
        }
        position = Offset(nx, ny);

      case MovePattern.zigzag:
        _zigzagTimer += dt;
        if (_zigzagTimer >= _zigzagInterval) {
          _zigzagTimer = 0;
          _moveAngle += (pi / 2) + (Random().nextDouble() - 0.5) * pi * 0.5;
        }
        var nx = position.dx + cos(_moveAngle) * _speed;
        var ny = position.dy + sin(_moveAngle) * _speed;
        if (nx - radius < 0 || nx + radius > bounds.width) {
          _moveAngle = pi - _moveAngle;
          nx = nx.clamp(radius, bounds.width - radius);
        }
        if (ny - radius < 0 || ny + radius > bounds.height) {
          _moveAngle = -_moveAngle;
          ny = ny.clamp(radius, bounds.height - radius);
        }
        position = Offset(nx, ny);

      case MovePattern.circular:
        position = Offset(
          _origin.dx + cos(_time * _speed * 0.5) * _orbitRadius,
          _origin.dy + sin(_time * _speed * 0.5) * _orbitRadius,
        );
        position = Offset(
          position.dx.clamp(radius, bounds.width - radius),
          position.dy.clamp(radius, bounds.height - radius),
        );

      case MovePattern.erratic:
        _zigzagTimer += dt;
        if (_zigzagTimer >= 0.3) {
          _zigzagTimer = 0;
          _moveAngle += (Random().nextDouble() - 0.5) * pi;
          _speed = 1.5 + Random().nextDouble() * 3;
        }
        var nx = position.dx + cos(_moveAngle) * _speed;
        var ny = position.dy + sin(_moveAngle) * _speed;
        if (nx - radius < 0 || nx + radius > bounds.width) {
          _moveAngle = pi - _moveAngle;
          nx = nx.clamp(radius, bounds.width - radius);
        }
        if (ny - radius < 0 || ny + radius > bounds.height) {
          _moveAngle = -_moveAngle;
          ny = ny.clamp(radius, bounds.height - radius);
        }
        position = Offset(nx, ny);
    }
  }

  static List<ShootingTarget> generateForLevel({
    required int level,
    required Size areaSize,
    required int count,
  }) {
    final random = Random();
    final targets = <ShootingTarget>[];

    // Targets shrink with level: 28px at level 1 -> 13px at level 20
    final targetRadius = (28.0 - (level - 1) * 0.8).clamp(13.0, 28.0);

    // Speed ramps up
    final baseSpeed = (0.8 + level * 0.2).clamp(0.8, 4.5);

    // Available patterns expand with level
    final patterns = <MovePattern>[];
    if (level <= 2) {
      patterns.addAll([MovePattern.stationary, MovePattern.linear]);
    } else if (level <= 6) {
      patterns.addAll([MovePattern.linear, MovePattern.zigzag]);
    } else if (level <= 12) {
      patterns.addAll([
        MovePattern.linear,
        MovePattern.zigzag,
        MovePattern.circular,
      ]);
    } else {
      patterns.addAll([
        MovePattern.zigzag,
        MovePattern.circular,
        MovePattern.erratic,
      ]);
    }

    // Keep targets in the upper 75% of the area (bow is at bottom)
    final spawnHeight = areaSize.height * 0.75;

    for (int i = 0; i < count; i++) {
      final margin = targetRadius + 20;
      final x = margin + random.nextDouble() * (areaSize.width - margin * 2);
      final y = margin + random.nextDouble() * (spawnHeight - margin * 2);
      final pattern = patterns[random.nextInt(patterns.length)];

      final angle = random.nextDouble() * 2 * pi;
      final orbitR = 40.0 + random.nextDouble() * 50;

      targets.add(ShootingTarget(
        position: Offset(x, y),
        radius: targetRadius,
        pattern: pattern,
        speed: baseSpeed + random.nextDouble() * 1.0,
        moveAngle: angle,
        orbitRadius: orbitR,
        zigzagInterval: 0.8 + random.nextDouble() * 1.5,
        points: (10 + level * 2),
      ));
    }

    return targets;
  }
}

class Arrow {
  Offset position;
  double vx;
  double vy;
  double angle;
  bool active;
  bool stuck;
  double trailOpacity;

  Arrow({
    required this.position,
    required this.vx,
    required this.vy,
    required this.angle,
    this.active = true,
    this.stuck = false,
    this.trailOpacity = 1.0,
  });

  void update(double dt, double gravity, double windForce) {
    if (!active || stuck) return;

    vx += windForce * dt;
    vy += gravity * dt;

    position = Offset(
      position.dx + vx * dt * 60,
      position.dy + vy * dt * 60,
    );

    angle = atan2(vy, vx);
  }

  bool isOffScreen(Size bounds) {
    return position.dx < -50 ||
        position.dx > bounds.width + 50 ||
        position.dy < -50 ||
        position.dy > bounds.height + 50;
  }
}
