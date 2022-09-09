// https://medium.com/codex/adding-platform-specific-dart-code-to-your-flutter-app-an-easy-way-9ffe32a454ad
import 'package:flutter/material.dart';

import '../controllers/base/gameolive_game_controller.dart';
import '../models/playerBalance.dart';
import '../models/player_achievement.dart';
import 'gameolive_webview_widget_stub.dart'
    if (dart.library.io) 'webview_widget.dart'
    if (dart.library.html) 'iframe_widget.dart';

abstract class GameOliveWebViewWidget extends StatefulWidget {
  final String initialUrl;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onRoundEnded;
  final Function(bool)? onGoToHome;
  final Function(PlayerBalance)? onBalanceChange;
  final Function(List<PlayerAchievement>)? onUserAchievementsUpdate;
  final GameOliveGameControllerCallback? onGameOliveWindowCreated;

  const GameOliveWebViewWidget(
      {Key? key,
      required this.initialUrl,
      this.onRoundStarted,
      this.onRoundEnded,
      this.onGoToHome,
      this.onBalanceChange,
      this.onUserAchievementsUpdate,
      this.onGameOliveWindowCreated})
      : super(key: key);

  // static GameOliveWebViewWidget getGameOliveWebViewWidgetFactory() => getFileDownloader();
  static GameOliveWebViewWidget getGameOliveWebViewWidgetFactory(
          initialUrl,
          onRoundStartedl,
          onRoundEnded,
          onGoToHome,
          onBalanceChange,
          onUserAchievementsUpdate,
          onGameOliveWindowCreated) =>
      getGameOliveWebViewWidget(
          initialUrl,
          onRoundStartedl,
          onRoundEnded,
          onGoToHome,
          onBalanceChange,
          onUserAchievementsUpdate,
          onGameOliveWindowCreated);
}
