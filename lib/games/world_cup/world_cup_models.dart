import 'dart:convert';

enum WorldCupPhase {
  hub,
  nationShop,
  pickCountry,
  groupStage,
  preMatch,
  matchLive,
  matchResult,
  stealPlayer,
  surrenderPlayer,
  pickPlayer,
  editLineup,
  quickPlaySummary,
  knockout,
  champion,
  eliminated,
}

enum TournamentStage { group, knockout, eliminated, champion }

/// Knockout rounds from Round of 32 through the Final.
enum KnockoutRound {
  roundOf32,
  roundOf16,
  quarterFinal,
  semiFinal,
  finalMatch,
}

const int kKnockoutRoundCount = 5;

extension KnockoutRoundX on KnockoutRound {
  String get label => switch (this) {
        KnockoutRound.roundOf32 => 'Round of 32',
        KnockoutRound.roundOf16 => 'Round of 16',
        KnockoutRound.quarterFinal => 'Quarter-final',
        KnockoutRound.semiFinal => 'Semi-final',
        KnockoutRound.finalMatch => 'Final',
      };

  static KnockoutRound fromIndex(int i) =>
      KnockoutRound.values[i.clamp(0, KnockoutRound.values.length - 1)];
}

class WorldCupNation {
  final String id;
  final String name;
  final String countryCode;

  const WorldCupNation({
    required this.id,
    required this.name,
    required this.countryCode,
  });
}

class WorldCupPlayer {
  final String id;
  final String name;
  final String nationId;
  final String position;
  final double rating2526;

  const WorldCupPlayer({
    required this.id,
    required this.name,
    required this.nationId,
    required this.position,
    required this.rating2526,
  });

  WorldCupPlayer copyWithRating(num rating) => WorldCupPlayer(
        id: id,
        name: name,
        nationId: nationId,
        position: position,
        rating2526: rating.toDouble(),
      );

  String get ratingLabel {
    if (rating2526 == rating2526.roundToDouble()) {
      return rating2526.round().toString();
    }
    return rating2526.toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nationId': nationId,
        'position': position,
        'rating2526': rating2526,
      };

  factory WorldCupPlayer.fromJson(Map<String, dynamic> j) => WorldCupPlayer(
        id: j['id'] as String,
        name: j['name'] as String,
        nationId: j['nationId'] as String,
        position: j['position'] as String,
        rating2526: (j['rating2526'] as num).toDouble(),
      );
}

class WorldCupSquad {
  final String nationId;
  final List<String> playerIds;
  final List<String> startingXiIds;

  const WorldCupSquad({
    required this.nationId,
    required this.playerIds,
    required this.startingXiIds,
  });

  WorldCupSquad copyWith({
    List<String>? playerIds,
    List<String>? startingXiIds,
  }) =>
      WorldCupSquad(
        nationId: nationId,
        playerIds: playerIds ?? this.playerIds,
        startingXiIds: startingXiIds ?? this.startingXiIds,
      );

  Map<String, dynamic> toJson() => {
        'nationId': nationId,
        'playerIds': playerIds,
        'startingXiIds': startingXiIds,
      };

  factory WorldCupSquad.fromJson(Map<String, dynamic> j) => WorldCupSquad(
        nationId: j['nationId'] as String,
        playerIds: List<String>.from(j['playerIds'] as List),
        startingXiIds: List<String>.from(j['startingXiIds'] as List),
      );
}

class GroupMatchResult {
  final String homeNationId;
  final String awayNationId;
  final int homeGoals;
  final int awayGoals;
  final int matchday;

  const GroupMatchResult({
    required this.homeNationId,
    required this.awayNationId,
    required this.homeGoals,
    required this.awayGoals,
    required this.matchday,
  });

  Map<String, dynamic> toJson() => {
        'homeNationId': homeNationId,
        'awayNationId': awayNationId,
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
        'matchday': matchday,
      };

  factory GroupMatchResult.fromJson(Map<String, dynamic> j) => GroupMatchResult(
        homeNationId: j['homeNationId'] as String,
        awayNationId: j['awayNationId'] as String,
        homeGoals: j['homeGoals'] as int,
        awayGoals: j['awayGoals'] as int,
        matchday: j['matchday'] as int,
      );
}

class WorldCupRun {
  final String userNationId;
  final Map<String, WorldCupSquad> squads;
  final List<Map<String, dynamic>> fixtureJson;
  final String groupLetter;
  final int groupMatchday;
  final TournamentStage stage;
  final int knockoutRoundIndex;
  final List<String> eliminatedNationIds;
  final List<String> recentNews;
  final String? pendingFixtureId;
  final String? pendingTransferFixtureId;
  final String? transferWinnerId;
  final String? transferLoserId;
  final String? matchPickPlayerId;

  const WorldCupRun({
    required this.userNationId,
    required this.squads,
    required this.fixtureJson,
    required this.groupLetter,
    this.groupMatchday = 0,
    this.stage = TournamentStage.group,
    this.knockoutRoundIndex = 0,
    this.eliminatedNationIds = const [],
    this.recentNews = const [],
    this.pendingFixtureId,
    this.pendingTransferFixtureId,
    this.transferWinnerId,
    this.transferLoserId,
    this.matchPickPlayerId,
  });

  WorldCupSquad get squad => squads[userNationId]!;

  KnockoutRound? get currentKnockoutRound => stage == TournamentStage.knockout
      ? KnockoutRoundX.fromIndex(knockoutRoundIndex)
      : null;

  WorldCupRun copyWith({
    String? userNationId,
    Map<String, WorldCupSquad>? squads,
    List<Map<String, dynamic>>? fixtureJson,
    String? groupLetter,
    int? groupMatchday,
    TournamentStage? stage,
    int? knockoutRoundIndex,
    List<String>? eliminatedNationIds,
    List<String>? recentNews,
    String? pendingFixtureId,
    String? pendingTransferFixtureId,
    String? transferWinnerId,
    String? transferLoserId,
    String? matchPickPlayerId,
    bool clearPendingFixture = false,
    bool clearTransfer = false,
    bool clearMatchPick = false,
  }) =>
      WorldCupRun(
        userNationId: userNationId ?? this.userNationId,
        squads: squads ?? this.squads,
        fixtureJson: fixtureJson ?? this.fixtureJson,
        groupLetter: groupLetter ?? this.groupLetter,
        groupMatchday: groupMatchday ?? this.groupMatchday,
        stage: stage ?? this.stage,
        knockoutRoundIndex: knockoutRoundIndex ?? this.knockoutRoundIndex,
        eliminatedNationIds: eliminatedNationIds ?? this.eliminatedNationIds,
        recentNews: recentNews ?? this.recentNews,
        pendingFixtureId:
            clearPendingFixture ? null : (pendingFixtureId ?? this.pendingFixtureId),
        pendingTransferFixtureId: clearTransfer
            ? null
            : (pendingTransferFixtureId ?? this.pendingTransferFixtureId),
        transferWinnerId:
            clearTransfer ? null : (transferWinnerId ?? this.transferWinnerId),
        transferLoserId:
            clearTransfer ? null : (transferLoserId ?? this.transferLoserId),
        matchPickPlayerId:
            clearMatchPick ? null : (matchPickPlayerId ?? this.matchPickPlayerId),
      );

  Map<String, dynamic> toJson() => {
        'userNationId': userNationId,
        'squads': squads.map((k, v) => MapEntry(k, v.toJson())),
        'fixtures': fixtureJson,
        'groupLetter': groupLetter,
        'groupMatchday': groupMatchday,
        'stage': stage.name,
        'knockoutRoundIndex': knockoutRoundIndex,
        'eliminatedNationIds': eliminatedNationIds,
        'recentNews': recentNews,
        'pendingFixtureId': pendingFixtureId,
        'pendingTransferFixtureId': pendingTransferFixtureId,
        'transferWinnerId': transferWinnerId,
        'transferLoserId': transferLoserId,
        'matchPickPlayerId': matchPickPlayerId,
      };

  factory WorldCupRun.fromJson(Map<String, dynamic> j) {
    if (!j.containsKey('fixtures') || !j.containsKey('userNationId')) {
      throw FormatException('legacy run');
    }
    final squadMap = (j['squads'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, WorldCupSquad.fromJson(v as Map<String, dynamic>)),
    );
    return WorldCupRun(
      userNationId: j['userNationId'] as String,
      squads: squadMap,
      fixtureJson: (j['fixtures'] as List).cast<Map<String, dynamic>>(),
      groupLetter: j['groupLetter'] as String,
      groupMatchday: j['groupMatchday'] as int? ?? 0,
      stage: TournamentStage.values.byName(j['stage'] as String? ?? 'group'),
      knockoutRoundIndex: j['knockoutRoundIndex'] as int? ?? 0,
      eliminatedNationIds:
          List<String>.from(j['eliminatedNationIds'] as List? ?? []),
      recentNews: List<String>.from(j['recentNews'] as List? ?? []),
      pendingFixtureId: j['pendingFixtureId'] as String?,
      pendingTransferFixtureId: j['pendingTransferFixtureId'] as String?,
      transferWinnerId: j['transferWinnerId'] as String?,
      transferLoserId: j['transferLoserId'] as String?,
      matchPickPlayerId: j['matchPickPlayerId'] as String?,
    );
  }
}

String encodeWorldCupRun(WorldCupRun? run) =>
    run == null ? '' : jsonEncode(run.toJson());

WorldCupRun? decodeWorldCupRun(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return WorldCupRun.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

const int kWorldCupMatchSeconds = 120;
const int kWorldCupStartingXi = 11;
const int kWorldCupBenchSize = 7;
const int kWorldCupSquadSize = kWorldCupStartingXi + kWorldCupBenchSize;
const int kWorldCupMinSquad = kWorldCupStartingXi;
