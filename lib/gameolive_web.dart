// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'gameolive_method_channel.dart';
import 'gameolive_platform_interface.dart';

import 'models/badgesResponse.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'models/launchConfig.dart';
import 'models/playerBalance.dart';
import 'models/player_achievement.dart';
import 'models/transaction.dart';
import 'models/transactionsResponse.dart';
import 'services/playerService.dart';
import 'shared/playmode.dart';

// ignore: non_constant_identifier_names
Config? CONFIG;

/// A web implementation of the GameolivePlatform of the Gameolive plugin.
class GameoliveWeb extends GameolivePlatform {
  /// Constructs a GameoliveWeb
  GameoliveWeb();
  static MethodChannelGameolive gameolive = MethodChannelGameolive();
  static void registerWith(Registrar registrar) {
    GameolivePlatform.instance = GameoliveWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<String?> init(Config config) async {
    return gameolive.init(config);
  }

  @override
  Future<GamesResponse> getGames(int limit, int offset,
      [Config? config]) async {
    return gameolive.getGames(limit, offset, config);
  }

  @override
  Future<String> getGameUrl(LaunchConfig? gameLaunchConfig) async {
    return gameolive.getGameUrl(gameLaunchConfig);
  }

  @override
  Future<String> getPlayerToken(String playerUid, PlayMode playMode,
      [Config? config]) {
    return gameolive.getPlayerToken(playerUid, playMode, config);
  }

  /* Wallet Related API's*/
  @override
  Future<PlayerBalance> getPlayerBalance(
      String playerToken, String playerUid, PlayMode playMode, Config config) {
    return gameolive.getPlayerBalance(playerToken, playerUid, playMode, config);
  }

  @override
  Future<PlayerBalance> depositToPlayerAccount(
      String playerUid, Transaction transaction, Config config) {
    return gameolive.depositToPlayerAccount(playerUid, transaction, config);
  }

  @override
  Future<TransactionsResponse> getPlayerAccountHistory(String playerUid,
      PlayMode playMode, int offset, int limit, Config config) {
    return gameolive.getPlayerAccountHistory(
        playerUid, playMode, offset, limit, config);
  }

  @override
  Future<BadgesResponse> getAvailableBadges([Config? config]) async {
    config ??= CONFIG!;
    return gameolive.getAvailableBadges(config);
  }

  @override
  Future<List<String>> getBadgesEarnedByPlayer(
      String playerUid, PlayMode playMode,
      [Config? config]) async {
    config ??= CONFIG!;
    return gameolive.getBadgesEarnedByPlayer(playerUid, playMode, config);
  }

  @override
  Future<List<PlayerAchievement>> notifyPlayerAction(
      String playerToken, String playerUid, String action, String value,
      [Config? config]) {
    return gameolive.notifyPlayerAction(playerToken, playerUid, action, value, config);
  }
}
