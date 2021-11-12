import 'photo.dart';
import 'configuration.dart';

class Game {
  final String? id;
  final String? title;
  final Configuration? configuration;
  final List<Photo>? photos;
  String? label;
  String? description;
  bool? enabled;
  double? rating;
  double? playerCount;
  Game({this.id, this.title, this.configuration, this.photos});

  factory Game.fromJson(Map<String, dynamic> json) {
    var list = json['photos'] as List;
    List<Photo>? photos =
        list == null ? null : list.map((i) => Photo.fromJson(i)).toList();

    var game = Game(
        id: json['id'],
        title: json['name'],
        configuration: Configuration.fromJson(json['configuration']),
        photos: photos);

    json['label'] != null ? game.label = json['label'] : game.label = "";
    json['description'] != null
        ? game.description = json['description']
        : game.description = "";
    json['enabled'] != null
        ? game.enabled = json['enabled']
        : game.enabled = true;
    json['rating'] != null ? game.rating = json['rating'] : game.rating = 0;
    json['playerCount'] != null
        ? game.playerCount = json['playerCount']
        : game.playerCount = 0;

    return game;
  }
}
