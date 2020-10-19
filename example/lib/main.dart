import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gameolive/gameolive.dart';
import 'package:gameolive/models/config.dart';
import 'package:gameolive/models/game.dart';
import 'package:gameolive/models/gamesResponse.dart';

const clientId= "fb_game_sa-4862d2b3-fb68-4963-b47b-beec6af422a5@05cc351f-dbd0-43af-aaaf-515ffaecdd34.gol";
const clientSecret= "abc1602937927739";
const operatorId= "5f8ae3cbc34272000af1f3bf";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Game> _games;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Config config = new Config(
        operatorId: operatorId,
        clientId: clientId,
        clientSecret: clientSecret,
        server: 'https://elantra-api.gameolive.com',
        static: 'https://static.luckybeetlegames.com'
    );
    List<Game> games;
    try {

      await Gameolive.init(config); // initialize the library

      GamesResponse gamesResponse =  await Gameolive.getGames(10,0); // get first 10 games
      games = gamesResponse.games;
    } on PlatformException {
      // Log exception and report studio@gameolive.com
    }


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

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
        body: _games == null? const Text('Execution is in progress'):
        _games.length==0? const Text('There are no games in the offerings for this platform'):
        ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: _games.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = _games[index];
            return GestureDetector(
                child:
                ListTile(
              title: Text(item.title),
              subtitle: Text(item.configuration.id),
            ),
              onTap: () => Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(item.title.toString()))),
            );
          },
        ),
      ),
    );
  }
}
