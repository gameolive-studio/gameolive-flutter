class Leader {
  String? id;
  num? score;
  String? playerIdentifier;
  String? playerName;
  String? playerAvatar;
  bool? isCurrent;

  Leader(
      {this.id,
      this.score,
      this.playerIdentifier,
      this.playerName,
      this.playerAvatar,
      this.isCurrent});

  Leader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    score = json['score'];
    playerIdentifier = json['playerIdentifier'];
    playerName = json['playerName'];
    playerAvatar = json['playerAvatar'];
    isCurrent = json['isCurrent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['playerIdentifier'] = playerIdentifier;
    data['playerName'] = playerName;
    data['playerAvatar'] = playerAvatar;
    data['isCurrent'] = isCurrent;
    return data;
  }
}
