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
      String playerUid, PlayMode playMode, Config config) {
    return GameolivePlatform.instance
        .getPlayerBalance(playerUid, playMode, config);
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

  Future<List<PlayerAchievement>> getPlayerAchievements(String playerUid,
      [Config? config]) async {
    return GameolivePlatform.instance.getPlayerAchievements(playerUid, config);
  }

  Future<dynamic> acknowledgePlayerAchievement(
      String achievementId, String playerUid,
      [Config? config]) async {
    return GameolivePlatform.instance
        .acknowledgePlayerAchievement(achievementId, playerUid, config);
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
