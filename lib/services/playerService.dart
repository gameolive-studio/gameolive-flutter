import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/config.dart';


Future<String> fetchPlayerToken(String playerUid, Config config) async {
  final response = await http.post(config.server + '/api/player/token',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "operator_id": config.operatorId,
        "client_secret": config.clientSecret,
        "client_id": config.clientId,
        "player_uid": playerUid,
      })
  );

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