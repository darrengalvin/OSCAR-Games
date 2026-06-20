import 'world_cup_models.dart';

/// Season rating scale: 1 (weakest) → 99 (best).
const int kPlayerRatingFloor = 1;
const int kPlayerRatingCeiling = 99;

/// Every England player is fixed at the bottom of the scale.
const int kEnglandFixedRating = 1;

/// Every Japan player is fixed at the top of the scale.
const int kJapanFixedRating = 99;

/// Highest rating allowed for on-pitch player pick (includes Japan's 99s).
const int kWorldCupMaxPickRating = 99;

/// Maps legacy 58–96 curated values onto 2–98 (1 = England, 99 = Japan).
int seasonRatingFromLegacy(num legacy) {
  const oldMin = 58.0;
  const oldMax = 96.0;
  const spreadMin = 2;
  const spreadMax = 98;
  final t = ((legacy - oldMin) / (oldMax - oldMin)).clamp(0.0, 1.0);
  return (spreadMin + t * (spreadMax - spreadMin))
      .round()
      .clamp(spreadMin, spreadMax);
}

int seasonRatingForGeneratedNation(String nationId, double base, int index, bool starter) {
  if (nationId == 'eng') return kEnglandFixedRating;
  if (nationId == 'jpn') return kJapanFixedRating;
  final anchor = nationBaseSeasonRating(nationId, base);
  if (!starter) return (anchor - 3).clamp(2, 98);
  final spread = (index * 7) % 7 - 3;
  return (anchor + spread).clamp(2, 98);
}

WorldCupPlayer normalizePlayerRating(WorldCupPlayer player) {
  if (player.nationId == 'eng') {
    return player.copyWithRating(kEnglandFixedRating);
  }
  if (player.nationId == 'jpn') {
    return player.copyWithRating(kJapanFixedRating);
  }
  return player.copyWithRating(seasonRatingFromLegacy(player.rating2526));
}

int nationBaseSeasonRating(String nationId, double legacyBase) {
  if (nationId == 'eng') return kEnglandFixedRating;
  if (nationId == 'jpn') return kJapanFixedRating;
  return seasonRatingFromLegacy(legacyBase);
}

double effectiveRatingForStrength(num rating) => rating.toDouble();

String formatSeasonRating(num rating) => rating.round().toString();
