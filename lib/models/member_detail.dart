class MemberDetail {
  String id;
  String name;
  String? avatarURL;

  MemberDetail({
    required this.id,
    required this.name,
    this.avatarURL,
  });
  MemberDetail.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj['_id'],
        name = jsonObj['name'],
        avatarURL = jsonObj['avatarURL'];
}
