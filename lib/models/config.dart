import 'dart:io' show Platform;

class Config {
  final String operatorId;
  final String clientId;
  final String clientSecret;
  final String server;
  final String static;
  String application = Platform.isAndroid? "android": Platform.isIOS? "ios" : "website";
  String token  = "";
  String orderBy = "";
  int limit = 10;
  int offset = 0;


  Config({this.operatorId,this.clientId,this.clientSecret,this.server,this.static});

  factory Config.fromJson(Map<String, String> json) {
    return Config(
        operatorId: json['operatorId'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        server: json['server'],
        static: json['static']
    );
  }
}