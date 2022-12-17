class DisplayItem {
  String id = "";
  String title = "";
  String description = "";
  String imagePath = "";
  double rating = 0;
  int views = 0;
  int likes = 0;
  String userName = '';
  String status = "Pending";
  String timeAdded = "";
  String distance = "4545";

  String userImageURL = 'assets/images/female_user.png';

  DisplayItem(
      {required this.userImageURL,
      required this.id,
      required this.title,
      required this.description,
      required this.imagePath,
      required this.rating,
      required this.views,
      required this.likes,
      required this.status,
      required this.timeAdded,
      required this.distance,
      required this.userName});
}
