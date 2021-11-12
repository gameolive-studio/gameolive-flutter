import 'dart:convert';
import 'package:gameolive/models/gamesResponse.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:http/http.dart';
import 'dart:io';

import '../models/config.dart';

Future<GamesResponse> fetchGames(int limit, int offset, Config config) async {
  CacheStore store = await CacheStore.getInstance(
    namespace:
        'unique_name', // default: null - valid filename used as unique id
    policy: LeastFrequentlyUsedPolicy(
      maxCount: 999,
    ), // default: null - will use `LessRecentlyUsedPolicy()`
    // clearNow: true, // default: false - whether to clean up immediately
    fetch: myFetch, // default: null - a shortcut of `CacheStore.fetch`
  );

  // fetch a file from an URL and cache it
  File file = await store.getFile(
    config.server +
        '/api/tenant/${config.operatorId}/game?filter[application]=${config.application}&filter[category]=${config.category}&orderBy=${config.orderBy}&limit=${config.limit}&offset=${config.offset}',
    key: null, // use custom string instead of URL
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${config.token}',
    }, // same as http.get
    fetch: myFetch, // Optional: CustomFunction for making custom request
    // Optional: Map<String, dynamic> any custom you want to pass to your custom fetch function.
    custom: {'method': 'GET'},
    flushCache: false, // whether to re-download the file
  );
  print(file.path);
  // Read the file
  String contents = await file.readAsString();
  print(contents);
  // store json data into list
  var gameResponse = json.decode(contents) as Map<String, dynamic>;

  // iterate over the list and map each object in list to Img by calling Img.fromJson
  GamesResponse games = GamesResponse.fromJson(
      gameResponse); // list.map((i)=>Game.fromJson(i)).toList();

  // print(games.runtimeType); //returns List<Img>
  // print(games[0].runtimeType); //returns Img

  return games;
  // final response = await http.get(
  //     config.server +
  //         '/api/tenant/${config.operatorId}/game?filter[application]=${config.application}&filter[category]=${config.category}&orderBy=${config.orderBy}&limit=${config.limit}&offset=${config.offset}',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer ${config.token}',
  //     });
  //
  // if (response.statusCode == 200) {
  //   // If the server did return a 200 OK response,
  //   // then parse the JSON.
  //   var rb = response.body;
  //
  //   // store json data into list
  //   var gameResponse = json.decode(rb) as Map<String, dynamic>;
  //
  //   // iterate over the list and map each object in list to Img by calling Img.fromJson
  //   GamesResponse games = GamesResponse.fromJson(
  //       gameResponse); // list.map((i)=>Game.fromJson(i)).toList();
  //
  //   // print(games.runtimeType); //returns List<Img>
  //   // print(games[0].runtimeType); //returns Img
  //
  //   return games;
  // } else {
  //   // If the server did not return a 200 OK response,
  //   // then throw an exception.
  //   throw Exception('Failed to load games');
  // }
}

// Custom fetch function.
// A demo of how you can achieve a fetch supporting POST with body
Future<Response> myFetch(url,
    {Map<String, String> headers, Map<String, dynamic> custom}) {
  final data = custom ?? {};
  switch (data['method'] ?? '') {
    case 'POST':
      {
        return post(url, headers: headers, body: data['body']);
      }
    default:
      return get(url, headers: headers);
  }
}

Future<String> fetchGameUrl(
    LaunchConfig gameLaunchConfig, Config config) async {
  String configId = gameLaunchConfig.configId;
  String playerId = gameLaunchConfig.playerId;
  String DEFAULT_INDEX_PATH = "dist";
  final response = await http.get(
      config.server + '/api/launch-config/${config.operatorId}/${configId}',
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
        'gameid=${gameId}&configid=${configId}&server=${config.server}&operatorid=${config.operatorId}&playerid=${playerId}';
    if (gameLaunchConfig.rawUrl != true) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(urlData);
      urlData = 'token=$encoded';
    }
    String gameLink = gameLauncherResponse["gameLink"];
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
