class PlayerAchievement {
  num? progress;
  bool? isAcknowledged;
  DateTime? validUpto;
  String? achievementIdentifier;
  Achievement? achievement;

  PlayerAchievement(
      {this.progress,
      this.isAcknowledged,
      this.validUpto,
      this.achievementIdentifier,
      this.achievement});

  PlayerAchievement.fromJson(Map<String, dynamic> json) {
    progress = json['progress'];
    isAcknowledged = json['isAcknowledged'];
    validUpto = json['validUpto'];
    achievementIdentifier = json['achievementIdentifier'];
    achievement = json['achievement'] != null
        ? Achievement.fromJson(json['achievement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['progress'] = progress;
    data['isAcknowledged'] = isAcknowledged;
    data['validUpto'] = validUpto;
    data['achievementIdentifier'] = achievementIdentifier;
    if (achievement != null) {
      data['achievement'] = achievement!.toJson();
    }
    return data;
  }
}

class Achievement {
  String? id;
  String? identifier;
  String? title;
  String? subTitle;
  String? description;
  String? targetType;
  num? target;
  String? expiry;
  num? expiryDays;
  DateTime? expiryDate;
  bool? accumulate;
  bool? isActive;
  String? updatedAt;
  String? iconLink;
  num? levelOrderNumber;

  Achievement(
      {this.id,
      this.identifier,
      this.title,
      this.subTitle,
      this.description,
      this.targetType,
      this.target,
      this.expiry,
      this.expiryDays,
      this.expiryDate,
      this.accumulate,
      this.isActive,
      this.updatedAt,
      this.iconLink,
      this.levelOrderNumber});

  Achievement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    title = json['title'];
    subTitle = json['subTitle'];
    description = json['description'];
    targetType = json['targetType'];
    target = json['target'];
    expiry = json['expiry'];
    expiryDays = json['expiryDays'];
    expiryDate = json['expiryDate'];
    accumulate = json['accumulate'];
    isActive = json['isActive'];
    updatedAt = json['updatedAt'];
    iconLink = json['iconLink'];
    levelOrderNumber = json['levelOrderNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['identifier'] = identifier;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['description'] = description;
    data['targetType'] = targetType;
    data['target'] = target;
    data['expiry'] = expiry;
    data['expiryDays'] = expiryDays;
    data['expiryDate'] = expiryDate;
    data['accumulate'] = accumulate;
    data['isActive'] = isActive;
    data['updatedAt'] = updatedAt;
    data['iconLink'] = iconLink;
    data['levelOrderNumber'] = levelOrderNumber;
    return data;
  }
}
