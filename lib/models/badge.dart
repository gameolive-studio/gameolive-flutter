class Badge {
  final String? identifier;
  final String? title;
  final bool? isActive;
  String? iconLink;
  String? description;

  Badge({this.identifier, this.title, this.isActive});

  factory Badge.fromJson(Map<String, dynamic> json) {
    var badge = Badge(
        identifier: json['identifier'],
        title: json['title'],
        isActive: json['isActive']);

    json['iconLink'] != null
        ? badge.iconLink = json['iconLink']
        : badge.iconLink = "";
    json['description'] != null
        ? badge.description = json['description']
        : badge.description = "";

    return badge;
  }
}
