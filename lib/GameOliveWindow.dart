import 'package:flutter/material.dart';

import 'package:gameolive/models/player_achievement.dart';
import 'components/gameolive_webview_widget.dart';
import 'controllers/base/gameolive_game_controller.dart';
import 'gameolive.dart';
import 'models/launchConfig.dart';
import 'package:flutter/services.dart';

import 'models/playerBalance.dart';

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
                : GameOliveWebViewWidget.getGameOliveWebViewWidgetFactory(
                    "$gameUrl&${widget.additionalQueryString ?? ''}",
                    widget.onRoundStarted,
                    widget.onRoundEnded,
                    widget.onGoToHome,
                    widget.onBalanceChange,
                    widget.onUserAchievementsUpdate,
                    widget.onGameOliveWindowCreated)
            // IFrameWidget(
            //     initialUrl:
            //         "$gameUrl&${widget.additionalQueryString ?? ''}",
            //     onRoundStarted: widget.onRoundStarted,
            //     onRoundEnded: widget.onRoundEnded,
            //     onGoToHome: widget.onGoToHome,
            //     onBalanceChange: widget.onBalanceChange,
            //     onUserAchievementsUpdate: widget.onUserAchievementsUpdate,
            //     onGameOliveWindowCreated: widget.onGameOliveWindowCreated)
            // : WebviewWidget(
            //     initialUrl:
            //         "$gameUrl&${widget.additionalQueryString ?? ''}",
            //     onRoundStarted: widget.onRoundStarted,
            //     onRoundEnded: widget.onRoundEnded,
            //     onGoToHome: widget.onGoToHome,
            //     onBalanceChange: widget.onBalanceChange,
            //     onUserAchievementsUpdate: widget.onUserAchievementsUpdate,
            //     onGameOliveWindowCreated:
            //         widget.onGameOliveWindowCreated),
            // WebView(
            //     initialUrl:
            //         "$gameUrl&${widget.additionalQueryString ?? ''}",
            //     javascriptMode: JavascriptMode.unrestricted,
            //     onWebViewCreated:
            //         (WebViewController webViewController) {
            //       // _controller.complete(webViewController);
            //       _controller = webViewController;
            //       _addPostScript(webViewController, context);

            //       final GameOliveGameController controller =
            //           WebViewGameOliveGameController(_controller!);

            //       if (widget.onGameOliveWindowCreated != null) {
            //         widget.onGameOliveWindowCreated!(controller);
            //       }
            //     },
            //     javascriptChannels: <JavascriptChannel>{
            //       _gameoliveChannel(context),
            //       _inGOLAppChannel(context),
            //     },
            //   )),
            ),
      ),
    );
  }
}
