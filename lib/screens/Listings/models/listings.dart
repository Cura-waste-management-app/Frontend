class Listing {
  String id;
  String title;
  String? description;
  final String category;
  bool? isFavourite;
  bool? isRequested;
  DateTime postTimeStamp;
  DateTime? sharedTimeStamp;
  String status;
  final String owner;
  String location;
  String imagePath;
  int requests;
  int likes;
  List<dynamic>? requestedUsers;
  String? sharedUserID; // id of user to whom listing has been given at the end

  Listing({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.isFavourite = false,
    this.isRequested = false,
    required this.postTimeStamp,
    this.sharedTimeStamp,
    required this.status,
    required this.owner,
    required this.location,
    required this.imagePath,
    this.requests = 0,
    this.likes = 0,
    this.requestedUsers,
    this.sharedUserID
  });

  Listing.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj['_id'],
        title = jsonObj['title'],
        description = jsonObj['description'],
        category = jsonObj['category'],
        postTimeStamp = DateTime.parse(jsonObj['postTimeStamp']),
        sharedTimeStamp = jsonObj['sharedTimeStamp'] != null ? DateTime.parse(jsonObj['sharedTimeStamp']): null,
        status = jsonObj['status'],
        owner = jsonObj['owner'],
        location = jsonObj['location'],
        imagePath = jsonObj['imagePath'],
        requests = jsonObj['requests'] ,
        likes = jsonObj['likes'] ,
        requestedUsers = jsonObj['requestedUsers'],
        sharedUserID = jsonObj['sharedUserID'];
}
