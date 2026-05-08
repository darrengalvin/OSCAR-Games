// Promo codes for Lucky Fish (normalized keys are lowercase, single spaces).

class FishingCodeReward {
  final int fishCoins;

  const FishingCodeReward({
    required this.fishCoins,
  });
}

final Map<String, FishingCodeReward> kFishingPromoCodes = () {
  const raw = [
    ('X fishing 1 3', FishingCodeReward(fishCoins: 313)),
    ('962 fishing', FishingCodeReward(fishCoins: 962)),
    ('X was fifth one', FishingCodeReward(fishCoins: 500)),
    ('333 fish I love', FishingCodeReward(fishCoins: 1500)),
  ];
  return {for (final e in raw) normalizeFishingPromoCode(e.$1): e.$2};
}();

/// Collapses whitespace and lowercases — matches redeemed keys in prefs.
String normalizeFishingPromoCode(String raw) {
  final s = raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  return s;
}

/// Returns reward if [normalized] matches a defined code (map is keyed normalized).
FishingCodeReward? fishingRewardForNormalizedCode(String normalized) {
  return kFishingPromoCodes[normalized];
}

/// Shown on the Codes tab — **titles + clues only**; real phrases stay hidden.
class FishingPromoHint {
  final String title;
  final String clue;

  const FishingPromoHint({
    required this.title,
    required this.clue,
  });
}

/// Hints paired to active codes without spelling them out.
const List<FishingPromoHint> kFishingPromoHints = [
  FishingPromoHint(
    title: 'Fish lover',
    clue:
        'Shake up “I love fish”: one digit stamped three times, the critter you’re after here, three short words about how much you adore it — like signing “fish lover”.',
  ),
  FishingPromoHint(
    title: 'Twenty-fourth in the ABCs',
    clue:
        'Begin with the letter whose place in the alphabet is 24. Follow with this game’s shoreline hobby, then two tiny digits tucked together — like a stretched 1 and 3 after a calming stretch.',
  ),
  FishingPromoHint(
    title: 'Almost a thousand',
    clue:
        'Three digits-in-a-row famous for sirens at the dockside, finishing with “fishing”.',
  ),
  FishingPromoHint(
    title: 'Fifth‑place rumor',
    clue:
        'Same first letter at spot 24, then someone “was”, the prize for crossing the tape in fifth, and finishing with the lonely number “one”.',
  ),
];

