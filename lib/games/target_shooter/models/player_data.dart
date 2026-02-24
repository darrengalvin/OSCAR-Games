import '../../../services/save_service.dart';
import 'bow.dart';

class PlayerData {
  int diamonds;
  List<String> ownedBowIds;
  List<String> ownedArrowIds;
  String equippedBowId;
  String equippedArrowId;
  bool hasVip;
  bool hasShieldKeychain;
  bool has67Keychain;
  bool hasComboKeychain;
  Map<String, int> worldProgress;
  int totalTargetsHit;
  int totalLevelsCompleted;

  static const int maxLevel = 50;

  PlayerData({
    this.diamonds = 25,
    List<String>? ownedBowIds,
    List<String>? ownedArrowIds,
    this.equippedBowId = 'default',
    this.equippedArrowId = 'default',
    this.hasVip = false,
    this.hasShieldKeychain = false,
    this.has67Keychain = false,
    this.hasComboKeychain = false,
    Map<String, int>? worldProgress,
    this.totalTargetsHit = 0,
    this.totalLevelsCompleted = 0,
  })  : ownedBowIds = ownedBowIds ?? ['default'],
        ownedArrowIds = ownedArrowIds ?? ['default'],
        worldProgress = worldProgress ?? {
          'playground': 1,
          'jupiter': 1,
          'backrooms': 1,
          'bedroom': 1,
        };

  factory PlayerData.fromSave() {
    final save = SaveService.instance;
    return PlayerData(
      diamonds: save.diamonds,
      ownedBowIds: List<String>.from(save.ownedBowIds),
      ownedArrowIds: List<String>.from(save.ownedArrowIds),
      equippedBowId: save.equippedBowId,
      equippedArrowId: save.equippedArrowId,
      hasVip: save.hasVip,
      hasShieldKeychain: save.hasShieldKeychain,
      has67Keychain: save.has67Keychain,
      hasComboKeychain: save.hasComboKeychain,
      worldProgress: Map<String, int>.from(save.worldProgress),
      totalTargetsHit: save.totalTargetsHit,
      totalLevelsCompleted: save.totalLevelsCompleted,
    );
  }

  Future<void> save() async {
    await SaveService.instance.savePlayerData(
      diamonds: diamonds,
      ownedBowIds: ownedBowIds,
      ownedArrowIds: ownedArrowIds,
      equippedBowId: equippedBowId,
      equippedArrowId: equippedArrowId,
      hasVip: hasVip,
      hasShieldKeychain: hasShieldKeychain,
      has67Keychain: has67Keychain,
      hasComboKeychain: hasComboKeychain,
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
  bool ownsArrow(String arrowId) => ownedArrowIds.contains(arrowId);

  void unlockBow(String bowId) {
    if (!ownedBowIds.contains(bowId)) {
      ownedBowIds.add(bowId);
      save();
    }
  }

  void unlockArrow(String arrowId) {
    if (!ownedArrowIds.contains(arrowId)) {
      ownedArrowIds.add(arrowId);
      save();
    }
  }

  void equipBow(String bowId) {
    if (ownedBowIds.contains(bowId)) {
      equippedBowId = bowId;
      save();
    }
  }

  void equipArrow(String arrowId) {
    if (ownedArrowIds.contains(arrowId)) {
      equippedArrowId = arrowId;
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

  ArrowSkin get equippedArrow {
    if (equippedArrowId == 'default') return ArrowSkin.defaultArrow;
    return ArrowSkin.allArrows.firstWhere(
      (a) => a.id == equippedArrowId,
      orElse: () => ArrowSkin.defaultArrow,
    );
  }

  int currentLevel(String worldId) => worldProgress[worldId] ?? 1;

  void completeLevel(String worldId, {int diamondReward = 5}) {
    final current = worldProgress[worldId] ?? 1;
    if (current < maxLevel) {
      worldProgress[worldId] = current + 1;
    }
    totalLevelsCompleted++;
    diamonds += diamondReward;
    save();
  }

  bool get hasDarkShadowBow => ownsBow('dark_shadow');

  int get totalKeychains {
    int count = 0;
    if (hasShieldKeychain) count++;
    if (has67Keychain) count++;
    return count;
  }
}
