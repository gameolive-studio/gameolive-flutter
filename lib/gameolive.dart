import 'dart:async';
import 'package:gameolive/models/badgesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:gameolive/services/badgesService.dart';
import 'package:gameolive/services/playerService.dart';
import 'package:gameolive/services/walletService.dart';
import 'package:gameolive/shared/playmode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'models/auth.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'models/playerBalance.dart';
import 'models/transaction.dart';
import 'models/transactionsResponse.dart';
import 'services/authService.dart';
import 'services/gamesService.dart';

Config? CONFIG;

class Gameolive {
  static const MethodChannel _channel = const MethodChannel('gameolive');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> init(Config config) async {
    final Auth auth = await authenticate(config);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (auth.token != null) {
      await prefs.setString('token', auth.token ?? "");
    }
    CONFIG = config;
    CONFIG!.token = auth.token;
    return auth.token;
  }

  static Future<GamesResponse> getGames(int limit, int offset,
      [Config? config]) async {
    if (config == null) {
      config = CONFIG!;
    }
    return fetchGames(limit, offset, config);
  }

  static Future<String> getGameUrl(LaunchConfig? gameLaunchConfig) async {
    return fetchGameUrl(gameLaunchConfig, CONFIG!);
  }

  static Future<String> getPlayerToken(String playerUid, PlayMode playMode,
      [Config? config]) {
    return fetchPlayerToken(playerUid, playMode, CONFIG!);
  }

  /* Wallet Related API's*/
  static Future<PlayerBalance> getPlayerBalance(
      String playerUid, PlayMode playMode, Config config) {
    return fetchPlayerBalance(playerUid, playMode, config);
  }

  static Future<PlayerBalance> depositToPlayerAccount(
      String playerUid, Transaction transaction, Config config) {
    return creditToPlayerWallet(playerUid, transaction, config);
  }

  static Future<TransactionsResponse> getPlayerAccountHistory(String playerUid,
      PlayMode playMode, int offset, int limit, Config config) {
    return fetchPlayerAccountHistory(
        playerUid, playMode, offset, limit, config);
  }

  static Future<BadgesResponse> getAvailableBadges([Config? config]) async {
    if (config == null) {
      config = CONFIG!;
    }
    return fetchAvailableBadges(config);
  }

  static Future<List<String>> getBadgesEarnedByPlayer(
      String playerUid, PlayMode playMode,
      [Config? config]) async {
    if (config == null) {
      config = CONFIG!;
    }
    return fetchUserBadges(playerUid, playMode, config);
  }
}
