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
      description: "Almost new leather jacket in L size.",
      rating: 4.0,
      views: 10,
      likes: 2,
      status: "Pending",
      timeAdded: 'Just Now',
    ),
    DisplayItem(
      id: 'i2',
      title: 'Study chair',
      
      imagePath: 'assets/images/chair.jpg',
      description: "Comfortable wooden chair with straight back.",
      rating: 3.0,
      views: 5,
      likes: 0,
      status: "Pending",
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
        // height: MediaQuery.of(context).size.height * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 60),
        child: ListView(
          children: <Widget>[
            // ignore: unnecessary_cast
            ...((displayItems as List).map(
              (item) {
                return (Card(
                    elevation: 5,
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
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Text(item.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black,
                                              ))),
                                      Container(
                                          // margin: const EdgeInsets.all(10),
                                          child: Text(item.timeAdded)),
                                    ],
                                  ),

                                 
                                  
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(margin: EdgeInsets.symmetric(horizontal: 10),child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye),
                                          Text(item.views.toString()),
                                        ],
                                      )),
                                      Container(margin: EdgeInsets.symmetric(horizontal: 10),child: Row(
                                        children: [
                                          Icon(Icons.favorite),
                                          Text(item.likes.toString()),
                                        ],
                                      )),
                                      // Expanded(flex: 1,child: Container(child: Text(item.views.toString()))),
                                      // Expanded(flex: 1,child: Container(child: Text(item.likes.toString()))),
                                      
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          )))
                );
              },
            )).toList(),

            
            
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
              Navigator.pushNamed(context, AddListing.routeName);
            },
            backgroundColor: Colors.black,
            ),

      bottomNavigationBar: BottomNavigation(index: 0),
    );
  }
}
