class Event {
  final String? id;
  final String name;
  final String description;
  final String adminId;
  final String? totalMembers;
  final String communityID;
  final String timestamp;
  final String location;
  Event({
    this.id,
    required this.name,
    required this.description,
    required this.adminId,
    this.totalMembers,
    required this.communityID,
    required this.timestamp,
    required this.location,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      adminId: json['adminId'],
      totalMembers: json['totalMembers'],
      communityID: json['communityID'],
      timestamp: json['timestamp'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'adminId': adminId,
      'totalMembers': totalMembers,
      'communityID': communityID,
      'timestamp': timestamp,
      'location': location,
    };
  }
}
