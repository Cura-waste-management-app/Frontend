import 'package:flutter/material.dart';
import 'package:cura_frontend/screens/myListings/features/header.dart';
import 'package:cura_frontend/screens/myListings/features/search_bar.dart';
import 'package:cura_frontend/screens/myListings/features/filter.dart';
import 'package:cura_frontend/screens/myListings/features/active_listings.dart';
import 'package:cura_frontend/screens/myListings/features/shared_listings.dart';

// ignore: use_key_in_widget_constructors
class UserListings extends StatelessWidget {
  final List<Widget> listings = [
    ActiveListings(),
    SharedListings(),
    ActiveListings(),
    SharedListings(),
    ActiveListings(),
    SharedListings(),
    ActiveListings(),
    SharedListings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[200],
            toolbarHeight: 70,
            elevation: 0.0,
            title: Header()),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [SearchBar(), Filter()]),
          ),
          Container(
            height: 580,
            margin: const EdgeInsets.only(right: 3),
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (c, i) => listings[i]),
            ),
          ),
        ]));
  }
}
