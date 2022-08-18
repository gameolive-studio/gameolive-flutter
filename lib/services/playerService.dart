import 'dart:convert';

import 'package:gameolive/shared/playmode.dart';
import 'package:http/http.dart' as http;

import '../models/config.dart';
import '../models/player_achievement.dart';

Future<String> fetchPlayerToken(
    String playerUid, PlayMode playMode, Config config) async {
  final response =
      await http.post(Uri.parse('${config.server}/api/player/token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "operator_id": config.operatorId,
            "client_secret": config.clientSecret,
            "client_id": config.clientId,
            "player_uid": playerUid,
            "playMode": playMode.toString()
          }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb);

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    // Auth auth = new Auth(token: rb);
    return list["token"];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get Player Token');
  }
}

Future<List<PlayerAchievement>> fetchPlayerAchievements(
    String playerToken, String playerUid, Config config) async {
  final response = await http.post(
      Uri.parse(
          '${config.server}/api/tenant/${config.operatorId}/get-player-achievements/$playerUid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "operator_id": config.operatorId,
        "client_secret": config.clientSecret,
        "client_id": config.clientId,
        "player_id": playerUid,
        "token": playerToken,
        //  "playMode": playMode.toString()
      }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb);
    List<PlayerAchievement> achievements = [];

    achievements = list == null
        ? achievements
        : list
            .map<PlayerAchievement>((i) => PlayerAchievement.fromJson(i))
            .toList();
    // iterate over the list and map each object in list to Img by calling Img.fromJson
    // Auth auth = new Auth(token: rb);
    return achievements;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get Player Achievements');
  }
}

Future<List<PlayerAchievement>> setAcknowledgementOfPlayerAchievement(
    String playerToken,
    String playerUid,
    String achievementId,
    Config config) async {
  final response = await http.post(
      Uri.parse(
          '${config.server}/api/tenant/${config.operatorId}/acknowledge-player-achievement/$playerUid/$achievementId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "operator_id": config.operatorId,
        "client_secret": config.clientSecret,
        "client_id": config.clientId,
        "player_id": playerUid,
        "token": playerToken,
        // "playMode": playMode.toString()
      }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb);
    List<PlayerAchievement> achievements = [];

    achievements = list == null
        ? achievements
        : list
            .map<PlayerAchievement>((i) => PlayerAchievement.fromJson(i))
            .toList();
    // iterate over the list and map each object in list to Img by calling Img.fromJson
    // Auth auth = new Auth(token: rb);
    return achievements;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get Player Achievements');
  }
}

Future<List<PlayerAchievement>> registerPlayerAction(String playerToken,
    String playerUid, String action, String value, Config config) async {
  final response = await http.post(
      Uri.parse(
          '${config.server}/api/tenant/${config.operatorId}/register-player-action/$playerUid/$action'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "operator_id": config.operatorId,
        "client_secret": config.clientSecret,
        "client_id": config.clientId,
        "player_id": playerUid,
        "token": playerToken,
        "value": value
      }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb);
    List<PlayerAchievement> achievements = [];

    achievements = list == null
        ? achievements
        : list
            .map<PlayerAchievement>((i) => PlayerAchievement.fromJson(i))
            .toList();
    // iterate over the list and map each object in list to Img by calling Img.fromJson
    // Auth auth = new Auth(token: rb);
    return achievements;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to notify Player Action');
  }
}
