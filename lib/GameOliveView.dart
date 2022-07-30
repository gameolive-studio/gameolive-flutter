import 'package:flutter/material.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/launchConfig.dart';

import 'gameolive.dart';

class GameOliveView extends StatelessWidget {
  final LaunchConfig? launchConfig;
  final Gameolive instance;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onGoToHome;

  const GameOliveView(
      {this.launchConfig,
      required this.instance,
      this.onRoundStarted,
      this.onGoToHome});
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
                onGoToHome: onGoToHome)));
  }
}
