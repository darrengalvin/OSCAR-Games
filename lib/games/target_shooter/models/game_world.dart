import 'package:flutter/material.dart';

class GameWorld {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color targetColor;
  final bool isNight;

  const GameWorld({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.targetColor,
    this.isNight = false,
  });

  static const List<GameWorld> worlds = [
    GameWorld(
      id: 'playground',
      name: 'The Playground',
      description: 'A dark playground under the stars. Hit targets in the moonlight!',
      icon: Icons.park_rounded,
      primaryColor: Color(0xFF1A237E),
      secondaryColor: Color(0xFF4A148C),
      backgroundColor: Color(0xFF0D0D2B),
      targetColor: Color(0xFF66FCF1),
      isNight: true,
    ),
    GameWorld(
      id: 'jupiter',
      name: 'Jupiter',
      description: 'The swirling gas giant. Targets float among the storms!',
      icon: Icons.public_rounded,
      primaryColor: Color(0xFFD4A76A),
      secondaryColor: Color(0xFFC06000),
      backgroundColor: Color(0xFF2D1810),
      targetColor: Color(0xFFFF6B35),
    ),
    GameWorld(
      id: 'backrooms',
      name: 'The Backrooms',
      description: 'Endless yellow rooms. Find and hit the targets to escape!',
      icon: Icons.door_back_door_rounded,
      primaryColor: Color(0xFFB8A44C),
      secondaryColor: Color(0xFF8B7D3C),
      backgroundColor: Color(0xFF3D3520),
      targetColor: Color(0xFFFF4444),
    ),
  ];
}
