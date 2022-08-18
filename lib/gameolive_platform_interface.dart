import 'package:gameolive/models/player_achievement.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gameolive_method_channel.dart';
import 'models/badgesResponse.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'models/launchConfig.dart';
import 'models/playerBalance.dart';
import 'models/transaction.dart';
import 'models/transactionsResponse.dart';
import 'shared/playmode.dart';

abstract class GameolivePlatform extends PlatformInterface {
  /// Constructs a GameolivePlatform.
  GameolivePlatform() : super(token: _token);

  static final Object _token = Object();

  static GameolivePlatform _instance = MethodChannelGameolive();

  /// The default instance of [GameolivePlatform] to use.
  ///
  /// Defaults to [MethodChannelGameolive].
  static GameolivePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GameolivePlatform] when
  /// they register themselves.
  static set instance(GameolivePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<String?> init(Config config) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<GamesResponse> getGames(int limit, int offset,
      [Config? config]) async {
    throw UnimplementedError('getGames() has not been implemented.');
  }

  Future<String> getGameUrl(LaunchConfig? gameLaunchConfig) async {
    throw UnimplementedError('getGameUrl() has not been implemented.');
  }

  Future<String> getPlayerToken(String playerUid, PlayMode playMode,
      [Config? config]) {
    throw UnimplementedError('getPlayerToken() has not been implemented.');
  }

  /* Wallet Related API's*/
  Future<PlayerBalance> getPlayerBalance(
      String playerToken, String playerUid, PlayMode playMode, Config config) {
    throw UnimplementedError('getPlayerBalance() has not been implemented.');
  }

  Future<PlayerBalance> depositToPlayerAccount(
      String playerUid, Transaction transaction, Config config) {
    throw UnimplementedError(
        'depositToPlayerAccount() has not been implemented.');
  }

  Future<TransactionsResponse> getPlayerAccountHistory(String playerUid,
      PlayMode playMode, int offset, int limit, Config config) {
    throw UnimplementedError(
        'getPlayerAccountHistory() has not been implemented.');
  }

  Future<BadgesResponse> getAvailableBadges([Config? config]) async {
    throw UnimplementedError('getAvailableBadges() has not been implemented.');
  }

  Future<List<String>> getBadgesEarnedByPlayer(
      String playerUid, PlayMode playMode,
      [Config? config]) async {
    throw UnimplementedError(
        'getBadgesEarnedByPlayer() has not been implemented.');
  }

  Future<List<PlayerAchievement>> getPlayerAchievements(
      String playerToken, String playerUid,
      [Config? config]) async {
    throw UnimplementedError('getAvailableBadges() has not been implemented.');
  }

  Future<List<PlayerAchievement>> acknowledgePlayerAchievement(
      String playerToken, String playerUid, String achievementId,
      [Config? config]) async {
    throw UnimplementedError('getAvailableBadges() has not been implemented.');
  }

  Future<List<PlayerAchievement>> notifyPlayerAction(
      String playerToken, String playerUid, String action, String value,
      [Config? config]) async {
    throw UnimplementedError('getAvailableBadges() has not been implemented.');
  }
}
