
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'gameolive.dart';
import 'models/launchConfig.dart';

class GameOliveWindow extends StatefulWidget {
  final LaunchConfig gameLaunchConfig;

  const GameOliveWindow({Key key, this.gameLaunchConfig}) : super(key: key);

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
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}