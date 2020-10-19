
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


import 'models/auth.dart';
import 'models/config.dart';
import 'models/gamesResponse.dart';
import 'services/authService.dart';
import 'services/gamesService.dart';
Config CONFIG;
class Gameolive {
  static const MethodChannel _channel =
      const MethodChannel('gameolive');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String> init(Config config) async {
    final Auth auth = await authenticate(config);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', auth.token);
    CONFIG = config;
    CONFIG.token = auth.token;
    return auth.token;
  }

  static Future<GamesResponse> getGames(int limit, int offset, [Config config]) async {
    if(config  == null){
      config = CONFIG;
    }
    return fetchGames(limit, offset, config);
  }
}
