class Config {
  final String operatorId;
  final String clientId;
  final String clientSecret;
  final String apiUrl;
  final String serverUrl;

  Config({this.operatorId,this.clientId,this.clientSecret,this.apiUrl,this.serverUrl});

  factory Config.fromJson(Map<String, String> json) {
    return Config(
        operatorId: json['operatorId'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        apiUrl: json['apiUrl'],
        serverUrl: json['operatorId']
    );
  }
}