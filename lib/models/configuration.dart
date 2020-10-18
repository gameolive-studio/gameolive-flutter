class Configuration {
  final String id;

  Configuration({this.id});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      id: json['id']
    );
  }
}