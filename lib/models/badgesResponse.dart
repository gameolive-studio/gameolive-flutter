import 'badge.dart';

class BadgesResponse {
  final List<Badge>? badges;
  final int count;

  BadgesResponse({this.badges, required this.count});

  factory BadgesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List;
    List<Badge>? games =
        list == null ? null : list.map((i) => Badge.fromJson(i)).toList();

    return BadgesResponse(
      badges: games,
      count: json['count'],
    );
  }
}
