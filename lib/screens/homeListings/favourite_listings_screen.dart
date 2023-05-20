import 'package:cura_frontend/screens/homeListings/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './features/listing_item.dart';
import './features/tag_category.dart';
import '../../../common/debug_print.dart';
import '../../common/main_drawer.dart';
import '../../providers/home_listings_provider.dart';
import '../Listings/models/community_data_model.dart';
import '../Listings/models/community_type.dart';

class FavouriteListingsScreen extends StatefulWidget {
  // const HomeListings({super.key});
  static const routeName = '/favListings';

  @override
  State<FavouriteListingsScreen> createState() =>
      _FavouriteListingsScreenState();
}

class _FavouriteListingsScreenState extends State<FavouriteListingsScreen> {
  var dummyvar = false;

  List<CommunityType> communityTypeList = CommunityDataModels.communityTypeList;
  void rebuildOverview() {
    setState(() {
      dummyvar = !dummyvar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<HomeListingsNotifier>(context).favitems;
    prints(itemsData);

    double screenWidth = 100.w;
    double screenHeight = 100.h;
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
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 0,
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
                      prints("Filter");
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return FilterDialog();
                          });
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Color.fromARGB(255, 211, 211, 211),
                      child: const Icon(Icons.filter_alt, size: 16),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: screenWidth / 1.2,
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
                ? Column(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset('assets/images/empty_list.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Favourite Listings!!",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Flexible(
                    child: ListView.builder(
                      itemCount: itemsData.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: itemsData[i],
                        child: ListingItem(
                          favscreen: true,
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     // Navigator.of(context).pushNamed(
      //     //   AddListingScreen.routeName,
      //     // );
      //   },
      //   backgroundColor: Colors.black,
      // ),
      // bottomNavigationBar: BottomNavigation(index: 0),
    );
  }
}
