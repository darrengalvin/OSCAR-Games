import 'dart:math';

import 'world_cup_groups.dart';
import 'world_cup_models.dart';

class GroupStandingRow {
  final String nationId;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int gf = 0;
  int ga = 0;

  GroupStandingRow({required this.nationId});

  int get points => won * 3 + drawn;
  int get gd => gf - ga;
}

List<(String home, String away)> matchdayFixtures(
  List<String> groupNationIds,
  int matchday,
) {
  final pairs = kGroupMatchdayPairings[matchday];
  return pairs
      .map(
        (p) => (
          groupNationIds[p[0]],
          groupNationIds[p[1]],
        ),
      )
      .toList();
}

bool userWonMatch({
  required String userNationId,
  required String homeId,
  required String awayId,
  required int homeGoals,
  required int awayGoals,
  required double userStrength,
  required double oppStrength,
}) {
  final userHome = homeId == userNationId;
  final userGoals = userHome ? homeGoals : awayGoals;
  final oppGoals = userHome ? awayGoals : homeGoals;
  if (userGoals != oppGoals) return userGoals > oppGoals;
  return userStrength >= oppStrength;
}

List<GroupStandingRow> groupStandings(
  List<String> groupNationIds,
  List<GroupMatchResult> results,
) {
  final rows = {
    for (final id in groupNationIds) id: GroupStandingRow(nationId: id),
  };
  for (final r in results) {
    final home = rows[r.homeNationId]!;
    final away = rows[r.awayNationId]!;
    home.played++;
    away.played++;
    home.gf += r.homeGoals;
    home.ga += r.awayGoals;
    away.gf += r.awayGoals;
    away.ga += r.homeGoals;
    if (r.homeGoals > r.awayGoals) {
      home.won++;
      away.lost++;
    } else if (r.homeGoals < r.awayGoals) {
      away.won++;
      home.lost++;
    } else {
      home.drawn++;
      away.drawn++;
    }
  }
  return rows.values.toList()
    ..sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      if (b.gd != a.gd) return b.gd.compareTo(a.gd);
      if (b.gf != a.gf) return b.gf.compareTo(a.gf);
      return a.nationId.compareTo(b.nationId);
    });
}

({int homeGoals, int awayGoals}) simulateFullMatch({
  required Random rng,
  required double homeStrength,
  required double awayStrength,
  int seconds = kWorldCupMatchSeconds,
  double homeBoost = 1.0,
  double awayBoost = 1.0,
}) {
  var home = 0;
  var away = 0;
  for (var i = 0; i < seconds; i++) {
    final tick = tickMatchSecond(
      rng: rng,
      homeStrength: homeStrength * homeBoost,
      awayStrength: awayStrength * awayBoost,
    );
    if (tick.homeScored) home++;
    if (tick.awayScored) away++;
  }
  return (homeGoals: home, awayGoals: away);
}

({bool homeScored, bool awayScored}) tickMatchSecond({
  required Random rng,
  required double homeStrength,
  required double awayStrength,
}) {
  final total = homeStrength + awayStrength;
  if (total <= 0) return (homeScored: false, awayScored: false);
  final homeP = (homeStrength / total) * 0.045;
  final awayP = (awayStrength / total) * 0.045;
  final homeScored = rng.nextDouble() < homeP;
  final awayScored = !homeScored && rng.nextDouble() < awayP;
  return (homeScored: homeScored, awayScored: awayScored);
}

String singleMatchScoreline(String homeName, String awayName, int h, int a) =>
    '$homeName $h–$a $awayName';

List<String> knockoutRoundLabels() =>
    KnockoutRound.values.map((r) => r.label).toList();

({bool homeScored, bool awayScored}) tickLegSecond({
  required Random rng,
  required double homeStrength,
  required double awayStrength,
}) =>
    tickMatchSecond(
      rng: rng,
      homeStrength: homeStrength,
      awayStrength: awayStrength,
    );
