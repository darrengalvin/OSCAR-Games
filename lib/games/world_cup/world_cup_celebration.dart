import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/sound_service.dart';
import '../../theme/app_theme.dart';

/// Full-screen celebration after winning the World Cup Final.
class WorldCupCelebration extends StatefulWidget {
  const WorldCupCelebration({
    super.key,
    required this.nationName,
    required this.onDone,
  });

  final String nationName;
  final VoidCallback onDone;

  @override
  State<WorldCupCelebration> createState() => _WorldCupCelebrationState();
}

class _WorldCupCelebrationState extends State<WorldCupCelebration>
    with TickerProviderStateMixin {
  late final AnimationController _trophyController;
  late final AnimationController _confettiController;
  late final Animation<double> _trophyScale;
  late final List<_ConfettiPiece> _confetti;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    SoundService.instance.play(GameSound.win);
    HapticFeedback.heavyImpact();

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _trophyScale = CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut);
    _trophyController.forward();

    _confetti = List.generate(48, (i) {
      return _ConfettiPiece(
        x: _rng.nextDouble(),
        y: _rng.nextDouble() * -0.2,
        speed: 0.15 + _rng.nextDouble() * 0.35,
        size: 6 + _rng.nextDouble() * 8,
        color: [
          AppTheme.warning,
          AppTheme.accent,
          AppTheme.success,
          AppTheme.purple,
          AppTheme.danger,
        ][_rng.nextInt(5)],
      );
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        for (final c in _confetti) {
          c.y += c.speed * 0.016;
          if (c.y > 1.15) {
            c.y = -0.05;
            c.x = _rng.nextDouble();
          }
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.warning.withValues(alpha: 0.25),
                    AppTheme.primaryMid,
                    AppTheme.success.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
            ..._confetti.map(
              (c) => Positioned(
                left: c.x * MediaQuery.sizeOf(context).width,
                top: c.y * MediaQuery.sizeOf(context).height,
                child: Transform.rotate(
                  angle: c.y * 12,
                  child: Container(
                    width: c.size,
                    height: c.size * 1.4,
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _trophyScale,
                child: Icon(Icons.emoji_events_rounded, size: 100, color: AppTheme.warning),
              ),
              const SizedBox(height: 20),
              Text(
                'WORLD CUP WINNERS!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: AppTheme.warning.withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.nationName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Text(
                '2026 champions — group stage, Round of 32, Round of 16, '
                'quarter-finals, semi-finals & the Final conquered!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.95),
                  height: 1.45,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: widget.onDone,
                icon: const Icon(Icons.celebration_rounded),
                label: const Text('Celebrate!'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });

  double x;
  double y;
  final double speed;
  final double size;
  final Color color;
}

/// Prominent badge showing the official 48-team World Cup field.
Widget worldCupFortyEightTeamsBadge({bool compact = false}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 12 : 16,
      vertical: compact ? 8 : 10,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.success.withValues(alpha: 0.35),
          AppTheme.accent.withValues(alpha: 0.25),
        ],
      ),
      borderRadius: BorderRadius.circular(compact ? 12 : 14),
      border: Border.all(color: AppTheme.accent.withValues(alpha: 0.45)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.public_rounded, color: AppTheme.accent, size: compact ? 20 : 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '48 NATIONAL TEAMS',
              style: TextStyle(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: AppTheme.accent,
              ),
            ),
            Text(
              '2026 World Cup qualifiers',
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                color: AppTheme.textSecondary.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Tournament knockout path labels (group → final).
const List<(String short, String full)> kWorldCupTournamentStages = [
  ('Group', 'Group stage'),
  ('R32', 'Round of 32'),
  ('R16', 'Round of 16'),
  ('QF', 'Quarter-finals'),
  ('SF', 'Semi-finals'),
  ('Final', 'Final'),
];
