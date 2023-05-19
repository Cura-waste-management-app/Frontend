import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/screens/add_listing_arguments.dart';
import 'package:cura_frontend/screens/homeListings/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './features/listing_item.dart';
import './features/tag_category.dart';
import '../../common/main_drawer.dart';
import '../../constants.dart';
import '../../providers/bottom_nav_bar_provider.dart';
import '../../providers/home_listings_provider.dart';
import '../Listings/models/community_data_model.dart';
import '../Listings/models/community_type.dart';
import '../add_listing_screen.dart';

class HomeListings extends StatefulWidget {
  // const HomeListings({super.key});
  static const routeName = '/homeListings';

  @override
  State<HomeListings> createState() => _HomeListingsState();
}

class _HomeListingsState extends State<HomeListings> {
  var serverError = false;
  Future<void> refreshItems(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Provider.of<HomeListingsNotifier>(context, listen: false)
        .fetchAndSetItems()
        .then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((value) {
      if (value.toString() == ('Exception: Timeout')) {
        setState(() {
          serverError = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  var isInit = true;
  var isLoading = true;

  List<CommunityType> communityTypeList = CommunityDataModels.communityTypeList;
  void rebuildOverview() {}

  @override
  void initState() {
    // TODO: implement initState
    // nearest =
    //     Provider.of<HomeListingsNotifier>(context, listen: false).nearestfirst;
    // latest =
    //     Provider.of<HomeListingsNotifier>(context, listen: false).latestfirst;

    // Provider.of<UserNotifier>(context, listen: false)
    //     .fetchUserInfo()
    //     .then((value) {
    //   print(value);
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });

      Provider.of<HomeListingsNotifier>(context).fetchAndSetItems().then((_) {
        setState(() {
          isLoading = false;
        });
      }).catchError((value) {
        print(value);
        if (value.toString() == ('Exception: Timeout')) {
          setState(() {
            serverError = true;
          });
        }
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(width: 100.w, height: 100.h);
    final itemsData = Provider.of<HomeListingsNotifier>(context).items;

    // double screenWidth = 100.w;
    // double screenHeight = 100.h;
    // List itemsData = [];

    // final GlobalKey _scaffoldKey = new GlobalKey();

    // void openDrawer() {}

    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 1,
        leadingWidth: 90,
        iconTheme: IconThemeData(color: Colors.black),
        leading: Row(
          children: [
            Container(
              // ignore: prefer_const_constructors
              margin: EdgeInsets.only(left: 10),
              // ignore: prefer_const_constructors
              child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.local_fire_department,
                      color: Colors.white, size: 20)),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              '1.0',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        title: const Text(
          'Cura - We Care',
          style: TextStyle(color: Colors.black),
        ),
      ),
      endDrawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshItems(context),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Filter");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return FilterDialog();
                                  });
                            },
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  Color.fromARGB(255, 211, 211, 211),
                              child: const Icon(Icons.filter_alt, size: 16),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: (100 / 1.2).w,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: communityTypeList.length,
                              itemBuilder: (context, index) {
                                return TagCategory(
                                  icon: communityTypeList[index].icon,
                                  category: communityTypeList[index].type,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),

                    itemsData.length == 0
                        ? Flexible(
                            child: ListView(children: [
                              Column(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 300,
                                      width: 300,
                                      child: serverError == false
                                          ? Image.asset(
                                              'assets/images/empty_list.png',
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              'assets/images/serv.jpg',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: serverError == false
                                            ? Text(
                                                "No Listings available!!",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )
                                            : Text(
                                                "Server is unreachable.",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Pull down to Refresh",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                          )
                        : Flexible(
                            child: ListView.builder(
                              itemCount: itemsData.length,
                              itemBuilder: (ctx, i) =>
                                  ChangeNotifierProvider.value(
                                value: itemsData[i],
                                child: ListingItem(
                                  favscreen: false,
                                  reqscreen: false,
                                  rebuildOverview: rebuildOverview,
                                ),
                              ),
                            ),
                          )

                    // Container(
                    //     height: 580,
                    //     margin: const EdgeInsets.only(right: 3),
                    //     child: Consumer<HomeListingsNotifier>(
                    //         builder: (context, notifier, child) {
                    //       return notifier.items.length == 0
                    //           ? Column(
                    //               children: [
                    //                 Center(
                    //                   child: SizedBox(
                    //                     height: 300,
                    //                     width: 300,
                    //                     child: Image.asset(
                    //                         'assets/images/empty_list.png',
                    //                         fit: BoxFit.cover),
                    //                   ),
                    //                 ),
                    //                 Center(
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Text(
                    //                       "No Listings available!!",
                    //                       style: TextStyle(
                    //                         fontSize: 18,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               ],
                    //             )
                    //           : Text("Hi");
                    //       // : Scrollbar(
                    //       //     thumbVisibility: true,
                    //       //     trackVisibility: true,
                    //       //     child: ListView.builder(
                    //       //       itemCount: notifier.items.length,
                    //       //       itemBuilder: (c, i) => ListingItem(
                    //       //         listing: notifier.items[i],
                    //       //       ),
                    //       //     ),
                    //       //   );
                    //     })),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var userData2 = await Hive.openBox(userDataBox);
          print(userData2);
          var uid2 = userData2.get('uid');
          Navigator.of(context).pushNamed(AddListingScreen.routeName,
              arguments: AddListingArguments(uid: uid2, type: 'add'));
        },
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar:
          Provider.of<BottomNavBarProvider>(context, listen: false)
              .myBottomNavigation,
    );
  }
}
