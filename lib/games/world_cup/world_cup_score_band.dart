import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'world_cup_data.dart';
import 'world_cup_match_sim.dart';

/// TV-style score band with goal scorers revealed one by one.
class WorldCupScoreBand extends StatefulWidget {
  const WorldCupScoreBand({
    super.key,
    required this.homeNationId,
    required this.awayNationId,
    required this.homeGoals,
    required this.awayGoals,
    required this.goals,
    required this.onDone,
  });

  final String homeNationId;
  final String awayNationId;
  final int homeGoals;
  final int awayGoals;
  final List<MatchGoal> goals;
  final VoidCallback onDone;

  @override
  State<WorldCupScoreBand> createState() => _WorldCupScoreBandState();
}

class _WorldCupScoreBandState extends State<WorldCupScoreBand> {
  int _revealed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.goals.isEmpty) {
      _revealed = 0;
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 650), (t) {
        if (!mounted) return;
        if (_revealed >= widget.goals.length) {
          t.cancel();
          return;
        }
        setState(() => _revealed++);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = nationById(widget.homeNationId);
    final away = nationById(widget.awayNationId);
    final allShown = _revealed >= widget.goals.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Full time',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          _scoreboard(home.name, away.name, home.countryCode, away.countryCode),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sports_soccer_rounded, size: 18, color: AppTheme.accent),
                    const SizedBox(width: 8),
                    const Text('Goal scorers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 12),
                if (widget.goals.isEmpty)
                  Text(
                    'No goals — a tight affair.',
                    style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.9)),
                  )
                else
                  ...List.generate(_revealed.clamp(0, widget.goals.length), (i) {
                    final g = widget.goals[i];
                    final team = nationById(g.nationId).name;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: g.isHome
                                  ? AppTheme.blue.withValues(alpha: 0.2)
                                  : AppTheme.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${g.minute}'",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(g.playerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                Text(team, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.85))),
                              ],
                            ),
                          ),
                          Icon(Icons.sports_soccer_rounded, size: 16, color: AppTheme.accent.withValues(alpha: 0.7)),
                        ],
                      ),
                    );
                  }),
                if (!allShown && widget.goals.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Updating…',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.7)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: allShown || widget.goals.isEmpty ? widget.onDone : null,
            child: const Text('Continue'),
          ),
          if (!allShown && widget.goals.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _timer?.cancel();
                setState(() => _revealed = widget.goals.length);
              },
              child: const Text('Show all goals'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _scoreboard(String homeName, String awayName, String homeCode, String awayCode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryMid,
            AppTheme.blue.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(homeCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  homeName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${widget.homeGoals} – ${widget.awayGoals}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(awayCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  awayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
