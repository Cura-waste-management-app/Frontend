class Community {
  late String name;
  late String location;
  late String totalMembers;
  late String description;
  late String adminId;
  late String? id;
  late String category;
  late String imgURL;
  late String? type;
  Community(
      {required this.imgURL,
      required this.description,
      required this.adminId,
      required this.category,
      required this.name,
      required this.location,
      required this.totalMembers,
      this.type,
      this.id});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imgURL': imgURL,
      'description': description,
      'category': category,
      'location': location,
    };
  }

  Community.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj["_id"],
        name = jsonObj["name"],
        category = jsonObj["category"],
        location = jsonObj["location"],
        totalMembers = (jsonObj["totalParticipant"]).toString(),
        imgURL = jsonObj["imgURL"],
        adminId = jsonObj["adminId"],
        description = jsonObj["description"],
        type = jsonObj['type'];
}
