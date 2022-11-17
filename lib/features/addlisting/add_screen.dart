import 'package:cura_frontend/features/addlisting/top_navigation_bar.dart';
import 'package:flutter/material.dart';

class AddListing extends StatelessWidget {
  const AddListing({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const TopNavigationBar(),
        ],
      ),
    );
  }
}
