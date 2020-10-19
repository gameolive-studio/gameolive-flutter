import 'photo.dart';
import 'configuration.dart';

class Game {
  final String id;
  final String title;
  final Configuration configuration;
  final  List<Photo> photos;
  Game({this.id, this.title, this.configuration, this.photos});

  factory Game.fromJson(Map<String, dynamic> json) {
    var list = json['photos'] as List;
    List<Photo> photos = list==null ? null : list.map((i) => Photo.fromJson(i)).toList();

    return Game(
      id: json['id'],
      title: json['name'],
      configuration: Configuration.fromJson(json['configuration']),
      photos: photos
    );
  }
}