import '../../../services/save_service.dart';
import 'bow.dart';

class PlayerData {
  int diamonds;
  List<String> ownedBowIds;
  String equippedBowId;
  bool hasVip;
  bool hasShieldKeychain;
  Map<String, int> worldProgress;
  int totalTargetsHit;
  int totalLevelsCompleted;

  PlayerData({
    this.diamonds = 25,
    List<String>? ownedBowIds,
    this.equippedBowId = 'default',
    this.hasVip = false,
    this.hasShieldKeychain = false,
    Map<String, int>? worldProgress,
    this.totalTargetsHit = 0,
    this.totalLevelsCompleted = 0,
  })  : ownedBowIds = ownedBowIds ?? ['default'],
        worldProgress = worldProgress ?? {
          'playground': 1,
          'jupiter': 1,
          'backrooms': 1,
        };

  factory PlayerData.fromSave() {
    final save = SaveService.instance;
    return PlayerData(
      diamonds: save.diamonds,
      ownedBowIds: List<String>.from(save.ownedBowIds),
      equippedBowId: save.equippedBowId,
      hasVip: save.hasVip,
      hasShieldKeychain: save.hasShieldKeychain,
      worldProgress: Map<String, int>.from(save.worldProgress),
      totalTargetsHit: save.totalTargetsHit,
      totalLevelsCompleted: save.totalLevelsCompleted,
    );
  }

  Future<void> save() async {
    await SaveService.instance.savePlayerData(
      diamonds: diamonds,
      ownedBowIds: ownedBowIds,
      equippedBowId: equippedBowId,
      hasVip: hasVip,
      hasShieldKeychain: hasShieldKeychain,
      worldProgress: worldProgress,
      totalTargetsHit: totalTargetsHit,
      totalLevelsCompleted: totalLevelsCompleted,
    );
  }

  void addDiamonds(int amount) {
    diamonds += amount;
    save();
  }

  bool spendDiamonds(int amount) {
    if (diamonds >= amount) {
      diamonds -= amount;
      save();
      return true;
    }
    return false;
  }

  bool ownsBow(String bowId) => ownedBowIds.contains(bowId);

  void unlockBow(String bowId) {
    if (!ownedBowIds.contains(bowId)) {
      ownedBowIds.add(bowId);
      save();
    }
  }

  void equipBow(String bowId) {
    if (ownedBowIds.contains(bowId)) {
      equippedBowId = bowId;
      save();
    }
  }

  Bow get equippedBow {
    if (equippedBowId == 'default') return Bow.defaultBow;
    return Bow.allBows.firstWhere(
      (b) => b.id == equippedBowId,
      orElse: () => Bow.defaultBow,
    );
  }

  int currentLevel(String worldId) => worldProgress[worldId] ?? 1;

  void completeLevel(String worldId) {
    final current = worldProgress[worldId] ?? 1;
    if (current < 20) {
      worldProgress[worldId] = current + 1;
    }
    totalLevelsCompleted++;
    diamonds += 5;
    save();
  }
}
