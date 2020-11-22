import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/launchConfig.dart';

class GameOliveView extends StatelessWidget {
  final LaunchConfig launchConfig;
  GameOliveView({this.launchConfig});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          child: GameOliveWindow(
                  gameLaunchConfig: launchConfig,
                )
    ));
  }
}