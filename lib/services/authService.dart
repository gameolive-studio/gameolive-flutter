import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth.dart';
import '../models/config.dart';


Future<Auth> authenticate(Config config) async {
  final response = await http.get('http://my-json-server.typicode.com/auth');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var rb = response.body;

    // store json data into list
    // var list = json.decode(rb) as List;

    // iterate over the list and map each object in list to Img by calling Img.fromJson
    Auth auth = Auth.fromJson(json.decode(rb));
    return auth;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load posts');
  }
}