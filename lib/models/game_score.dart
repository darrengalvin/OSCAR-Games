class GameScore {
  final String gameId;
  final int score;
  final DateTime playedAt;
  final Duration duration;

  GameScore({
    required this.gameId,
    required this.score,
    required this.duration,
    DateTime? playedAt,
  }) : playedAt = playedAt ?? DateTime.now();
}

class ScoreBoard {
  final Map<String, List<GameScore>> _scores = {};

  void addScore(GameScore score) {
    _scores.putIfAbsent(score.gameId, () => []);
    _scores[score.gameId]!.add(score);
    _scores[score.gameId]!.sort((a, b) => b.score.compareTo(a.score));
    if (_scores[score.gameId]!.length > 10) {
      _scores[score.gameId] = _scores[score.gameId]!.sublist(0, 10);
    }
  }

  List<GameScore> getScores(String gameId) {
    return _scores[gameId] ?? [];
  }

  int? getHighScore(String gameId) {
    final scores = _scores[gameId];
    if (scores == null || scores.isEmpty) return null;
    return scores.first.score;
  }
}
