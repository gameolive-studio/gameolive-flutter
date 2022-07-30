class Config {
  final String operatorId;
  final String clientId;
  final String clientSecret;
  final String server;
  final String static;
  String application = "android";

  String? token = "";
  String? orderBy = "";
  int limit = 10;
  int offset = 0;
  String? category;

  Config(
      {required this.operatorId,
      required this.clientId,
      required this.clientSecret,
      required this.server,
      required this.static});

  factory Config.fromJson(Map<String, String> json) {
    Config config = Config(
        operatorId: json['operatorId'] ?? "",
        clientId: json['clientId'] ?? "",
        clientSecret: json['clientSecret'] ?? "",
        server: json['server'] ?? "",
        static: json['static'] ?? "");
    if (json["category"] != null) {
      config.category = json["category"];
    }
    return config;
  }
}
