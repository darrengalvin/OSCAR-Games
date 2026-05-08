import 'dart:math';

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Fallback / baseline hook window (seconds). Tier‑0 bamboo uses [biteWindowMs] equal to this in ms.
const int kBiteHookWindowSeconds = 3;

enum FishRarity { common, rare, legendary, secret, special }

extension FishRarityX on FishRarity {
  String get label => switch (this) {
        FishRarity.common => 'Common',
        FishRarity.rare => 'Rare',
        FishRarity.legendary => 'Legendary',
        FishRarity.secret => 'Secret',
        FishRarity.special => 'Special',
      };

  Color get color => switch (this) {
        FishRarity.common => AppTheme.textSecondary,
        FishRarity.rare => AppTheme.blue,
        FishRarity.legendary => const Color(0xFFFFB300),
        FishRarity.secret => AppTheme.purple,
        FishRarity.special =>
          const Color(0xFFFFD700),
      };

  /// Target odds at tier‑0 boat (before boat bonus): 50 : 20 : 15 : 5 : 1 → ~55% / 22% / 16% / 5.5% / 1.1% after normalization.
  double get targetWeight => switch (this) {
        FishRarity.common => 50.0,
        FishRarity.rare => 20.0,
        FishRarity.legendary => 15.0,
        FishRarity.secret => 5.0,
        FishRarity.special => 1.0,
      };
}

class FishSpecies {
  final String id;
  final String name;
  final FishRarity rarity;
  final int sellPrice;

  const FishSpecies({
    required this.id,
    required this.name,
    required this.rarity,
    required this.sellPrice,
  });
}

const List<FishSpecies> kAllFish = [
  FishSpecies(id: 'minnow', name: 'River Minnow', rarity: FishRarity.common, sellPrice: 4),
  FishSpecies(id: 'perch', name: 'Speckled Perch', rarity: FishRarity.common, sellPrice: 6),
  FishSpecies(id: 'herring', name: 'Silver Herring', rarity: FishRarity.common, sellPrice: 5),
  FishSpecies(id: 'bass', name: 'Lunker Bass', rarity: FishRarity.rare, sellPrice: 22),
  FishSpecies(id: 'trout', name: 'Rainbow Trout', rarity: FishRarity.rare, sellPrice: 26),
  FishSpecies(id: 'walleye', name: 'Walleye', rarity: FishRarity.rare, sellPrice: 24),
  FishSpecies(id: 'moonfish', name: 'Moonfish', rarity: FishRarity.legendary, sellPrice: 68),
  FishSpecies(id: 'clown_koi', name: 'Golden Legend Koi', rarity: FishRarity.legendary, sellPrice: 78),
  FishSpecies(id: 'abyss_slug', name: 'Abyss Slug', rarity: FishRarity.secret, sellPrice: 165),
  FishSpecies(id: 'phantom_fin', name: 'Phantom Fin', rarity: FishRarity.secret, sellPrice: 185),
  FishSpecies(id: 'prism_shark', name: 'Prism Shark', rarity: FishRarity.special, sellPrice: 720),
  FishSpecies(id: 'oscar_whale', name: 'Oscar Whale', rarity: FishRarity.special, sellPrice: 950),
];

class FishingBoatDef {
  final String id;
  final String name;
  final int tier;
  final int cost;
  final String blurb;

  const FishingBoatDef({
    required this.id,
    required this.name,
    required this.tier,
    required this.cost,
    required this.blurb,
  });
}

class FishingRodDef {
  final String id;
  final String name;
  final int tier;
  final int cost;
  final String blurb;

  /// Shorter casts (seconds range end).
  final int waitMsMin;
  final int waitMsMax;

  /// Ms you have after BITE! to hook (better rods → longer window).
  final int biteWindowMs;

  Duration get biteHookReaction => Duration(milliseconds: biteWindowMs);

  /// Hook window length in seconds (for UI).
  double get biteHookSeconds => biteWindowMs / 1000.0;

  const FishingRodDef({
    required this.id,
    required this.name,
    required this.tier,
    required this.cost,
    required this.blurb,
    required this.waitMsMin,
    required this.waitMsMax,
    required this.biteWindowMs,
  });
}

const List<FishingBoatDef> kBoats = [
  FishingBoatDef(
    id: 'dinghy',
    name: 'Dinghy',
    tier: 0,
    cost: 0,
    blurb: 'Small and steady — common bites all day.',
  ),
  FishingBoatDef(
    id: 'rowboat',
    name: 'Lake Rowboat',
    tier: 1,
    cost: 155,
    blurb: 'No Common fish — you’re past minnow grade.',
  ),
  FishingBoatDef(
    id: 'motorboat',
    name: 'Motorboat',
    tier: 2,
    cost: 575,
    blurb: 'No Common or Rare — chase big Legendary hits until you upgrade further.',
  ),
  FishingBoatDef(
    id: 'yacht',
    name: 'Coastal Yacht',
    tier: 3,
    cost: 2310,
    blurb: 'Secret-tier only (no Common / Rare / Legendary). Center the cast for better odds.',
  ),
  FishingBoatDef(
    id: 'research',
    name: 'Research Trawler',
    tier: 4,
    cost: 8250,
    blurb: 'Secret & Special only — the highest tier fish unlock here.',
  ),
];

const List<FishingRodDef> kRods = [
  FishingRodDef(
    id: 'bamboo',
    name: 'Bamboo Rod',
    tier: 0,
    cost: 0,
    blurb: 'Starter gear — patient casts.',
    waitMsMin: 2200,
    waitMsMax: 5200,
    biteWindowMs: 3000,
  ),
  FishingRodDef(
    id: 'fiberglass',
    name: 'Fiberglass Rod',
    tier: 1,
    cost: 85,
    blurb: 'Quicker average wait for a bite after you cast.',
    waitMsMin: 1600,
    waitMsMax: 4000,
    biteWindowMs: 3600,
  ),
  FishingRodDef(
    id: 'carbon',
    name: 'Carbon Rod',
    tier: 2,
    cost: 420,
    blurb: 'Shorter wait before the line goes tight.',
    waitMsMin: 1200,
    waitMsMax: 3100,
    biteWindowMs: 4200,
  ),
  FishingRodDef(
    id: 'pro',
    name: 'Pro Tournament',
    tier: 3,
    cost: 1550,
    blurb: 'Fast tournament-style bite timing between casts.',
    waitMsMin: 900,
    waitMsMax: 2400,
    biteWindowMs: 4800,
  ),
  FishingRodDef(
    id: 'aurora',
    name: 'Aurora Legend',
    tier: 4,
    cost: 5280,
    blurb: 'Shortest waits — you’re back on the bite window fast.',
    waitMsMin: 650,
    waitMsMax: 1850,
    biteWindowMs: 5600,
  ),
];

FishingBoatDef boatById(String id) =>
    kBoats.firstWhere((b) => b.id == id, orElse: () => kBoats.first);

FishingRodDef rodById(String id) =>
    kRods.firstWhere((r) => r.id == id, orElse: () => kRods.first);

FishSpecies speciesById(String id) =>
    kAllFish.firstWhere((f) => f.id == id, orElse: () => kAllFish.first);

/// Full rod sweep: left (–1) → middle (0) → right (+1) → back to left, for [t] in [0,1].
double rodSweepTriangleAim(double t) {
  final u = t.clamp(0.0, 1.0);
  const third = 1.0 / 3.0;
  double lerp(double a, double b, double f) => a + (b - a) * f;
  if (u < third) return lerp(-1.0, 0.0, u / third);
  if (u < 2 * third) return lerp(0.0, 1.0, (u - third) / third);
  return lerp(1.0, -1.0, (u - 2 * third) / third);
}

/// Target mix at tier‑0 dinghy stays 50 : 20 : 15 : 5 : 1 (Common/Rare/"W", Legendary mid, Secret, Special peak).
/// Better boats crush **Common & Rare**, lift **Legendary** modestly, and spike **Secret** then **Special** (best).
List<double> rarityWeights(int boatTier) {
  final t = boatTier.clamp(0, 4) / 4.0;
  return [
    FishRarity.common.targetWeight *
        (1.0 - 0.88 * t).clamp(0.14, 1.0), // hard “W” falloff
    FishRarity.rare.targetWeight *
        (1.0 - 0.78 * t).clamp(0.11, 1.0),
    FishRarity.legendary.targetWeight *
        (1.0 + 0.42 * t - 0.14 * t * t), // middle tier — slower climb than Secret/Special
    FishRarity.secret.targetWeight *
        (1.0 + 1.12 * t + 0.92 * t * t),
    FishRarity.special.targetWeight *
        (1.0 + 3.1 * t + 5.2 * t * t),
  ];
}

/// Boat tier plus cast position: corners favor Common/Rare; **center** favors Secret/Special more than Legendary
/// (legendary is middling rarity — tepid bite in the sweet spot vs the two best tiers).
List<double> rarityWeightsForAim(int boatTier, double lockedAimX) {
  final w = rarityWeights(boatTier);
  final d = lockedAimX.abs().clamp(0.0, 1.0);
  final centerEase = 1.0 - d;
  return [
    w[0] * (1.0 + 0.52 * d),
    w[1] * (1.0 + 0.38 * d),
    w[2] * (0.50 + 0.95 * d), // weaker at dead center than Secret/Special
    w[3] * (0.14 + 0.86 * centerEase),
    w[4] * (0.03 + 0.97 * centerEase),
  ];
}

/// Hard caps per boat **tier**: Lake Rowboat can't roll Common; Motorboat adds no Rare;
/// Coastal Yacht adds no Legendary (“lucky”); Secret fish need **tier ≥ 3** (yacht);
/// Special fish **only Research Trawler (tier 4)**.
List<double> applyBoatTierRarityCaps(List<double> weights, int boatTier) {
  final w = List<double>.from(weights);
  final t = boatTier.clamp(0, 4);

  if (t >= 1) w[FishRarity.common.index] = 0;
  if (t >= 2) w[FishRarity.rare.index] = 0;
  if (t >= 3) w[FishRarity.legendary.index] = 0;
  if (t < 3) {
    w[FishRarity.secret.index] = 0;
    w[FishRarity.special.index] = 0;
  } else if (t < 4) {
    w[FishRarity.special.index] = 0;
  }

  return w;
}

/// When aim + curves zero everything, still return something legal for this tier.
FishRarity _fallbackRarityForBoatTier(int boatTier) {
  final t = boatTier.clamp(0, 4);
  if (t >= 4) return FishRarity.special;
  if (t >= 3) return FishRarity.secret;
  if (t >= 2) return FishRarity.legendary;
  if (t >= 1) return FishRarity.rare;
  return FishRarity.common;
}

FishRarity rollRarity(Random rng, int boatTier, double lockedAimX) {
  var weights =
      applyBoatTierRarityCaps(rarityWeightsForAim(boatTier, lockedAimX), boatTier);
  final sum = weights.fold<double>(0, (a, b) => a + b);
  if (sum <= 0) {
    weights = applyBoatTierRarityCaps(
      List<double>.filled(FishRarity.values.length, 1.0),
      boatTier,
    );
    final sum2 = weights.fold<double>(0, (a, b) => a + b);
    if (sum2 <= 0) return _fallbackRarityForBoatTier(boatTier);
  }

  final total = weights.fold<double>(0, (a, b) => a + b);
  var roll = rng.nextDouble() * total;
  for (var i = 0; i < FishRarity.values.length; i++) {
    roll -= weights[i];
    if (roll <= 0) return FishRarity.values[i];
  }
  return _fallbackRarityForBoatTier(boatTier);
}

FishSpecies rollFish(Random rng, int boatTier, double lockedAimX) {
  final rarity = rollRarity(rng, boatTier, lockedAimX);
  final pool = kAllFish.where((f) => f.rarity == rarity).toList();
  return pool[rng.nextInt(pool.length)];
}
