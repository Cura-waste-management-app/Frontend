import 'package:flutter/material.dart';
import 'package:cura_frontend/features/addlisting/widgets/add_image.dart';
import 'package:cura_frontend/features/addlisting/widgets/title_description.dart';
import 'package:cura_frontend/features/addlisting/widgets/top_navigation_bar.dart';
import '../../models/display_item.dart';
import '../home/home_listing.dart';

class AddListing extends StatefulWidget {
  
   static const routeName = '/add-screen';

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
   void addNewItem(String title, String desc){
    final newItem = DisplayItem(id: DateTime.now().toString(), title: title, description: desc, imagePath : "assets/images/chair.jpg", rating: 0, views: 0, likes: 0, status: "Pending", timeAdded: DateTime.now().toString() );
    print(newItem.title);
    print(newItem.description);

    Navigator.pushNamed(context, HomeListing.routeName);
    
   }

  @override
  Widget build(BuildContext context) {
    
    // ignore: avoid_unnecessary_containers
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          TopNavigationBar(),

          // ignore: avoid_unnecessary_containers
          Container(
            margin: const EdgeInsets.only(top: 0.05),
            child: const Divider(
              height: 1,
              color: Color.fromRGBO(197, 197, 197, 1),
              thickness: 1,
            ),
          ),
          AddImage(),
          TitlteDescription(),
        ],
      ),
    );
  }
}
