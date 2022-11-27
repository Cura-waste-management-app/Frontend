class Listing {
  String state;
  String postDate;
  String name;
  String imgURL;
  int requests;
  int likes = 0;

  Listing({
    required this.state,
    required this.postDate,
    required this.name,
    required this.imgURL,
    required this.requests,
    required this.likes,
  });
}
