import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:cura_frontend/features/addlisting/add_screen.dart';
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

  HomeListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 120),
        child: Column(
          children: <Widget>[
            // ignore: unnecessary_cast
            ...((displayItems as List).map(
              (item) {
                return (Container(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.all(0),
                                  child: Image.asset(
                                    item.imagePath,
                                    height: 125,
                                    width: 125,
                                  )),
                              // ignore: avoid_unnecessary_containers
                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(item.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black,
                                              ))),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(item.timeAdded)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(item.contributor)),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(item.rating.toString())),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text("${item.distance} km")),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(item.views.toString())),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          // icon: Icon(Icons.arrow_back_sharp),
                                          child: Text(item.likes.toString())),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ))),
                ));
              },
            )).toList(),
            FloatingActionButton(onPressed: () {
              Navigator.pushNamed(context, AddListing.routeName);
            })
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigation(index: 0),
    );
  }
}
