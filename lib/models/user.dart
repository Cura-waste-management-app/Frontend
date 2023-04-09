class User {
  String id;
  String name;
  String? emailID;
  String? avatarURL;
  int? points;
  int? itemsReceived;
  int? itemsShared;

  User(
      {required this.id,
      required this.name,
      this.emailID,
      this.avatarURL,
      this.points = 0,
      this.itemsReceived,
      this.itemsShared});

  User.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj['_id'],
        name = jsonObj['name'],
        emailID = jsonObj['emailID'],
        avatarURL = jsonObj['avatarURL'],
        points = jsonObj['points'],
        itemsReceived = jsonObj['itemsReceived'],
        itemsShared = jsonObj['itemsShared'];
}
