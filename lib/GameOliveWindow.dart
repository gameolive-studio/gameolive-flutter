import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gameolive/models/player_achievement.dart';
import 'package:gameolive/shared/StandardEvents.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'gameolive.dart';
import 'models/launchConfig.dart';
import 'package:flutter/services.dart';

import 'models/playerBalance.dart';

typedef GameOliveGameControllerCallback = void Function(
    GameOliveGameController controller);

class GameOliveWindow extends StatefulWidget {
  final LaunchConfig? gameLaunchConfig;
  final Gameolive instance;
  final String? additionalQueryString;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onRoundEnded;
  final Function(bool)? onGoToHome;
  final Function(PlayerBalance)? onBalanceChange;
  final Function(List<PlayerAchievement>)? onUserAchievementsUpdate;
  final GameOliveGameControllerCallback? onGameOliveWindowCreated;

  const GameOliveWindow(
      {Key? key,
      required this.instance,
      required this.gameLaunchConfig,
      this.additionalQueryString,
      this.onRoundStarted,
      this.onRoundEnded,
      this.onGoToHome,
      this.onBalanceChange,
      this.onUserAchievementsUpdate,
      this.onGameOliveWindowCreated})
      : super(key: key);

  @override
  _GameOliveWindowState createState() => _GameOliveWindowState();
}

class _GameOliveWindowState extends State<GameOliveWindow> {
  String? gameUrl;
  WebViewController? _controller;

  final initialContent =
      '<h4> This is some hardcoded HTML code embedded inside the webview <h4> <h2> Hello world! <h2>';

  @override
  void initState() {
    super.initState();
    if (widget.gameLaunchConfig!.orientation == "landscape") {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    initGameLaunch();
  }

  @override
  dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);

    super.dispose();
  }

  void initGameLaunch() async {
    gameUrl = await widget.instance.getGameUrl(widget.gameLaunchConfig);
    setState(() {
      gameUrl = gameUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        // alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: gameUrl == null
                    ? null
                    : WebView(
                        initialUrl:
                            "$gameUrl&${widget.additionalQueryString ?? ''}",
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          // _controller.complete(webViewController);
                          _controller = webViewController;
                          _addPostScript(webViewController, context);

                          final GameOliveGameController controller =
                              GameOliveGameController(_controller!);

                          if (widget.onGameOliveWindowCreated != null) {
                            widget.onGameOliveWindowCreated!(controller);
                          }
                        },
                        javascriptChannels: <JavascriptChannel>{
                          _gameoliveChannel(context),
                          _inGOLAppChannel(context),
                        },
                      ))));
  }

  JavascriptChannel _inGOLAppChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'InGOLApp',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // sleep(Duration(seconds: 60));
          Map<String, dynamic> event = jsonDecode(message.message);
          if (event["event"] == StandardEvents.GAMEOLIVE_GAME_GOTO_HOME &&
              widget.onGoToHome != null) {
            widget.onGoToHome!(true);
          }
          if (event["event"] == StandardEvents.GAMEOLIVE_BALANCE_CHANGE &&
              widget.onBalanceChange != null) {
            widget.onBalanceChange!(PlayerBalance.fromJson(event));
          }
          if (event["event"] ==
                  StandardEvents.GAMEOLIVE_USER_ACHIEVEMENTS_UPDATE &&
              widget.onUserAchievementsUpdate != null) {
            List<PlayerAchievement> achievements = [];
            var list = event["achievements"];
            achievements = list == null
                ? achievements
                : list
                    .map<PlayerAchievement>(
                        (i) => PlayerAchievement.fromJson(i))
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
}

class GameOliveGameController {
  final WebViewController _controller;
  GameOliveGameController(this._controller);

  Future<void> openGameMenu() async {
    await _controller.runJavascript('window.golApi.openGameMenu();');
  }

  Future<void> closeGameMenu() async {
    await _controller.runJavascript('window.golApi.closeGameMenu();');
  }

  Future<void> pauseGame() async {
    await _controller.runJavascript('window.golApi.pauseGame();');
  }

  Future<void> resumePausedGame() async {
    await _controller.runJavascript('window.golApi.resumePausedGame();');
  }

  Future<void> reloadBalance() async {
    await _controller.runJavascript('window.golApi.reloadBalance();');
  }

  Future<void> reloadGame() async {
    await _controller.runJavascript('window.golApi.reloadGame();');
  }
}
