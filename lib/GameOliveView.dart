import 'package:flutter/material.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/launchConfig.dart';

import 'gameolive.dart';
import 'models/player_achievement.dart';
import 'models/playerBalance.dart';

class GameOliveView extends StatelessWidget {
  final LaunchConfig? launchConfig;
  final Gameolive instance;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onRoundEnded;
  final Function(bool)? onGoToHome;
  final Function(PlayerBalance)? onBalanceChange;
  final Function(List<PlayerAchievement>)? onUserAchievementsUpdate;

  const GameOliveView({
    this.launchConfig,
    required this.instance,
    this.onRoundStarted,
    this.onRoundEnded,
    this.onGoToHome,
    this.onBalanceChange,
    this.onUserAchievementsUpdate,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GameOliveWindow(
                instance: instance,
                gameLaunchConfig: launchConfig,
                onRoundStarted: onRoundStarted,
                onGoToHome: onGoToHome,
                onRoundEnded: onRoundEnded,
                onBalanceChange: onBalanceChange,
                onUserAchievementsUpdate: onUserAchievementsUpdate)));
  }
}
