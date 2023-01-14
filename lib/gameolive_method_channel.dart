import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gameolive/models/leader.dart';

import 'gameolive_platform_interface.dart';

import 'package:gameolive/models/badgesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:gameolive/services/badgesService.dart';
import 'package:gameolive/services/playerService.dart';
import 'package:gameolive/services/walletService.dart';
import 'package:gameolive/shared/playmode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'models/playerBalance.dart';
import 'models/player_achievement.dart';
import 'models/transaction.dart';
import 'models/transactionsResponse.dart';
import 'services/authService.dart';
import 'services/gamesService.dart';

// ignore: non_constant_identifier_names
Config? CONFIG;

/// An implementation of [GameolivePlatform] that uses method channels.
class MethodChannelGameolive extends GameolivePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gameolive');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> init(Config config) async {
    final Auth auth = await authenticate(config);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (auth.token != null) {
      await prefs.setString('gol_token', auth.token ?? "");
    }
    CONFIG = config;
    CONFIG!.token = auth.token;
    return auth.token;
  }

  @override
  Future<GamesResponse> getGames(int limit, int offset,
      [Config? config]) async {
    config ??= CONFIG!;
    return fetchGames(limit, offset, config);
  }

  @override
  Future<String> getGameUrl(LaunchConfig? gameLaunchConfig) async {
    return fetchGameUrl(gameLaunchConfig, CONFIG!);
  }

  @override
  Future<String> getPlayerToken(String playerUid, PlayMode playMode,
      [Config? config]) {
    config ??= CONFIG!;
    return fetchPlayerToken(playerUid, playMode, config);
  }

  /* Wallet Related API's*/
  @override
  Future<PlayerBalance> getPlayerBalance(
      String playerToken, String playerUid, PlayMode playMode, Config config) {
    return fetchPlayerBalance(playerToken, playerUid, playMode, config);
  }

  @override
  Future<PlayerBalance> depositToPlayerAccount(
      String playerUid, Transaction transaction, Config config) {
    return creditToPlayerWallet(playerUid, transaction, config);
  }

  @override
  Future<TransactionsResponse> getPlayerAccountHistory(String playerUid,
      PlayMode playMode, int offset, int limit, Config config) {
    return fetchPlayerAccountHistory(
        playerUid, playMode, offset, limit, config);
  }

  @override
  Future<BadgesResponse> getAvailableBadges([Config? config]) async {
    config ??= CONFIG!;
    return fetchAvailableBadges(config);
  }

  @override
  Future<List<String>> getBadgesEarnedByPlayer(
      String playerUid, PlayMode playMode,
      [Config? config]) async {
    config ??= CONFIG!;
    return fetchUserBadges(playerUid, playMode, config);
  }

  @override
  Future<List<PlayerAchievement>> getPlayerAchievements(
      String playerToken, String playerUid,
      [Config? config]) async {
    config ??= CONFIG!;
    return fetchPlayerAchievements(playerToken, playerUid, config);
  }

  @override
  Future<List<PlayerAchievement>> acknowledgePlayerAchievement(
      String playerToken, String playerUid, String achievementId,
      [Config? config]) async {
    config ??= CONFIG!;
    return setAcknowledgementOfPlayerAchievement(
        playerToken, playerUid, achievementId, config);
  }

  @override
  Future<List<PlayerAchievement>> notifyPlayerAction(
      String playerToken, String playerUid, String action, String value,
      [Config? config]) {
    config ??= CONFIG!;
    return registerPlayerAction(playerToken, playerUid, action, value, config);
  }

  @override
  Future<List<Leader>> getLeaderBoard(
      String playerToken, String playerUid, String challengeId, int limit,
      [Config? config]) {
    config ??= CONFIG!;
    return fetchLeaderBoard(playerToken, playerUid, challengeId, limit, config);
  }
}
