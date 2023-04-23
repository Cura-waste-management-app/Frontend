import 'dart:convert';
import 'dart:math';

class Event {
  late String? id;
  late String name;
  late String description;
  late String adminId;
  String? adminName;
  String? adminAvatarURL;
  late String? totalMembers;
  late String communityId;
  late String postTime;
  late String location;
  String imgURL;
  Event(
      {this.id,
      required this.name,
      required this.description,
      required this.adminId,
      this.totalMembers,
      required this.communityId,
      required this.postTime,
      required this.location,
      required this.imgURL,
      this.adminName,
      this.adminAvatarURL});
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        adminId: json['creatorId'],
        totalMembers: json['totalMembers'].toString(),
        communityId: json['communityId'],
        postTime: json['postTime'],
        location: json['location'],
        imgURL: json['imgURL']);
  }

  factory Event.fromJsonWithAdmin(Map<String, dynamic> json) {
    var admin = json['creatorId'];

    return Event(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        adminId: admin['_id'],
        adminName: admin['name'],
        adminAvatarURL: admin['avatarURL'],
        totalMembers: json['totalMembers'].toString(),
        communityId: json['communityId'],
        postTime: json['postTime'],
        location: json['location'],
        imgURL: json['imgURL']);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'creatorId': adminId,
      'totalMembers': totalMembers,
      'communityID': communityId,
      // 'timestamp': timestamp,
      'location': location,
    };
  }
}

//todo get list of names and URL from List of userIDs
