import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:gameolive/models/badgesResponse.dart';
import 'package:gameolive/shared/GameoliveCacheManager.dart';
import 'package:gameolive/shared/playmode.dart';

import '../models/config.dart';

Future<BadgesResponse> fetchAvailableBadges(Config config) async {
  String path =
      '${config.server}/api/tenant/${config.operatorId}/available-badges?filter[application]=${config.application}&category=${config.category}';

  try {
    var file = await GameoliveCacheManager.instance
        .getSingleFile(path, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${config.token}',
    });
    if (await file.exists()) {
      var res = await file.readAsString();

      BadgesResponse badges = BadgesResponse.fromJson(json.decode(res));
      // REF_BADGES = badges;
      return badges;
    }
  } catch (ex) {
    if (kDebugMode) {
      print(
          "Seems like, there is some trouble with app caching, so fetching from server (a bit unoptimized)");
    }
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
    var badgesResponse = json.decode(rb) as Map<String, dynamic>;

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    BadgesResponse badges = BadgesResponse.fromJson(badgesResponse);

    return badges;
  } else {
    throw Exception('Failed to load badges');
  }
}

Future<List<String>> fetchUserBadges(
    String playerUid, PlayMode playMode, Config config) async {
  String path =
      '${config.server}/api/tenant/${config.operatorId}/user-badges?filter[application]=${config.application}&filter[player_uid]=$playerUid&filter[category]=${config.category}&filter[playMode]=${playMode.toString()}';

  final response = await http.get(Uri.parse(path), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${config.token}',
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var badgesResponse = json.decode(rb) as List<String>;

    return badgesResponse;
  } else {
    throw Exception('Failed to load user badges');
  }
}
