class Listing {
  String id;
  String state;
  String postDate;
  String name;
  String imgURL;
  int requests = 0;
  int likes = 0;
  int views = 0;

  Listing(
      {required this.id,
      required this.state,
      required this.postDate,
      required this.name,
      required this.imgURL,
      required this.requests,
      required this.likes,
      required this.views});
}
