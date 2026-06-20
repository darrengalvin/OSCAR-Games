import 'world_cup_groups.dart';
import 'world_cup_models.dart';

enum FixtureKind { group, knockout }

/// One playable match (group game or one leg of a knockout tie).
class WorldCupFixture {
  final String id;
  final FixtureKind kind;
  final String? groupLetter;
  final int? groupMatchday;
  final KnockoutRound? knockoutRound;
  final String? tieId;
  final int legIndex;
  final String homeNationId;
  final String awayNationId;
  final bool played;
  final int homeGoals;
  final int awayGoals;

  const WorldCupFixture({
    required this.id,
    required this.kind,
    this.groupLetter,
    this.groupMatchday,
    this.knockoutRound,
    this.tieId,
    this.legIndex = 0,
    required this.homeNationId,
    required this.awayNationId,
    this.played = false,
    this.homeGoals = 0,
    this.awayGoals = 0,
  });

  bool involves(String nationId) =>
      homeNationId == nationId || awayNationId == nationId;

  String get label => switch (kind) {
        FixtureKind.group => 'Group $groupLetter · MD ${(groupMatchday ?? 0) + 1}',
        FixtureKind.knockout => knockoutRound?.label ?? 'Knockout',
      };

  WorldCupFixture copyWith({
    bool? played,
    int? homeGoals,
    int? awayGoals,
  }) =>
      WorldCupFixture(
        id: id,
        kind: kind,
        groupLetter: groupLetter,
        groupMatchday: groupMatchday,
        knockoutRound: knockoutRound,
        tieId: tieId,
        legIndex: legIndex,
        homeNationId: homeNationId,
        awayNationId: awayNationId,
        played: played ?? this.played,
        homeGoals: homeGoals ?? this.homeGoals,
        awayGoals: awayGoals ?? this.awayGoals,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'groupLetter': groupLetter,
        'groupMatchday': groupMatchday,
        'knockoutRound': knockoutRound?.name,
        'tieId': tieId,
        'legIndex': legIndex,
        'homeNationId': homeNationId,
        'awayNationId': awayNationId,
        'played': played,
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
      };

  factory WorldCupFixture.fromJson(Map<String, dynamic> j) => WorldCupFixture(
        id: j['id'] as String,
        kind: FixtureKind.values.byName(j['kind'] as String),
        groupLetter: j['groupLetter'] as String?,
        groupMatchday: j['groupMatchday'] as int?,
        knockoutRound: j['knockoutRound'] != null
            ? KnockoutRound.values.byName(j['knockoutRound'] as String)
            : null,
        tieId: j['tieId'] as String?,
        legIndex: j['legIndex'] as int? ?? 0,
        homeNationId: j['homeNationId'] as String,
        awayNationId: j['awayNationId'] as String,
        played: j['played'] as bool? ?? false,
        homeGoals: j['homeGoals'] as int? ?? 0,
        awayGoals: j['awayGoals'] as int? ?? 0,
      );
}

/// All 72 group-stage fixtures (12 groups × 3 matchdays × 2 games).
List<WorldCupFixture> buildAllGroupFixtures() {
  final fixtures = <WorldCupFixture>[];
  for (var md = 0; md < kGroupMatchdayPairings.length; md++) {
    for (final letter in kWorldCupGroupLetters) {
      final teams = nationsInGroup(letter);
      for (final pair in kGroupMatchdayPairings[md]) {
        fixtures.add(
          WorldCupFixture(
            id: 'g_${letter}_md${md}_${pair[0]}_${pair[1]}',
            kind: FixtureKind.group,
            groupLetter: letter,
            groupMatchday: md,
            homeNationId: teams[pair[0]],
            awayNationId: teams[pair[1]],
          ),
        );
      }
    }
  }
  return fixtures;
}

/// Two-legged knockout ties for [teams] (must be even count) — one match per pairing.
List<WorldCupFixture> buildKnockoutFixtures(
  KnockoutRound round,
  List<String> teams,
) {
  assert(teams.length.isEven);
  final fixtures = <WorldCupFixture>[];
  final roundKey = round.name;
  for (var i = 0; i < teams.length; i += 2) {
    final home = teams[i];
    final away = teams[i + 1];
    final tieId = '${roundKey}_tie${i ~/ 2}';
    fixtures.add(
      WorldCupFixture(
        id: tieId,
        kind: FixtureKind.knockout,
        knockoutRound: round,
        tieId: tieId,
        homeNationId: home,
        awayNationId: away,
      ),
    );
  }
  return fixtures;
}

List<WorldCupFixture> fixturesForGroupMatchday(
  List<WorldCupFixture> all,
  int matchday,
) =>
    all
        .where((f) => f.kind == FixtureKind.group && f.groupMatchday == matchday)
        .toList();

List<WorldCupFixture> legsOfTie(List<WorldCupFixture> all, String tieId) {
  final legs = all.where((f) => f.tieId == tieId).toList()
    ..sort((a, b) => a.legIndex.compareTo(b.legIndex));
  return legs;
}
