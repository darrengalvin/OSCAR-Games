import 'world_cup_groups.dart';
import 'world_cup_models.dart';

/// Official 2026 World Cup field size.
const int kWorldCupQualifiedTeamCount = 48;

/// FIFA confederation for each qualified nation (2026 field only).
const Map<String, String> kNationConfederation2026 = {
  'alg': 'CAF', 'arg': 'CONMEBOL', 'aus': 'AFC', 'aut': 'UEFA', 'bel': 'UEFA',
  'bih': 'UEFA', 'bra': 'CONMEBOL', 'can': 'CONCACAF', 'cpv': 'CAF', 'col': 'CONMEBOL',
  'cod': 'CAF', 'cuw': 'CONCACAF', 'cro': 'UEFA', 'cze': 'UEFA', 'ecu': 'CONMEBOL',
  'egy': 'CAF', 'eng': 'UEFA', 'fra': 'UEFA', 'ger': 'UEFA', 'gha': 'CAF',
  'hai': 'CONCACAF', 'irn': 'AFC', 'irq': 'AFC', 'civ': 'CAF', 'jpn': 'AFC',
  'jor': 'AFC', 'mex': 'CONCACAF', 'mar': 'CAF', 'ned': 'UEFA', 'nzl': 'OFC',
  'nor': 'UEFA', 'pan': 'CONCACAF', 'par': 'CONMEBOL', 'por': 'UEFA', 'qat': 'AFC',
  'ksa': 'AFC', 'sco': 'UEFA', 'sen': 'CAF', 'zaf': 'CAF', 'kor': 'AFC',
  'esp': 'UEFA', 'swe': 'UEFA', 'sui': 'UEFA', 'tun': 'CAF', 'tur': 'UEFA',
  'usa': 'CONCACAF', 'ury': 'CONMEBOL', 'uzb': 'AFC',
};

/// All 48 nations that qualified for the 2026 FIFA World Cup (official draw).
/// Italy, Poland, Nigeria, and other non-qualifiers are not included.
const List<WorldCupNation> _kWorldCupNations2026 = [
  WorldCupNation(id: 'alg', name: 'Algeria', countryCode: 'DZ'),
  WorldCupNation(id: 'arg', name: 'Argentina', countryCode: 'AR'),
  WorldCupNation(id: 'aus', name: 'Australia', countryCode: 'AU'),
  WorldCupNation(id: 'aut', name: 'Austria', countryCode: 'AT'),
  WorldCupNation(id: 'bel', name: 'Belgium', countryCode: 'BE'),
  WorldCupNation(id: 'bih', name: 'Bosnia and Herzegovina', countryCode: 'BA'),
  WorldCupNation(id: 'bra', name: 'Brazil', countryCode: 'BR'),
  WorldCupNation(id: 'can', name: 'Canada', countryCode: 'CA'),
  WorldCupNation(id: 'cpv', name: 'Cape Verde', countryCode: 'CV'),
  WorldCupNation(id: 'col', name: 'Colombia', countryCode: 'CO'),
  WorldCupNation(id: 'cod', name: 'DR Congo', countryCode: 'CD'),
  WorldCupNation(id: 'cuw', name: 'Curaçao', countryCode: 'CW'),
  WorldCupNation(id: 'cro', name: 'Croatia', countryCode: 'HR'),
  WorldCupNation(id: 'cze', name: 'Czechia', countryCode: 'CZ'),
  WorldCupNation(id: 'ecu', name: 'Ecuador', countryCode: 'EC'),
  WorldCupNation(id: 'egy', name: 'Egypt', countryCode: 'EG'),
  WorldCupNation(id: 'eng', name: 'England', countryCode: 'GB'),
  WorldCupNation(id: 'fra', name: 'France', countryCode: 'FR'),
  WorldCupNation(id: 'ger', name: 'Germany', countryCode: 'DE'),
  WorldCupNation(id: 'gha', name: 'Ghana', countryCode: 'GH'),
  WorldCupNation(id: 'hai', name: 'Haiti', countryCode: 'HT'),
  WorldCupNation(id: 'irn', name: 'Iran', countryCode: 'IR'),
  WorldCupNation(id: 'irq', name: 'Iraq', countryCode: 'IQ'),
  WorldCupNation(id: 'civ', name: 'Ivory Coast', countryCode: 'CI'),
  WorldCupNation(id: 'jpn', name: 'Japan', countryCode: 'JP'),
  WorldCupNation(id: 'jor', name: 'Jordan', countryCode: 'JO'),
  WorldCupNation(id: 'mex', name: 'Mexico', countryCode: 'MX'),
  WorldCupNation(id: 'mar', name: 'Morocco', countryCode: 'MA'),
  WorldCupNation(id: 'ned', name: 'Netherlands', countryCode: 'NL'),
  WorldCupNation(id: 'nzl', name: 'New Zealand', countryCode: 'NZ'),
  WorldCupNation(id: 'nor', name: 'Norway', countryCode: 'NO'),
  WorldCupNation(id: 'pan', name: 'Panama', countryCode: 'PA'),
  WorldCupNation(id: 'par', name: 'Paraguay', countryCode: 'PY'),
  WorldCupNation(id: 'por', name: 'Portugal', countryCode: 'PT'),
  WorldCupNation(id: 'qat', name: 'Qatar', countryCode: 'QA'),
  WorldCupNation(id: 'ksa', name: 'Saudi Arabia', countryCode: 'SA'),
  WorldCupNation(id: 'sco', name: 'Scotland', countryCode: 'SF'),
  WorldCupNation(id: 'sen', name: 'Senegal', countryCode: 'SN'),
  WorldCupNation(id: 'zaf', name: 'South Africa', countryCode: 'ZA'),
  WorldCupNation(id: 'kor', name: 'South Korea', countryCode: 'KR'),
  WorldCupNation(id: 'esp', name: 'Spain', countryCode: 'ES'),
  WorldCupNation(id: 'swe', name: 'Sweden', countryCode: 'SE'),
  WorldCupNation(id: 'sui', name: 'Switzerland', countryCode: 'CH'),
  WorldCupNation(id: 'tun', name: 'Tunisia', countryCode: 'TN'),
  WorldCupNation(id: 'tur', name: 'Türkiye', countryCode: 'TR'),
  WorldCupNation(id: 'usa', name: 'United States', countryCode: 'US'),
  WorldCupNation(id: 'ury', name: 'Uruguay', countryCode: 'UY'),
  WorldCupNation(id: 'uzb', name: 'Uzbekistan', countryCode: 'UZ'),
];

/// Nations sorted A–Z for the country picker (always [kWorldCupQualifiedTeamCount] teams).
final List<WorldCupNation> kWorldCupNations = List<WorldCupNation>.from(_kWorldCupNations2026)
  ..sort((a, b) => a.name.compareTo(b.name));

/// Ensures the nation list matches the official 2026 group draw (48 teams, Groups A–L).
void validateWorldCup2026Field() {
  if (_kWorldCupNations2026.length != kWorldCupQualifiedTeamCount) {
    throw StateError(
      'Expected $kWorldCupQualifiedTeamCount nations, got ${_kWorldCupNations2026.length}',
    );
  }
  final nationIds = _kWorldCupNations2026.map((n) => n.id).toSet();
  if (nationIds.length != kWorldCupQualifiedTeamCount) {
    throw StateError('Duplicate nation ids in 2026 World Cup field');
  }
  final groupIds = kWorldCupGroups2026.values.expand((g) => g).toList();
  if (groupIds.length != kWorldCupQualifiedTeamCount) {
    throw StateError('Group draw must contain $kWorldCupQualifiedTeamCount teams');
  }
  if (groupIds.toSet().length != kWorldCupQualifiedTeamCount) {
    throw StateError('Duplicate nation ids in group draw');
  }
  for (final id in nationIds) {
    if (!groupIds.contains(id)) {
      throw StateError('Nation $id is not in the official group draw');
    }
    if (!kNationConfederation2026.containsKey(id)) {
      throw StateError('Missing confederation for $id');
    }
  }
  for (final id in groupIds) {
    if (!nationIds.contains(id)) {
      throw StateError('Group nation $id is not in the qualified list');
    }
  }
}

String confederationForNation(String nationId) =>
    kNationConfederation2026[nationId] ?? '—';

/// Squad strength anchor for nations without a handcrafted player pool.
const Map<String, double> kNationSquadBaseRating = {
  'arg': 88.5,
  'esp': 88.0,
  'fra': 87.5,
  'eng': 87.0,
  'por': 86.5,
  'bra': 86.0,
  'ned': 85.5,
  'bel': 85.0,
  'ger': 84.5,
  'cro': 84.0,
  'mar': 83.5,
  'col': 83.0,
  'ury': 82.5,
  'mex': 82.0,
  'usa': 81.5,
  'sui': 81.0,
  'jpn': 81.0,
  'irn': 80.5,
  'kor': 80.0,
  'ecu': 79.5,
  'aut': 79.0,
  'civ': 78.5,
  'tun': 78.0,
  'aus': 77.5,
  'alg': 77.0,
  'egy': 76.5,
  'sen': 76.0,
  'nor': 75.5,
  'swe': 75.0,
  'par': 74.5,
  'cze': 74.0,
  'can': 73.5,
  'pan': 73.0,
  'sco': 72.5,
  'tur': 72.0,
  'ksa': 71.5,
  'gha': 71.0,
  'zaf': 70.5,
  'irq': 70.0,
  'uzb': 69.5,
  'jor': 69.0,
  'cod': 68.5,
  'cpv': 68.0,
  'bih': 67.5,
  'hai': 67.0,
  'cuw': 65.0,
  'nzl': 64.0,
  'qat': 73.0,
};

/// Nations with a full handcrafted player pool in [kWorldCupPlayerPool].
const Set<String> kHandcraftedNationIds = {
  'bra',
  'arg',
  'fra',
  'eng',
  'ger',
  'esp',
  'por',
  'ned',
  'usa',
  'mex',
  'jpn',
  'col',
  'bel',
  'cro',
  'mar',
};
