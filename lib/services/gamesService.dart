import 'dart:convert';
import 'package:gameolive/models/gamesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:gameolive/shared/GameoliveCacheManager.dart';
import 'package:http/http.dart' as http;

import '../models/config.dart';

// GamesResponse? REF_GAMES = null;
Future<GamesResponse> fetchGames(int limit, int offset, Config config) async {
  String path = config.server +
      '/api/tenant/${config.operatorId}/game?filter[application]=${config.application}&orderBy=${config.orderBy}&limit=${limit > 0 ? limit : config.limit}&offset=${offset > 0 ? offset : config.offset}';

  try {
    var file = await GameoliveCacheManager.instance
        .getSingleFile(path, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${config.token}',
    });
    if (file != null && await file.exists()) {
      var res = await file.readAsString();

      GamesResponse games = GamesResponse.fromJson(json.decode(res));
      // REF_GAMES = games;
      return games;
    }
  } catch (ex) {
    print(
        "Seems like, there is some trouble with app caching, so fetching from server (a bit unoptimized)");
  }

  final response = await http.get(Uri.parse(path), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${config.token}',
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var gameResponse = json.decode(rb) as Map<String, dynamic>;

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    GamesResponse games = GamesResponse.fromJson(
        gameResponse); // list.map((i)=>Game.fromJson(i)).toList();

    // print(games.runtimeType); //returns List<Img>
    // print(games[0].runtimeType); //returns Img
    // REF_GAMES = games;
    return games;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load games');
  }
}

Future<String> fetchGameUrl(
    LaunchConfig? gameLaunchConfig, Config config) async {
  String? configId = gameLaunchConfig!.configId;
  String? playerId = gameLaunchConfig.playerId;
  String? playerToken = gameLaunchConfig.playerToken;
  String DEFAULT_INDEX_PATH = "dist";
  final response = await http.get(
      Uri.parse(config.server +
          '/api/launch-config/${config.operatorId}/${configId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // {\"configuration\":{\"clientId\":\"horsebet\",\"name\":\"Horse Racing\"},\"gameId\":\"race-server-base\",\"success\":true}
    var rb = response.body;
    var gameLauncherResponse = json.decode(rb) as Map<String, dynamic>;
    String clientId = gameLauncherResponse['configuration']['clientId'];
    String gameId = gameLauncherResponse['gameId'];
    String urlData =
        'gameid=${gameId}&configid=${configId}&server=${config.server}&operatorid=${config.operatorId}&playerid=${playerId}&playertoken=${playerToken}';
    if (gameLaunchConfig.rawUrl != true) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(urlData);
      urlData = 'token=$encoded';
    }
    String? gameLink = null;
    if (gameLauncherResponse['configuration']["gameLink"] != null) {
      gameLink = gameLauncherResponse['configuration']["gameLink"];
    } else if (gameLauncherResponse["gameLink"] != null) {
      gameLink = gameLauncherResponse["gameLink"];
    }

    if (gameLink == null || gameLink.length == 0) {
      gameLink =
          '${config.static}/${clientId}/${DEFAULT_INDEX_PATH}/index.html';
    }
    return '${gameLink}?${urlData}';
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch game launch configuration');
  }
}
