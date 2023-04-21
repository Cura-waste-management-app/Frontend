import 'dart:math';

class Event {
  late String? id;
  late String name;
  late String description;
  late String adminId;
  late String? totalMembers;
  late String communityId;
  late String timestamp;
  late String location;
  Event({
    this.id,
    required this.name,
    required this.description,
    required this.adminId,
    this.totalMembers,
    required this.communityId,
    required this.timestamp,
    required this.location,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      adminId: json['creatorId'],
      totalMembers: (json['totalMembers'] + 10).toString(),
      communityId: json['communityId'],
      timestamp: "${Random().nextInt(10)} days ago",
      location: json['location'],
    );
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
