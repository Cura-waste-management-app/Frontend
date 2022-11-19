import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../models/display_item.dart';

class HomeListing extends StatelessWidget {
  final List<DisplayItem> displayItems = [
    DisplayItem(
      id: 'i1',
      title: 'Leather Jacket',
      imagePath: 'assets/images/jacket.jpg',
      contributor: 'Jos Buttler',
      rating: 4.0,
      views: 10,
      likes: 2,
      distance: 2.3,
      timeAdded: 'Just Now',
    ),
    DisplayItem(
      id: 'i2',
      title: 'Study chair',
      contributor: 'Ajay Singh',
      imagePath: 'assets/images/chair.jpg',
      rating: 3.0,
      views: 5,
      likes: 0,
      distance: 1.3,
      timeAdded: 'Just Now',
    ),
  ];

  static const routeName = '/home-listing-screen';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: const Text("Hello World"),
      ),
    );
  }
}
