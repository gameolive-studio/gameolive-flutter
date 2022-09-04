import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gameolive/GameOliveView.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/controllers/base/gameolive_game_controller.dart';
import 'package:gameolive/gameolive.dart';
import 'package:gameolive/models/config.dart';
import 'package:gameolive/models/game.dart';
import 'package:gameolive/models/gamesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:gameolive/models/leader.dart';
import 'package:gameolive/models/playerBalance.dart';
import 'package:gameolive/models/player_achievement.dart';
import 'package:gameolive/models/transaction.dart';
import 'package:gameolive/shared/playmode.dart';
import 'package:get/get.dart';

import 'custom_dialog_box.dart';
import 'game_dialog_box.dart';

const clientId =
    "fb_game_sa-4862d2b3-fb68-4963-b47b-beec6af422a5@05cc351f-dbd0-43af-aaaf-515ffaecdd34.gol";
const clientSecret = "abc1602937927739";
const operatorId = "5f8ae3cbc34272000af1f3bf";
const server = 'https://elantra-api.gameolive.com';
const static = 'https://static.luckybeetlegames.com';
const walletClientId =
    "wallet_manager-6f18a5bb-9b2e-4ed8-b7db-abf6465256f8@4e539d5f-4dd9-4518-8e67-49e401ea0b4b.gol";
const walletClientSecret = "gol1606078109162";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _platformVersion = 'Unknown';
  final _gameolivePlugin = Gameolive();

  List<Game>? _games;
  LaunchConfig? inlineLaunchConfig;
  PlayerBalance? _playerBalance;
  String defaultPlayerId = "DEMO_USER";
  String _playerId = "DEMO_USER";
  String _playerToken = "";

  final TextEditingController _txtPlayerUid = TextEditingController();
  TextEditingController? _txtTransactionId;
  TextEditingController? _txtAmount;
  TextEditingController? _txtCurrency;
  TextEditingController? _txtCoins;
  TextEditingController? _txtRefernce;
  TextEditingController? _txtRemarks;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initGameOlive();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _gameolivePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  initGameOlive() async {
    Config config = Config(
        operatorId: operatorId,
        clientId: clientId,
        clientSecret: clientSecret,
        server: server,
        static: static);
    List<Game>? games;
    try {
      await _gameolivePlugin.init(config); // initialize the library

      GamesResponse gamesResponse =
          await _gameolivePlugin.getGames(10, 0); // get first 10 games
      games = gamesResponse.games;
      try {
        List<Leader> leaders = await _gameolivePlugin.getLeaderBoard(
            _playerToken, _playerId, "TEST_CHALLENGE_ID", 5);
        debugPrint('Leaders: ${leaders.length}');
      } catch (ex) {
        debugPrint('Leaders: Error');
      }
    } on PlatformException {
      // Log exception and report studio@gameolive.com
    }

    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: _games == null
              ? const Text('Execution is in progress')
              : _games!.isEmpty
                  ? const Text(
                      'There are no games in the offerings for this platform')
                  : Column(
                      children: [
                        inlineLaunchConfig == null
                            ? const SizedBox()
                            : SizedBox(
                                width: 720,
                                height: 220,
                                child: GameOliveWindow(
                                  instance: _gameolivePlugin,
                                  gameLaunchConfig: inlineLaunchConfig,
                                  onRoundStarted: (started) => {
                                    Get.snackbar(
                                      " started $started",
                                      " started $started",
                                      icon: const Icon(Icons.person,
                                          color: Colors.white),
                                      snackPosition: SnackPosition.BOTTOM,
                                    )
                                  },
                                )),
                        const SizedBox(),
                        Flexible(
                            child: ListView.builder(
                                // Let the ListView know how many items it needs to build.
                                itemCount: _games!.length,
                                // Provide a builder function. This is where the magic happens.
                                // Convert each item into a widget based on the type of item it is.
                                itemBuilder: (context, index) {
                                  final item = _games![index];
                                  return Slidable(
                                    actionPane:
                                        const SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    actions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Game Link',
                                        color: Colors.blue,
                                        icon: Icons.archive,
                                        onTap: () async {
                                          LaunchConfig launchConfig =
                                              LaunchConfig();
                                          launchConfig.server = server;
                                          launchConfig.static = static;
                                          launchConfig.operatorId = operatorId;
                                          launchConfig.configId =
                                              item.configuration;
                                          launchConfig.playerId = _playerId;
                                          launchConfig.playerToken =
                                              _playerToken;

                                          String gameLink =
                                              await _gameolivePlugin
                                                  .getGameUrl(launchConfig);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialogBox(
                                                  title: "Link to the game",
                                                  descriptions: gameLink,
                                                  text: "Close",
                                                );
                                              });
                                        },
                                      ),
                                      IconSlideAction(
                                        caption:
                                            '${_playerId == defaultPlayerId ? 'Register Player' : _playerId}: ${_playerBalance != null ? '${_playerBalance!.cash}|${_playerBalance!.currency}|${_playerBalance!.coin}' : ''}',
                                        color: Colors.indigo,
                                        icon: Icons.person_add,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)), //this right here
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Player UID'),
                                                            controller:
                                                                _txtPlayerUid,
                                                          ),
                                                          SizedBox(
                                                            width: 320.0,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  String playerToken = await _gameolivePlugin.getPlayerToken(
                                                                      _txtPlayerUid
                                                                          .text,
                                                                      PlayMode
                                                                          .real);

                                                                  Config walletConfig = Config(
                                                                      operatorId:
                                                                          operatorId,
                                                                      clientId:
                                                                          walletClientId,
                                                                      clientSecret:
                                                                          walletClientSecret,
                                                                      server:
                                                                          server,
                                                                      static:
                                                                          static);
                                                                  PlayerBalance pb = await _gameolivePlugin.getPlayerBalance(
                                                                      playerToken,
                                                                      _txtPlayerUid
                                                                          .text,
                                                                      PlayMode
                                                                          .real,
                                                                      walletConfig);
                                                                  List<PlayerAchievement>
                                                                      achievements =
                                                                      await _gameolivePlugin.notifyPlayerAction(
                                                                          playerToken,
                                                                          _txtPlayerUid
                                                                              .text,
                                                                          "FIRST_TIME",
                                                                          "1");
                                                                  debugPrint(
                                                                      "eddwdweded");
                                                                  // List<PlayerAchievement>
                                                                  //     allAchievements =
                                                                  //     await _gameolivePlugin
                                                                  //         .getPlayerAchievements(
                                                                  //   playerToken,
                                                                  //   _txtPlayerUid
                                                                  //       .text,
                                                                  // );

                                                                  // dynamic status = await _gameolivePlugin.acknowledgePlayerAchievement(
                                                                  //     "123456", _playerId);

                                                                  setState(() {
                                                                    _playerId =
                                                                        _txtPlayerUid
                                                                            .text;
                                                                    _playerToken =
                                                                        playerToken;
                                                                    _playerBalance =
                                                                        pb;
                                                                  });

                                                                  // var transactions = await _gameolivePlugin.getPlayerAccountHistory(
                                                                  //     _playerId,
                                                                  //     PlayMode
                                                                  //         .real,
                                                                  //     0,
                                                                  //     10,
                                                                  //     walletConfig);
                                                                  // print(transactions
                                                                  //     .count);
                                                                } catch (ex) {
                                                                  Get.snackbar(
                                                                    'Exception while getting plater token!',
                                                                    'Exception while getting plater token!',
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .white),
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              // color: const Color(
                                                              //     0xFF1BC0C5),
                                                              child: const Text(
                                                                "Register Or Login Player",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                              'Current Player: $_playerId'),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Transaction UID'),
                                                            controller:
                                                                _txtTransactionId,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Amount'),
                                                            controller:
                                                                _txtAmount,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Currency'),
                                                            controller:
                                                                _txtCurrency,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Coins'),
                                                            controller:
                                                                _txtCoins,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Reference'),
                                                            controller:
                                                                _txtRefernce,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'Remarks'),
                                                            controller:
                                                                _txtRemarks,
                                                          ),
                                                          SizedBox(
                                                            width: 320.0,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  Transaction trx = Transaction(
                                                                      uid: _txtTransactionId!
                                                                          .text,
                                                                      amount: double.parse(
                                                                          _txtAmount!
                                                                              .text),
                                                                      currency:
                                                                          _txtCurrency!
                                                                              .text,
                                                                      coins: int.parse(
                                                                          _txtCoins!
                                                                              .text),
                                                                      reference:
                                                                          _txtRefernce!
                                                                              .text);
                                                                  trx.remarks =
                                                                      _txtRemarks!
                                                                          .text;
                                                                  // Create new configuration with service account with Wallet Manager permissions.
                                                                  // it is recommended to no give wallet manager permissions to Game Admin or other permissions as it might risk the exploitation of wallet
                                                                  // it is highly recommended to use wallet manager service account for server to server request and not to use in client application, but if you wish to use it on client side for simplicity you can do it at your own risk
                                                                  Config walletConfig = Config(
                                                                      operatorId:
                                                                          operatorId,
                                                                      clientId:
                                                                          walletClientId,
                                                                      clientSecret:
                                                                          walletClientSecret,
                                                                      server:
                                                                          server,
                                                                      static:
                                                                          static);
                                                                  var newTransaction =
                                                                      await _gameolivePlugin.depositToPlayerAccount(
                                                                          _playerId,
                                                                          trx,
                                                                          walletConfig);
                                                                  setState(() {
                                                                    _playerBalance =
                                                                        newTransaction;
                                                                  });
                                                                  // print( // todo make new Model for TransactionRef.
                                                                  //     _newTransaction
                                                                  //         .uid);
                                                                } catch (ex) {
                                                                  Get.snackbar(
                                                                    'Exception while making player transaction!',
                                                                    'Exception while making player transaction!',
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .white),
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                }
                                                              },
                                                              // color: const Color(
                                                              //     0xFF1BC0C5),
                                                              child: const Text(
                                                                "Deposit to Player wallet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });

                                          print('share');
                                        },
                                      ),
                                    ],
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'inline',
                                        color: Colors.blue,
                                        icon: Icons.more_horiz,
                                        onTap: () async {
                                          LaunchConfig launchConfig =
                                              LaunchConfig();
                                          launchConfig.server = server;
                                          launchConfig.static = static;
                                          launchConfig.operatorId = operatorId;
                                          launchConfig.configId =
                                              item.configuration;
                                          launchConfig.playerId = _playerId;
                                          launchConfig.playerToken =
                                              _playerToken;
                                          setState(() {
                                            inlineLaunchConfig = launchConfig;
                                          });
                                        },
                                      ),
                                      IconSlideAction(
                                        caption: 'redirect',
                                        color: Colors.black45,
                                        icon: Icons.arrow_forward,
                                        onTap: () {
                                          LaunchConfig launchConfig =
                                              LaunchConfig();
                                          launchConfig.server = server;
                                          launchConfig.static = static;
                                          launchConfig.operatorId = operatorId;
                                          launchConfig.configId =
                                              item.configuration;
                                          launchConfig.orientation =
                                              "landscape";
                                          launchConfig.playerId = _playerId;
                                          launchConfig.playerToken =
                                              _playerToken;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GameOliveView(
                                                        instance:
                                                            _gameolivePlugin,
                                                        launchConfig:
                                                            launchConfig,
                                                        onGoToHome: (value) {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        onBalanceChange:
                                                            (balace) {
                                                          debugPrint(
                                                              "balance update");
                                                        },
                                                        onUserAchievementsUpdate:
                                                            (achievements) {
                                                          debugPrint(
                                                              "achievements update");
                                                        },
                                                        onGameOliveWindowCreated:
                                                            (GameOliveGameController
                                                                gamecontroller) {
                                                          gamecontroller
                                                              .openGameMenu();
                                                        }),
                                              ));
                                        },
                                      ),
                                      IconSlideAction(
                                        caption: 'Dialog',
                                        color: Colors.indigo,
                                        icon: Icons.add_to_photos,
                                        onTap: () {
                                          LaunchConfig gameLaunchConfig =
                                              LaunchConfig();
                                          gameLaunchConfig.server = server;
                                          gameLaunchConfig.static = static;
                                          gameLaunchConfig.operatorId =
                                              operatorId;
                                          gameLaunchConfig.configId =
                                              item.configuration;
                                          gameLaunchConfig.playerId =
                                              _playerId; // unique if of the player
                                          gameLaunchConfig.playerToken =
                                              _playerToken; // unique if of the player

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
//                             return GameOliveDialogBox(gameLaunchConfig: gameLaunchConfig);
                                                return GameDialogBox(
                                                    instance: _gameolivePlugin,
                                                    gameLaunchConfig:
                                                        gameLaunchConfig);
                                              });
                                        },
                                      ),
                                    ],
                                    child: Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: const Text(('<')),
                                        title: Text(item.title ?? ""),
                                        trailing: const Text(('Swipe >')),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.configuration ?? ""),
                                            Text('enabled: ${item.enabled}'),
                                            Text('label: ${item.label}'),
                                            Text('Rating: ${item.rating}'),
                                            Text(
                                                'playerCount: ${item.playerCount}'),
                                            Text(
                                                'description: ${item.description}')
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                      ],
                    )),
    );
  }
}
