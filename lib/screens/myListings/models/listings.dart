class Listing {
  final String id;
  final String name;
  final String description;
  final String category;
  final DateTime postDate;
  final DateTime sharedDate;
  final String status;
  final String ownerID;
  final String location;
  final String imgURL;
  final int requests ;
  final int likes ;
  final int views ;

  Listing(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.postDate,
      required this.sharedDate,
      required this.status,
      required this.ownerID,
      required this.location,
      required this.imgURL,
      required this.requests,
      required this.likes,
      required this.views
      });
}
