import 'package:cura_frontend/common/main_drawer.dart';
import 'package:cura_frontend/screens/Listings/models/listings.dart';
import 'package:cura_frontend/common/filter/item_model.dart';
import 'package:flutter/material.dart';
import 'package:cura_frontend/screens/myListings/features/header.dart';
import 'package:cura_frontend/screens/myListings/features/search_bar.dart';
import 'package:cura_frontend/common/filter/filter.dart';
import 'package:cura_frontend/screens/myListings/features/active_listings.dart';
import 'package:cura_frontend/screens/myListings/features/shared_listings.dart';
import 'package:provider/provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';

import '../homeListings/home_listings.dart';

// ignore: use_key_in_widget_constructors
class UserListings extends StatefulWidget {
  static const routeName = '/my-listings';
  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {
  String searchField = "";

  List<ItemModel> states = [
    ItemModel("Active", Colors.blue, false),
    ItemModel("Pending", const Color.fromARGB(255, 164, 205, 237), false),
    ItemModel("Shared", Colors.green, false),
  ];

  List<String> filters = [];
  final controller = ScrollController();

  void updateSearchField(String text) {
    Provider.of<ListingsNotifier>(context, listen: false)
        .setSearchResults(text);
    setState(() => {searchField = text});
  }

  void updateFilters(List<String> filterValues) {
    Provider.of<ListingsNotifier>(context, listen: false)
        .setFilterResults(filterValues);
    setState(() {
      filters = filterValues;
    });
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
          backgroundColor: Colors.white,
          // toolbarHeight: 70,
          elevation: 2.0,

          leadingWidth: 65,
          leading: const Padding(
            padding: EdgeInsets.only(left: 22),
            child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBjUuK5Qmq0vFDfUMleYdDJcX5UzPzyeYNdpkflv2haw&s')),
          ),
          title:
              const Text('My Listings', style: TextStyle(color: Colors.black)),
          actions:const [
            Padding(
              padding: EdgeInsets.only(right: 28.0),
              child: Icon(Icons.notifications_none,
                  size: 30, color: Color.fromARGB(255, 87, 86, 86)),
            ),
            
          ],
        ),
        endDrawer: MainDrawer(),
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
                      Filter(chipList: states, setFilters: updateFilters),
                    ]),
              ),
            ),
            Container(
                //todo handle height as per screen, also handle scrollablity
                height: 800,
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
