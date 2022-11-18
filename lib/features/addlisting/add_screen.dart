import 'package:cura_frontend/features/addlisting/widgets/add_image.dart';
import 'package:cura_frontend/features/addlisting/widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class AddListing extends StatelessWidget {
  const AddListing({super.key});
   static const routeName = '/add-screen';

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const TopNavigationBar(),

          // ignore: avoid_unnecessary_containers
          Container(
            margin: const EdgeInsets.only(top: 0.05),
            child: const Divider(
              height: 1,
              color: Color.fromRGBO(197, 197, 197, 1),
              thickness: 1,
            ),
          ),
          const AddImage(),
        ],
      ),
    );
  }
}
