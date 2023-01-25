import 'package:flutter/material.dart';
import 'package:cura_frontend/screens/myListings/features/header.dart';
import 'package:cura_frontend/screens/myListings/features/search_bar.dart';
import 'package:cura_frontend/screens/myListings/features/filter.dart';
import 'package:cura_frontend/screens/myListings/features/active_listings.dart';
import 'package:cura_frontend/screens/myListings/features/shared_listings.dart';
import 'package:provider/provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';

// ignore: use_key_in_widget_constructors
class UserListings extends StatefulWidget {
  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {
  String searchField = "";

  void updateSearchField(String text) {
    setState(() => {searchField = text});
    // print(searchField);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ListingsNotifier>(context, listen: false).getListings();

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
                child: Consumer<ListingsNotifier>(
                    builder: (context, notifier, child) {
                  return Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: ListView.builder(
                          itemCount: notifier.userListings.length,
                          itemBuilder: (c, i) =>
                              notifier.userListings[i].status == "Active"
                                  ? ActiveListings(
                                      listing: notifier.userListings[i],
                                    )
                                  : SharedListings(notifier.userListings[i])));
                }))
          ]),
        ));
  }
}
