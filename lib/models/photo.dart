class Photo {
  final String id;
  final String downloadUrl;

  Photo({this.id, this.downloadUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        downloadUrl: json['downloadUrl']
    );
  }
}