// https://github.com/flutter/flutter/issues/53005

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/base/gameolive_game_controller.dart';
import '../models/playerBalance.dart';
import '../models/player_achievement.dart';
import '../shared/StandardEvents.dart';
import 'gameolive_webview_widget.dart';

class WebviewWidget extends GameOliveWebViewWidget {
  const WebviewWidget(
      {super.key,
      required super.initialUrl,
      super.onRoundStarted,
      super.onRoundEnded,
      super.onGoToHome,
      super.onBalanceChange,
      super.onUserAchievementsUpdate,
      super.onGameOliveWindowCreated});

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        // _controller.complete(webViewController);
        _controller = webViewController;
        _addPostScript(webViewController, context);

        final GameOliveGameController controller =
            WebViewGameOliveGameController(_controller!);

        if (widget.onGameOliveWindowCreated != null) {
          widget.onGameOliveWindowCreated!(controller);
        }
      },
      javascriptChannels: <JavascriptChannel>{
        _gameoliveChannel(context),
        _inGOLAppChannel(context),
      },
    );
  }

  JavascriptChannel _inGOLAppChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'InGOLApp',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // sleep(Duration(seconds: 60));
          Map<String, dynamic> event = jsonDecode(message.message);
          respondToContainer(event);
        });
  }

  JavascriptChannel _gameoliveChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'GAMEOLIVE',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // sleep(Duration(seconds: 60));
          Map<String, dynamic> event = jsonDecode(message.message);
          if (event["event"] == StandardEvents.GAMEOLIVE_GAME_ROUND_STARTED &&
              widget.onRoundStarted != null) {
            widget.onRoundStarted!(true);
          }
        });
  }

  void _addPostScript(
      WebViewController controller, BuildContext context) async {
    await _controller!.runJavascript(
        'window.onmessage = function(event) {GAMEOLIVE.postMessage(JSON.stringify(event.data));}; document.body.style.setProperty("background","transparent")');
  }

  void respondToContainer(Map<String, dynamic> event) {
    // todo: refactor and reuse in iframe_widget
    if (event["event"] == StandardEvents.GAMEOLIVE_GAME_GOTO_HOME &&
        widget.onGoToHome != null) {
      widget.onGoToHome!(true);
    }
    if (event["event"] == StandardEvents.GAMEOLIVE_BALANCE_CHANGE &&
        widget.onBalanceChange != null) {
      widget.onBalanceChange!(PlayerBalance.fromJson(event));
    }
    if (event["event"] == StandardEvents.GAMEOLIVE_USER_ACHIEVEMENTS_UPDATE &&
        widget.onUserAchievementsUpdate != null) {
      List<PlayerAchievement> achievements = [];
      var list = event["achievements"];
      achievements = list == null
          ? achievements
          : list
              .map<PlayerAchievement>((i) => PlayerAchievement.fromJson(i))
              .toList();

      widget.onUserAchievementsUpdate!(achievements);
    }
    if (event["event"] == StandardEvents.GAMEOLIVE_GAME_ROUND_STARTED &&
        widget.onRoundStarted != null) {
      widget.onRoundStarted!(true);
    }
    if (event["event"] == StandardEvents.GAMEOLIVE_GAME_ROUND_ENDED &&
        widget.onRoundEnded != null) {
      widget.onRoundEnded!(true);
    }
  }
}

class WebViewGameOliveGameController extends GameOliveGameController {
  final WebViewController _controller;
  WebViewGameOliveGameController(this._controller) : super();

  @override
  Future<void> openGameMenu() async {
    await _controller.runJavascript('window.golApi.openGameMenu();');
  }

  @override
  Future<void> closeGameMenu() async {
    await _controller.runJavascript('window.golApi.closeGameMenu();');
  }

  @override
  Future<void> pauseGame() async {
    await _controller.runJavascript('window.golApi.pauseGame();');
  }

  @override
  Future<void> resumePausedGame() async {
    await _controller.runJavascript('window.golApi.resumePausedGame();');
  }

  @override
  Future<void> reloadBalance() async {
    await _controller.runJavascript('window.golApi.reloadBalance();');
  }

  @override
  Future<void> reloadGame() async {
    await _controller.runJavascript('window.golApi.reloadGame();');
  }
}

GameOliveWebViewWidget getGameOliveWebViewWidget(
        initialUrl,
        onRoundStartedl,
        onRoundEnded,
        onGoToHome,
        onBalanceChange,
        onUserAchievementsUpdate,
        onGameOliveWindowCreated) =>
    WebviewWidget(
        initialUrl: initialUrl,
        onRoundStarted: onRoundStartedl,
        onRoundEnded: onRoundEnded,
        onGoToHome: onGoToHome,
        onBalanceChange: onBalanceChange,
        onUserAchievementsUpdate: onUserAchievementsUpdate,
        onGameOliveWindowCreated: onGameOliveWindowCreated);
