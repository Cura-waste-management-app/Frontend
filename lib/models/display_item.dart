import 'package:flutter/material.dart';

class DisplayItem {
  String id = "";
  String title = "";
  String contributor = "";
  String imagePath = "";
  double rating = 0;
  int views = 0;
  int likes = 0;
  double distance = 0;
  String timeAdded = "";

  DisplayItem(
      {required this.id,
      required this.title,
      required this.contributor,
      required this.imagePath,
      required this.rating,
      required this.views,
      required this.likes,
      required this.distance,
      required this.timeAdded});
}
