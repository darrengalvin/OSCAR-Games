import 'package:flutter/material.dart';

enum BowRarity { common, uncommon, rare, epic, legendary }

class Bow {
  final String id;
  final String name;
  final List<Color> colors;
  final BowRarity rarity;
  final bool hasMoodMode;
  final int diamondPrice;

  const Bow({
    required this.id,
    required this.name,
    required this.colors,
    this.rarity = BowRarity.common,
    this.hasMoodMode = false,
    this.diamondPrice = 0,
  });

  Color get primaryColor => colors.first;

  static const Bow defaultBow = Bow(
    id: 'default',
    name: 'Basic Bow',
    colors: [Color(0xFF8B4513)],
    rarity: BowRarity.common,
  );

  static const List<Bow> allBows = [
    Bow(
      id: 'rainbow',
      name: 'Rainbow Bow',
      colors: [
        Color(0xFFFF0000),
        Color(0xFFFF7F00),
        Color(0xFFFFFF00),
        Color(0xFF00FF00),
        Color(0xFF0000FF),
        Color(0xFF4B0082),
        Color(0xFF9400D3),
      ],
      rarity: BowRarity.legendary,
      hasMoodMode: true,
      diamondPrice: 500,
    ),
    Bow(
      id: 'red_orange',
      name: 'Red & Orange Bow',
      colors: [Color(0xFFE53E3E), Color(0xFFED8936)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'yellow_green',
      name: 'Yellow & Green Bow',
      colors: [Color(0xFFECC94B), Color(0xFF48BB78)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'blue_purple',
      name: 'Blue & Purple Bow',
      colors: [Color(0xFF4299E1), Color(0xFF9F7AEA)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'pink',
      name: 'Pink Bow',
      colors: [Color(0xFFED64A6)],
      rarity: BowRarity.common,
      diamondPrice: 75,
    ),
    Bow(
      id: 'orange_purple',
      name: 'Orange & Purple Bow',
      colors: [Color(0xFFED8936), Color(0xFF9F7AEA)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'yellow_orange',
      name: 'Yellow & Orange Bow',
      colors: [Color(0xFFECC94B), Color(0xFFED8936)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'red_pink',
      name: 'Red & Pink Bow',
      colors: [Color(0xFFE53E3E), Color(0xFFED64A6)],
      rarity: BowRarity.uncommon,
      diamondPrice: 100,
    ),
    Bow(
      id: 'gold',
      name: 'Gold Bow',
      colors: [Color(0xFFD4AF37), Color(0xFFFBD38D)],
      rarity: BowRarity.rare,
      diamondPrice: 200,
    ),
    Bow(
      id: 'neon_green',
      name: 'Neon Green Bow',
      colors: [Color(0xFF39FF14), Color(0xFF00FF41)],
      rarity: BowRarity.rare,
      diamondPrice: 200,
    ),
  ];

  static Color rarityColor(BowRarity rarity) {
    switch (rarity) {
      case BowRarity.common:
        return const Color(0xFFA0AEC0);
      case BowRarity.uncommon:
        return const Color(0xFF48BB78);
      case BowRarity.rare:
        return const Color(0xFF4299E1);
      case BowRarity.epic:
        return const Color(0xFF9F7AEA);
      case BowRarity.legendary:
        return const Color(0xFFECC94B);
    }
  }

  static String rarityLabel(BowRarity rarity) {
    switch (rarity) {
      case BowRarity.common:
        return 'Common';
      case BowRarity.uncommon:
        return 'Uncommon';
      case BowRarity.rare:
        return 'Rare';
      case BowRarity.epic:
        return 'Epic';
      case BowRarity.legendary:
        return 'Legendary';
    }
  }
}

class MoodMode {
  static const List<MoodPreset> presets = [
    MoodPreset(
      name: 'Ocean',
      colors: [Color(0xFF4299E1), Color(0xFF0BC5EA)],
    ),
    MoodPreset(
      name: 'Sunset',
      colors: [Color(0xFFED8936), Color(0xFFECC94B)],
    ),
    MoodPreset(
      name: 'Forest',
      colors: [Color(0xFF48BB78), Color(0xFF38A169)],
    ),
    MoodPreset(
      name: 'Clean',
      colors: [Color(0xFFFFFFFF)],
    ),
  ];
}

class MoodPreset {
  final String name;
  final List<Color> colors;

  const MoodPreset({required this.name, required this.colors});
}
