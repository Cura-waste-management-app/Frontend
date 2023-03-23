class User {
  String id;
  String name;
  String? emailID;
  String? avatarURL;
  int? points;

  User({required this.id,
  required this.name,
    this.emailID,
   this.avatarURL, 
   this.points = 0
   });
}
