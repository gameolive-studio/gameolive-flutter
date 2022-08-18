import 'gameolive_platform_interface.dart';
import 'models/badgesResponse.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'models/launchConfig.dart';
import 'models/playerBalance.dart';
import 'models/player_achievement.dart';
import 'models/transaction.dart';
import 'models/transactionsResponse.dart';
import 'shared/playmode.dart';

// ignore: non_constant_identifier_names
Config? CONFIG;

class Gameolive {
  Future<String?> getPlatformVersion() {
    return GameolivePlatform.instance.getPlatformVersion();
  }

  Future<String?> init(Config config) async {
    return GameolivePlatform.instance.init(config);
  }

  Future<GamesResponse> getGames(int limit, int offset,
      [Config? config]) async {
    return GameolivePlatform.instance.getGames(limit, offset, config);
  }

  Future<String> getGameUrl(LaunchConfig? gameLaunchConfig) async {
    return GameolivePlatform.instance.getGameUrl(gameLaunchConfig);
  }

  Future<String> getPlayerToken(String playerUid, PlayMode playMode,
      [Config? config]) {
    return GameolivePlatform.instance
        .getPlayerToken(playerUid, playMode, config);
  }

  /* Wallet Related API's*/
  Future<PlayerBalance> getPlayerBalance(
      String playerToken, String playerUid, PlayMode playMode, Config config) {
    return GameolivePlatform.instance
        .getPlayerBalance(playerToken, playerUid, playMode, config);
  }

  Future<PlayerBalance> depositToPlayerAccount(
      String playerUid, Transaction transaction, Config config) {
    return GameolivePlatform.instance
        .depositToPlayerAccount(playerUid, transaction, config);
  }

  Future<TransactionsResponse> getPlayerAccountHistory(String playerUid,
      PlayMode playMode, int offset, int limit, Config config) {
    return GameolivePlatform.instance
        .getPlayerAccountHistory(playerUid, playMode, offset, limit, config);
  }

  Future<List<PlayerAchievement>> getPlayerAchievements(
      String playerToken, String playerUid,
      [Config? config]) async {
    return GameolivePlatform.instance
        .getPlayerAchievements(playerToken, playerUid, config);
  }

  Future<List<PlayerAchievement>> acknowledgePlayerAchievement(
      String playerToken, String playerUid, String achievementId,
      [Config? config]) async {
    return GameolivePlatform.instance.acknowledgePlayerAchievement(
        playerToken, playerUid, achievementId, config);
  }

  Future<List<PlayerAchievement>> notifyPlayerAction(
      String playerToken, String playerUid, String action, String value,
      [Config? config]) async {
    return GameolivePlatform.instance
        .notifyPlayerAction(playerToken, playerUid, action, value, config);
  }

  Future<BadgesResponse> getAvailableBadges([Config? config]) async {
    config ??= CONFIG!;
    return GameolivePlatform.instance.getAvailableBadges(config);
  }

  Future<List<String>> getBadgesEarnedByPlayer(
      String playerUid, PlayMode playMode,
      [Config? config]) async {
    config ??= CONFIG!;
    return GameolivePlatform.instance
        .getBadgesEarnedByPlayer(playerUid, playMode, config);
  }
}
