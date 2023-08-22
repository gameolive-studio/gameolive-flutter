// https://github.com/flutter/flutter/issues/53005

import 'dart:async';
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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }

    // final WebViewController controller =
    //     WebViewController.fromPlatformCreationParams(params);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('InGOLApp',
          onMessageReceived: (JavaScriptMessage message) {
        // ignore: deprecated_member_use
        // sleep(Duration(seconds: 60));
        Map<String, dynamic> event = jsonDecode(message.message);
        respondToContainer(event);
      })
      ..addJavaScriptChannel('GAMEOLIVE',
          onMessageReceived: (JavaScriptMessage message) {
        // ignore: deprecated_member_use
        // sleep(Duration(seconds: 60));
        Map<String, dynamic> event = jsonDecode(message.message);
        if (event["event"] == StandardEvents.GAMEOLIVE_GAME_ROUND_STARTED &&
            widget.onRoundStarted != null) {
          widget.onRoundStarted!(true);
        }
      })
      ..loadRequest(Uri.parse(widget.initialUrl));
    // _controller = controller;
    final GameOliveGameController gameOliveController =
        WebViewGameOliveGameController(_controller);

    if (widget.onGameOliveWindowCreated != null) {
      widget.onGameOliveWindowCreated!(gameOliveController);
    }
    _addPostScript(_controller, context);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }

  void _addPostScript(
      WebViewController controller, BuildContext context) async {
    await _controller.runJavaScript(
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
    await _controller.runJavaScript('window.golApi.openGameMenu();');
  }

  @override
  Future<void> closeGameMenu() async {
    await _controller.runJavaScript('window.golApi.closeGameMenu();');
  }

  @override
  Future<void> pauseGame() async {
    await _controller.runJavaScript('window.golApi.pauseGame();');
  }

  @override
  Future<void> resumePausedGame() async {
    await _controller.runJavaScript('window.golApi.resumePausedGame();');
  }

  @override
  Future<void> reloadBalance() async {
    await _controller.runJavaScript('window.golApi.reloadBalance();');
  }

  @override
  Future<void> reloadGame() async {
    await _controller.runJavaScript('window.golApi.reloadGame();');
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
