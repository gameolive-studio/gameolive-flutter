import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './GameOliveWindow.dart';
import './models/launchConfig.dart';

class GameOliveDialogBox extends StatefulWidget {
  final LaunchConfig gameLaunchConfig;

  const GameOliveDialogBox({Key key, this.gameLaunchConfig}) : super(key: key);

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
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          child:  GameOliveWindow(
            gameLaunchConfig: widget.gameLaunchConfig,
          )
        ),
      ],
    );
  }
}