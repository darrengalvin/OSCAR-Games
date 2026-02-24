import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  SaveService._();
  static final SaveService _instance = SaveService._();
  static SaveService get instance => _instance;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Target Shooter Player Data ---

  Future<void> savePlayerData({
    required int diamonds,
    required List<String> ownedBowIds,
    required String equippedBowId,
    required bool hasVip,
    required bool hasShieldKeychain,
    required Map<String, int> worldProgress,
    required int totalTargetsHit,
    required int totalLevelsCompleted,
  }) async {
    await _prefs.setInt('diamonds', diamonds);
    await _prefs.setStringList('ownedBowIds', ownedBowIds);
    await _prefs.setString('equippedBowId', equippedBowId);
    await _prefs.setBool('hasVip', hasVip);
    await _prefs.setBool('hasShieldKeychain', hasShieldKeychain);
    await _prefs.setString('worldProgress', jsonEncode(worldProgress));
    await _prefs.setInt('totalTargetsHit', totalTargetsHit);
    await _prefs.setInt('totalLevelsCompleted', totalLevelsCompleted);
  }

  int get diamonds => _prefs.getInt('diamonds') ?? 25;
  List<String> get ownedBowIds =>
      _prefs.getStringList('ownedBowIds') ?? ['default'];
  String get equippedBowId => _prefs.getString('equippedBowId') ?? 'default';
  bool get hasVip => _prefs.getBool('hasVip') ?? false;
  bool get hasShieldKeychain => _prefs.getBool('hasShieldKeychain') ?? false;
  int get totalTargetsHit => _prefs.getInt('totalTargetsHit') ?? 0;
  int get totalLevelsCompleted => _prefs.getInt('totalLevelsCompleted') ?? 0;

  Map<String, int> get worldProgress {
    final raw = _prefs.getString('worldProgress');
    if (raw == null) {
      return {'playground': 1, 'jupiter': 1, 'backrooms': 1};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  bool get hasPlayerData => _prefs.getInt('diamonds') != null;

  // --- Game High Scores ---

  Future<void> saveHighScore(String gameId, int score) async {
    final key = 'highscore_$gameId';
    final current = _prefs.getInt(key) ?? 0;
    if (score > current) {
      await _prefs.setInt(key, score);
    }
  }

  int getHighScore(String gameId) {
    return _prefs.getInt('highscore_$gameId') ?? 0;
  }

  // --- Snake ---

  Future<void> saveSnakeHighScore(int score) =>
      saveHighScore('snake', score);
  int get snakeHighScore => getHighScore('snake');

  // --- Tic Tac Toe ---

  Future<void> saveTicTacToeStats({
    required int winsX,
    required int winsO,
    required int draws,
  }) async {
    await _prefs.setInt('ttt_winsX', winsX);
    await _prefs.setInt('ttt_winsO', winsO);
    await _prefs.setInt('ttt_draws', draws);
  }

  int get tttWinsX => _prefs.getInt('ttt_winsX') ?? 0;
  int get tttWinsO => _prefs.getInt('ttt_winsO') ?? 0;
  int get tttDraws => _prefs.getInt('ttt_draws') ?? 0;

  // --- Memory Match ---

  Future<void> saveMemoryBestMoves(int gridSize, int moves) async {
    final key = 'memory_best_${gridSize}x$gridSize';
    final current = _prefs.getInt(key);
    if (current == null || moves < current) {
      await _prefs.setInt(key, moves);
    }
  }

  Future<void> saveMemoryBestTime(int gridSize, int seconds) async {
    final key = 'memory_time_${gridSize}x$gridSize';
    final current = _prefs.getInt(key);
    if (current == null || seconds < current) {
      await _prefs.setInt(key, seconds);
    }
  }

  int? memoryBestMoves(int gridSize) =>
      _prefs.getInt('memory_best_${gridSize}x$gridSize');
  int? memoryBestTime(int gridSize) =>
      _prefs.getInt('memory_time_${gridSize}x$gridSize');

  // --- Reaction Speed ---

  Future<void> saveReactionBest(int ms) async {
    final current = _prefs.getInt('reaction_best');
    if (current == null || ms < current) {
      await _prefs.setInt('reaction_best', ms);
    }
  }

  Future<void> saveReactionGamesPlayed(int count) async {
    await _prefs.setInt('reaction_played', count);
  }

  int? get reactionBest => _prefs.getInt('reaction_best');
  int get reactionGamesPlayed => _prefs.getInt('reaction_played') ?? 0;
}
