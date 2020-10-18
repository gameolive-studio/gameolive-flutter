import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';


Future<List<Game>> fetchGames(int limit, int offset) async {
  final response = await http.get('http://my-json-server.typicode.com/games');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    var list = json.decode(rb) as List;

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    List<Game> games = list.map((i)=>Game.fromJson(i)).toList();

    // print(games.runtimeType); //returns List<Img>
    // print(games[0].runtimeType); //returns Img

    return games;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load posts');
  }
}