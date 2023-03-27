import 'package:cura_frontend/screens/Listings/models/listings.dart';
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
  static const routeName = '/my-listings';
  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {

  String searchField = "";
  final controller = ScrollController();

  void updateSearchField(String text) {
     Provider.of<ListingsNotifier>(context, listen: false)
        .setSearchResults(text);
    setState(() => {searchField = text});
  }


  @override
  void initState() {
    super.initState();
    Provider.of<ListingsNotifier>(context, listen: false).getListings();
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
                      ChangeNotifierProvider(
                        create: (context) => ListingsNotifier(),
                        child: SearchBar(setField: updateSearchField),
                      ),
                      Filter()
                    ]),
              ),
            ),
            Container(
                height: 580,
                margin: const EdgeInsets.only(right: 3),
                child: Selector<ListingsNotifier, List<Listing>>(
                    selector: (context, notifier) => notifier.userListings,
                    builder: (context, listings, child) {
                      return listings.isEmpty
                          ? const Text(
                              "Nothing listed yet! Let's share something")
                          : Scrollbar(
                              controller: controller,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: ListView.builder(
                                  controller: controller,
                                  itemCount: listings.length,
                                  itemBuilder: (c, i) {
                                    print("in user Listings ############");
                                    return listings[i].status == "Shared"
                                        ? SharedListings(listings[i])
                                        : ActiveListings(
                                            listing: listings[i],
                                          );
                                  }));
                    }))
          ]),
        ));
  }
}
