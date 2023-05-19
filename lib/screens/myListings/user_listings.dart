// ignore_for_file: avoid_print

import 'package:cura_frontend/common/filter/filter.dart';
import 'package:cura_frontend/common/filter/item_model.dart';
import 'package:cura_frontend/common/main_drawer.dart';
import 'package:cura_frontend/common/search_bar.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/profile/screens/my_profile.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/providers/user_provider.dart';
import 'package:cura_frontend/screens/Listings/models/listings.dart';
import 'package:cura_frontend/screens/myListings/features/active_listings.dart';
import 'package:cura_frontend/screens/myListings/features/shared_listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class UserListings extends StatefulWidget {
  static const routeName = '/my-listings';
  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {
  String searchField = "";
  bool isLoadingData = true;
  bool isLoadingUser = true;
  String uid = "";
  String avatarURL = "";

  List<ItemModel> states = [
    ItemModel("Active", Colors.blue, false),
    ItemModel("Pending", const Color.fromARGB(255, 164, 205, 237), false),
    ItemModel("Shared", Colors.green, false),
  ];

  List<String> filters = [];
  final controller = ScrollController();

  void updateSearchField(String text) {
    Provider.of<ListingsNotifier>(context, listen: false)
        .setSearchResults(text, uid);
    setState(() => {searchField = text});
  }

  void updateFilters(List<String> filterValues) {
    Provider.of<ListingsNotifier>(context, listen: false)
        .setFilterResults(filterValues, uid);
    setState(() {
      filters = filterValues;
    });
  }

  @override
  void initState() {
    super.initState();
    // print("uid -- ${Provider.of<UserNotifier>(context, listen: false).currentUser}");
    // setState(() {
    //   uid = Provider.of<UserNotifier>(context, listen: false).currentUser!.id;
    //   print("uid --- $uid");
    //   isLoadingUser = false; // delete this state
    // });

    Provider.of<UserNotifier>(context, listen: false)
        .fetchUserInfo()
        .then((user) {
      setState(() {
        uid = user!.id;
        avatarURL = user.avatarURL ?? defaultNetworkImage;
        isLoadingUser = false;
      });
      if (Provider.of<UserNotifier>(context, listen: false).userFetchError) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBarWidget(
                text: "Oops, Some Error Occurred, Please try again later!")
            .getSnackBar());
      } else {
        Provider.of<ListingsNotifier>(context, listen: false)
            .getListings(uid)
            .then((value) {
          setState(() {
            isLoadingData = false;
          });

          if (Provider.of<ListingsNotifier>(context, listen: false)
              .listingsFetchError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBarWidget(
                    text: "Oops, Some Error Occurred, Please try again later!")
                .getSnackBar());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // toolbarHeight: 70,
          elevation: getProportionateScreenHeight(2),

          leadingWidth: getProportionateScreenWidth(65),
          iconTheme: const IconThemeData(color: Colors.black),
          leading: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(22)),
            child: isLoadingUser
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(MyProfile.routeName);
                    },
                    //// correcttttttttttt, if avatar url is null
                    child: CircleAvatar(
                        radius: getProportionateScreenWidth(25),
                        backgroundImage: NetworkImage(
                            avatarURL != "" ? avatarURL : defaultNetworkImage)),
                  ),
          ),
          title:
              const Text('My Listings', style: TextStyle(color: Colors.black)),
        ),
        endDrawer: MainDrawer(),
        body: isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(6),
                          bottom: getProportionateScreenHeight(6)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ChangeNotifierProvider(
                              create: (context) => ListingsNotifier(),
                              child: SearchBar(
                                  label: "Search in listings",
                                  setField: updateSearchField),
                            ),
                            Filter(chipList: states, setFilters: updateFilters),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                            //todo handle height as per screen, also handle scrollablity

                            height: getProportionateScreenHeight(620),
                            margin: EdgeInsets.only(
                                right: getProportionateScreenWidth(3)),
                            child: Selector<ListingsNotifier, List<Listing>>(
                                selector: (context, notifier) =>
                                    notifier.userListings,
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
                                                print(
                                                    "in user Listings ############");
                                                return listings[i].status ==
                                                        "Shared"
                                                    ? SharedListings(
                                                        listings[i])
                                                    : ActiveListings(
                                                        listing: listings[i],
                                                        uid: uid);
                                              }));
                                }))
                      ]),
                    ),
                  ),
                ],
              ));
  }
}
