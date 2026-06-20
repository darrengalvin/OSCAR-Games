/// Official 2026 FIFA World Cup group-stage draw (Groups A–L, 4 teams each).
const Map<String, List<String>> kWorldCupGroups2026 = {
  'A': ['mex', 'zaf', 'kor', 'cze'],
  'B': ['can', 'sui', 'qat', 'bih'],
  'C': ['bra', 'mar', 'hai', 'sco'],
  'D': ['usa', 'par', 'aus', 'tur'],
  'E': ['ger', 'cuw', 'civ', 'ecu'],
  'F': ['ned', 'jpn', 'tun', 'swe'],
  'G': ['bel', 'egy', 'irn', 'nzl'],
  'H': ['esp', 'cpv', 'ksa', 'ury'],
  'I': ['fra', 'sen', 'nor', 'irq'],
  'J': ['arg', 'alg', 'aut', 'jor'],
  'K': ['por', 'uzb', 'col', 'cod'],
  'L': ['eng', 'cro', 'gha', 'pan'],
};

const List<String> kWorldCupGroupLetters = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
];

/// Round-robin pairings for a 4-team group (indices into the group list).
const List<List<List<int>>> kGroupMatchdayPairings = [
  [
    [0, 1],
    [2, 3],
  ],
  [
    [0, 2],
    [1, 3],
  ],
  [
    [0, 3],
    [1, 2],
  ],
];

String? groupLetterForNation(String nationId) {
  for (final entry in kWorldCupGroups2026.entries) {
    if (entry.value.contains(nationId)) return entry.key;
  }
  return null;
}

List<String> nationsInGroup(String letter) =>
    List<String>.from(kWorldCupGroups2026[letter] ?? const []);
