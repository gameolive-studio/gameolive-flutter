import 'dart:convert';

import 'package:gameolive/models/gamesResponse.dart';
import 'package:http/http.dart' as http;

import '../models/config.dart';

Future<GamesResponse> fetchGames(int limit, int offset, Config config) async {
  final response = await http.get(config.server + '/api/tenant/${config.operatorId}/game?filter[application]=${config.application}&orderBy=${config.orderBy}&limit=${config.limit}&offset=${config.offset}',
      headers: <String, String>{
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
    GamesResponse games = GamesResponse.fromJson(gameResponse); // list.map((i)=>Game.fromJson(i)).toList();

    // print(games.runtimeType); //returns List<Img>
    // print(games[0].runtimeType); //returns Img

    return games;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load posts');
  }
}