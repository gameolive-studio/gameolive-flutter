import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/launchConfig.dart';

class GameOliveView extends StatelessWidget {
  final LaunchConfig? launchConfig;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onGoToHome;

  GameOliveView({this.launchConfig, this.onRoundStarted, this.onGoToHome});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GameOliveWindow(
                gameLaunchConfig: launchConfig,
                onRoundStarted: onRoundStarted,
                onGoToHome: onGoToHome)));
  }
}
