import 'package:flutter/material.dart';
import 'package:cura_frontend/screens/myListings/features/header.dart';
import 'package:cura_frontend/screens/myListings/features/search_bar.dart';
import 'package:cura_frontend/screens/myListings/features/filter.dart';
import 'package:cura_frontend/screens/myListings/features/active_listings.dart';
import 'package:cura_frontend/screens/myListings/features/shared_listings.dart';
import './dummy_data.dart';

// ignore: use_key_in_widget_constructors
class UserListings extends StatefulWidget {
  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {
  String searchField = "";
  // List<Listing> listings = db.getListings();

  // just for demo, in working just obtain a new list from database
  List<String> deleteID = [];

  void updateListings(String id) {
    // setState(()=>{listings = db.getListings(userID)});
    setState(() => {
          //whole widget is rendered (build) as listings state is updated
          deleteID.add(id)
        });
  }

  void updateSearchField(String text) {
    setState(() => {searchField = text});
    // print(searchField);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[200],
            toolbarHeight: 70,
            elevation: 0.0,
            title: Header()),
        body: SingleChildScrollView(
          child: Column(children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SearchBar(setField: updateSearchField),
                      Filter()
                    ]),
              ),
            ),
            Container(
              height: 580,
              margin: const EdgeInsets.only(right: 3),
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (c, i) => !deleteID.contains(listings[i].id)
                        ? (listings[i].state == "Active"
                            ? ActiveListings(
                                listing: listings[i],
                                updateListingsCB: updateListings)
                            : SharedListings(listings[i]))
                        : const Text('')),
              ),
            ),
          ]),
        ));
  }
}
