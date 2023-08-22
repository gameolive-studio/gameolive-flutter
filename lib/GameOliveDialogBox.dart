import 'package:flutter/material.dart';
import './GameOliveWindow.dart';
import './models/launchConfig.dart';
import 'gameolive.dart';

class GameOliveDialogBox extends StatefulWidget {
  final LaunchConfig? gameLaunchConfig;
  final Gameolive instance;
  const GameOliveDialogBox(
      {Key? key, required this.instance, this.gameLaunchConfig})
      : super(key: key);

  @override
  _GameOliveDialogBoxState createState() => _GameOliveDialogBoxState();
}

class _GameOliveDialogBoxState extends State<GameOliveDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        GameOliveWindow(
          instance: widget.instance,
          gameLaunchConfig: widget.gameLaunchConfig,
        ),
      ],
    );
  }
}
