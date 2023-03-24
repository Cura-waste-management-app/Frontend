class Community {
  final String name;
  final String location;
  final String totalMembers;
  final String description;
  final String adminId;
  final String? id;
  final String category;
  late final String imgURL;
  Community(
      {required this.imgURL,
      required this.description,
      required this.adminId,
      required this.category,
      required this.name,
      required this.location,
      required this.totalMembers,
      this.id});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imgURL': imgURL,
      'description': description,
      'category': category,
      'location': location,
      'totalMembers': totalMembers,
    };
  }

  Community.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj["_id"],
        name = jsonObj["name"],
        category = jsonObj["category"],
        location = jsonObj["location"],
        totalMembers = jsonObj["totalParticipant"].toString(),
        imgURL = jsonObj["imgURL"],
        adminId = jsonObj["adminId"],
        description = jsonObj["description"];
}
