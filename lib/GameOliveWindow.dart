
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameolive/shared/StandardEvents.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'gameolive.dart';
import 'models/launchConfig.dart';

class GameOliveWindow extends StatefulWidget {
  final LaunchConfig gameLaunchConfig;
  final Function(bool) onRoundStarted;

  const GameOliveWindow({Key key, @required this.gameLaunchConfig, this.onRoundStarted}) : super(key: key);

  @override
  _GameOliveWindowState createState() => _GameOliveWindowState();
}

class _GameOliveWindowState extends State<GameOliveWindow> {
  String gameUrl;
  final Completer<WebViewController> _controller = Completer<
      WebViewController>();

  @override
  void initState() {
    super.initState();
    initGamwLaunch();
  }

  void initGamwLaunch() async {
    gameUrl = await Gameolive.getGameUrl(widget.gameLaunchConfig);
    setState(() {
      gameUrl = gameUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        // alignment: Alignment.center,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: new Container(
                child: gameUrl == null ? null : WebView(
                  initialUrl: gameUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    _addPostScript(webViewController, context);
                  },
                  javascriptChannels: <JavascriptChannel>[
                    _gameoliveChannel(context),
                  ].toSet(),
                ),
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                )
            ))
    );
  }

  JavascriptChannel _gameoliveChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'GAMEOLIVE',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // sleep(Duration(seconds: 60));
          Map<String, dynamic> event =  jsonDecode(message.message);
          if(event["event"] == StandardEvents.GAMEOLIVE_GAME_ROUND_STARTED && widget.onRoundStarted !=null){
            widget.onRoundStarted(true);
          }
        });
  }

  void _addPostScript(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('window.onmessage = function(event) {GAMEOLIVE.postMessage(JSON.stringify(event.data));};');
  }
}