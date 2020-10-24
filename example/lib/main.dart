import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gameolive/gameolive.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/config.dart';
import 'package:gameolive/models/game.dart';
import 'package:gameolive/models/gamesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:gameolive/GameOliveView.dart';
import 'package:gameolive/GameOliveDialogBox.dart';

import 'custom_dialog_box.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'game_dialog_box.dart';


const clientId= "fb_game_sa-4862d2b3-fb68-4963-b47b-beec6af422a5@05cc351f-dbd0-43af-aaaf-515ffaecdd34.gol";
const clientSecret= "abc1602937927739";
const operatorId= "5f8ae3cbc34272000af1f3bf";
const server= 'https://elantra-api.gameolive.com';
const static= 'https://static.luckybeetlegames.com';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Game> _games;
  LaunchConfig inlineLaunchConfig;
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
        server: server,
        static: static
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
          title: const Text('Example app'),
        ),
        body: _games == null? const Text('Execution is in progress'):
        _games.length==0? const Text('There are no games in the offerings for this platform'):
        Column(
         children: [
           inlineLaunchConfig==null?SizedBox():SizedBox(
                width: 720,
                height: 220,
                child:GameOliveWindow(
                  gameLaunchConfig: inlineLaunchConfig,
                )
            ),

           SizedBox(),
           Flexible(
            child: ListView.builder(
             // Let the ListView know how many items it needs to build.
               itemCount: _games.length,
               // Provide a builder function. This is where the magic happens.
               // Convert each item into a widget based on the type of item it is.
               itemBuilder: (context, index) {
                 final item = _games[index];
                 return Slidable(
                   actionPane: SlidableDrawerActionPane(),
                   actionExtentRatio: 0.25,
                   child: Container(
                     color: Colors.white,
                     child: ListTile(
                       leading: Text(('<')),
                       title: Text(item.title),
                       trailing: Text(('Swipe >')),
                       subtitle: Text((item.configuration.id)),
                     ),
                   ),
                   actions: <Widget>[
                     IconSlideAction(
                       caption: 'Game Link',
                       color: Colors.blue,
                       icon: Icons.archive,
                       onTap: () async {
                         LaunchConfig _launchConfig =  new LaunchConfig();
                         _launchConfig.server = server;
                         _launchConfig.static = static;
                         _launchConfig.operatorId = operatorId;
                         _launchConfig.configId = item.configuration.id;
                         _launchConfig.playerId = "ABCD"; // unique if of the player
                         String gameLink = await Gameolive.getGameUrl(_launchConfig);
                         showDialog(context: context,
                             builder: (BuildContext context){
                               return CustomDialogBox(
                                 title: "Link to the game",
                                 descriptions: gameLink,
                                 text: "Close",
                               );
                             });
                       },
                     ),
                     IconSlideAction(
                       caption: 'Register Player',
                       color: Colors.indigo,
                       icon: Icons.person_add,
                       onTap: () {print('share');},
                     ),
                   ],
                   secondaryActions: <Widget>[
                     IconSlideAction(
                       caption: 'inline',
                       color: Colors.blue,
                       icon: Icons.more_horiz,
                       onTap: () async {
                         LaunchConfig _launchConfig =  new LaunchConfig();
                         _launchConfig.server = server;
                         _launchConfig.static = static;
                         _launchConfig.operatorId = operatorId;
                         _launchConfig.configId = item.configuration.id;
                         _launchConfig.playerId = "ABCD"; // unique if of the player
                         setState(() {
                           inlineLaunchConfig = _launchConfig;
                         });
                       },
                     ),
                     IconSlideAction(
                       caption: 'redirect',
                       color: Colors.black45,
                       icon: Icons.arrow_forward,
                       onTap: ()  {
                         LaunchConfig launchConfig =  new LaunchConfig();
                         launchConfig.server = server;
                         launchConfig.static = static;
                         launchConfig.operatorId = operatorId;
                         launchConfig.configId = item.configuration.id;
                         launchConfig.playerId = "ABCD"; // unique if of the player
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => GameOliveView(
                                 launchConfig: launchConfig,
                               )),
                         );
                         },
                     ),
                     IconSlideAction(
                       caption: 'Dialog',
                       color: Colors.indigo,
                       icon: Icons.add_to_photos ,
                       onTap: () {
                         LaunchConfig gameLaunchConfig =  new LaunchConfig();
                         gameLaunchConfig.server = server;
                         gameLaunchConfig.static = static;
                         gameLaunchConfig.operatorId = operatorId;
                         gameLaunchConfig.configId = item.configuration.id;
                         gameLaunchConfig.playerId = "ABCD"; // unique if of the player

                         showDialog(context: context,
                             builder: (BuildContext context){
//                             return GameOliveDialogBox(gameLaunchConfig: gameLaunchConfig);
                               return GameDialogBox(gameLaunchConfig: gameLaunchConfig);
                             }
                         );
                       },
                     ),
                   ],
                 );
               }
           )),
         ],
        )
      ),
    );
  }
}
