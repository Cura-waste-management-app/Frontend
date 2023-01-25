class Listing {
  String id;
  String name;
  String? description;
  final String category;
  String postDate;
  String postTime;
  String? sharedDate;
  String? sharedTime;
  String status;
  final String ownerID;
  String location;
  String imgURL;
  int requests;
  int likes;
  int views;

  Listing(
      {required this.id,
      required this.name,
      this.description,
      required this.category,
      required this.postDate,
      required this.postTime,
      this.sharedDate,
      this.sharedTime,
      required this.status,
      required this.ownerID,
      required this.location,
      required this.imgURL,
      this.requests = 0,
      this.likes = 0,
      this.views = 0});

  Listing.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj['id'],
        name = jsonObj['name'],
        description = jsonObj['description'],
        category = jsonObj['category'],
        postDate = jsonObj['postDate'],
        postTime = jsonObj['postTime'],
        sharedDate = jsonObj['sharedDate'],
        sharedTime = jsonObj['sharedTtime'],
        status = jsonObj['status'],
        ownerID = jsonObj['ownerID'],
        location = jsonObj['location'],
        imgURL = jsonObj['imgURL'],
        requests = jsonObj['requests'],
        likes = jsonObj['likes'],
        views = jsonObj['views'];
}
