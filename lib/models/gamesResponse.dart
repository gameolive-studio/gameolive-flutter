import 'game.dart';

class GamesResponse {
  final List<Game>? games;
  final int count;

  GamesResponse({this.games, required this.count});

  factory GamesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List;
    List<Game>? games =
        list.isEmpty ? null : list.map((i) => Game.fromJson(i)).toList();

    return GamesResponse(
      games: games,
      count: json['count'],
    );
  }
}
