import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../controllers/base/gameolive_game_controller.dart';
import '../models/playerBalance.dart';
import '../models/player_achievement.dart';
import '../shared/StandardEvents.dart';

class IFrameWidget extends StatefulWidget {
  final String initialUrl;
  final Function(bool)? onRoundStarted;
  final Function(bool)? onRoundEnded;
  final Function(bool)? onGoToHome;
  final Function(PlayerBalance)? onBalanceChange;
  final Function(List<PlayerAchievement>)? onUserAchievementsUpdate;
  final GameOliveGameControllerCallback? onGameOliveWindowCreated;

  const IFrameWidget(
      {Key? key,
      required this.initialUrl,
      this.onRoundStarted,
      this.onRoundEnded,
      this.onGoToHome,
      this.onBalanceChange,
      this.onUserAchievementsUpdate,
      this.onGameOliveWindowCreated})
      : super(key: key);

  @override
  State<IFrameWidget> createState() => _IFrameWidgetState();
}

class _IFrameWidgetState extends State<IFrameWidget> {
  final html.IFrameElement _iframeElement = html.IFrameElement();

  @override
  void initState() {
    _iframeElement.height = '500';
    _iframeElement.width = '500';
    _iframeElement.src = widget.initialUrl;
    //  'https://mdxjs.com/docs/getting-started';
    _iframeElement.style.border = 'none';
    _iframeElement.id = 'gameolive-game-frame';
    // _iframeElement.contentWindow!
    //     .addEventListener("message", (event) => {debugPrint("xxxx")});
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    Future.delayed(const Duration(seconds: 10), () {
      var iframeElement = html.document.getElementById('gameolive-game-frame')
          as html.IFrameElement;
      html.window.addEventListener("message", (html.Event event) {
        var data = (event as html.MessageEvent).data;
        Map<String, dynamic> eventData = jsonDecode(data);
        respondToContainer(eventData);
      });
      final GameOliveGameController controller =
          IframeGameOliveGameController(iframeElement.contentWindow!);

      if (widget.onGameOliveWindowCreated != null) {
        widget.onGameOliveWindowCreated!(controller);
      }
      // .postMessage({"event": "SHOW_MENU"}, '*');
      // debugPrint("dfgrhrgfdewegrhtrgefw2");
      // html.document.getElementById('hello-world-html').contentWindow.postMessage("");
    });

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElement',
  );

  @override
  Widget build(BuildContext context) {
    return _iframeWidget;
  }

  void respondToContainer(Map<String, dynamic> event) {
    // todo: refactor and use the same as in GameOliveWindow
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

class IframeGameOliveGameController extends GameOliveGameController {
  final html.WindowBase contentWindow;
  IframeGameOliveGameController(this.contentWindow) : super();

  @override
  Future<void> openGameMenu() async {
    contentWindow.postMessage({"event": "SHOW_MENU"}, '*');
  }

  @override
  Future<void> closeGameMenu() async {
    contentWindow.postMessage({"event": "HIDE_MENU"}, '*');
  }

  @override
  Future<void> pauseGame() async {
    contentWindow.postMessage({"event": "PAUSE_GAME"}, '*');
  }

  @override
  Future<void> resumePausedGame() async {
    contentWindow.postMessage({"event": "RESUME_PAUSED_GAME"}, '*');
  }

  @override
  Future<void> reloadBalance() async {
    contentWindow.postMessage({"event": "RELOAD_BALANCE"}, '*');
  }

  @override
  Future<void> reloadGame() async {
    contentWindow.postMessage({"event": "RELOAD_GAME"}, '*');
  }
}
