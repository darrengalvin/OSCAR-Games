import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();
  static final SoundService _instance = SoundService._();
  static SoundService get instance => _instance;

  final Map<String, AudioPlayer> _players = {};
  bool _muted = false;

  bool get isMuted => _muted;

  void toggleMute() {
    _muted = !_muted;
  }

  Future<void> play(GameSound sound) async {
    if (_muted) return;
    try {
      final key = sound.file;
      _players[key]?.dispose();
      final player = AudioPlayer();
      _players[key] = player;
      await player.play(AssetSource('sounds/${sound.file}'));
    } catch (_) {}
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}

enum GameSound {
  tap('tap.mp3'),
  countdownTick('countdown_tick.mp3'),
  countdown('countdown.mp3'),
  shoot('shoot.mp3'),
  hit('hit.mp3'),
  bowTwang('bow_twang.mp3'),
  levelComplete('level_complete.mp3'),
  levelFail('level_fail.mp3'),
  place('place.mp3'),
  win('win.mp3'),
  draw('draw.mp3'),
  cardFlip('card_flip.mp3'),
  match('match.mp3'),
  noMatch('no_match.mp3'),
  eat('eat.mp3'),
  gameOver('game_over.mp3'),
  reactionTap('reaction_tap.mp3'),
  tooEarly('too_early.mp3');

  final String file;
  const GameSound(this.file);
}
