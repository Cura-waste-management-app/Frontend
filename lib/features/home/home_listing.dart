import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:cura_frontend/features/ItemDetails/item_detail.dart';
import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/home/widgets/icon_view.dart';
import 'package:cura_frontend/features/home/widgets/tag_category.dart';
import 'package:flutter/material.dart';
import '../../models/display_item.dart';
import '../../util/constants/constant_data_models.dart';
import '../community/models/community_type_model.dart';

class HomeListing extends StatefulWidget {
  static const routeName = '/home-listing-screen';

  const HomeListing({super.key});

  @override
  State<HomeListing> createState() => _HomeListingState();
}

class _HomeListingState extends State<HomeListing> {
  final List<DisplayItem> displayItems = [
    DisplayItem(
        id: 'i1',
        title: 'Leather Jacket',
        imagePath: 'assets/images/jacket.jpg',
        description: "Almost new leather jacket in L size.",
        rating: 4.0,
        views: 10,
        likes: 2,
        status: "Pending",
        timeAdded: 'Just Now',
        distance: "556 m",
        userImageURL: 'assets/images/male_user.png',
        userName: "Chris Roy"),
    DisplayItem(
        id: 'i2',
        title: 'Study chair',
        imagePath: 'assets/images/chair.jpg',
        description: "Comfortable wooden chair with straight back.",
        rating: 3.0,
        views: 5,
        likes: 0,
        status: "Pending",
        timeAdded: '3 Days Ago',
        distance: "734 m",
        userImageURL: 'assets/images/female_user.png',
        userName: 'Amanda Waller'),
    DisplayItem(
        id: 'i1',
        title: 'Leather Jacket',
        imagePath: 'assets/images/jacket.jpg',
        description: "Almost new leather jacket in L size.",
        rating: 4.0,
        views: 10,
        likes: 2,
        status: "Pending",
        timeAdded: 'Just Now',
        distance: "556 m",
        userImageURL: 'assets/images/male_user.png',
        userName: "Chris Roy"),
    DisplayItem(
        id: 'i2',
        title: 'Study chair',
        imagePath: 'assets/images/chair.jpg',
        description: "Comfortable wooden chair with straight back.",
        rating: 3.0,
        views: 5,
        likes: 0,
        status: "Pending",
        timeAdded: '3 Days Ago',
        distance: "734 m",
        userImageURL: 'assets/images/female_user.png',
        userName: 'Amanda Waller'),
    DisplayItem(
        id: 'i1',
        title: 'Leather Jacket',
        imagePath: 'assets/images/jacket.jpg',
        description: "Almost new leather jacket in L size.",
        rating: 4.0,
        views: 10,
        likes: 2,
        status: "Pending",
        timeAdded: 'Just Now',
        distance: "556 m",
        userImageURL: 'assets/images/male_user.png',
        userName: "Chris Roy"),
    DisplayItem(
        id: 'i2',
        title: 'Study chair',
        imagePath: 'assets/images/chair.jpg',
        description: "Comfortable wooden chair with straight back.",
        rating: 3.0,
        views: 5,
        likes: 0,
        status: "Pending",
        timeAdded: '3 Days Ago',
        distance: "734 m",
        userImageURL: 'assets/images/female_user.png',
        userName: 'Amanda Waller'),
    DisplayItem(
        id: 'i1',
        title: 'Leather Jacket',
        imagePath: 'assets/images/jacket.jpg',
        description: "Almost new leather jacket in L size.",
        rating: 4.0,
        views: 10,
        likes: 2,
        status: "Pending",
        timeAdded: 'Just Now',
        distance: "556 m",
        userImageURL: 'assets/images/male_user.png',
        userName: "Chris Roy"),
    DisplayItem(
        id: 'i2',
        title: 'Study chair',
        imagePath: 'assets/images/chair.jpg',
        description: "Comfortable wooden chair with straight back.",
        rating: 3.0,
        views: 5,
        likes: 0,
        status: "Pending",
        timeAdded: '3 Days Ago',
        distance: "734 m",
        userImageURL: 'assets/images/female_user.png',
        userName: 'Amanda Waller'),
    DisplayItem(
        id: 'i1',
        title: 'Leather Jacket',
        imagePath: 'assets/images/jacket.jpg',
        description: "Almost new leather jacket in L size.",
        rating: 4.0,
        views: 10,
        likes: 2,
        status: "Pending",
        timeAdded: 'Just Now',
        distance: "556 m",
        userImageURL: 'assets/images/male_user.png',
        userName: "Chris Roy"),
    DisplayItem(
        id: 'i2',
        title: 'Study chair',
        imagePath: 'assets/images/chair.jpg',
        description: "Comfortable wooden chair with straight back.",
        rating: 3.0,
        views: 5,
        likes: 0,
        status: "Pending",
        timeAdded: '3 Days Ago',
        distance: "734 m",
        userImageURL: 'assets/images/female_user.png',
        userName: 'Amanda Waller'),
  ];
  List<CommunityTypeModel> communityTypeList =
      ConstantDataModels.communityTypeList;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as DisplayItem?;

    if (routeArgs != null) {
      print(routeArgs.title);
      print(routeArgs.description);
      setState(() {
        // displayItems.insert(0, routeArgs);
      });
    } else {
      // print("+++++++++====");
      // print(displayItems.first.distance);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 1,
        leadingWidth: 90,
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.search, color: Colors.black87, size: 26),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.list, color: Colors.black87, size: 28),
          ),
        ],
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
              '10.0',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        title: const Text('Cura'),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        // height: MediaQuery.of(context).size.height * 0.8,
        // margin: const EdgeInsets.symmetric(vertical: 60),
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
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(Icons.filter_alt, size: 16),
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
                            category: communityTypeList[index].type);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            Flexible(
              child: ListView(
                children: <Widget>[
                  // ign
                  // ore: unnecessary_cast
                  ...((displayItems as List).map(
                    (item) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetail(displayItem: item))),
                        child: (Card(
                            margin: const EdgeInsets.only(bottom: 10, top: 6),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(0),
                                          child: Image.asset(
                                            item.imagePath,
                                            height: 100,
                                            width: 125,
                                          )),
                                      // ignore: avoid_unnecessary_containers
                                      Expanded(
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Text(item.title,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ))),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            color:
                                                                Colors.green),
                                                    // margin: const EdgeInsets.all(10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                          item.timeAdded,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white)),
                                                    )),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 6,
                                            // ),
                                            Row(children: <Widget>[
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    item.userImageURL),
                                                maxRadius: 25,
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Text(item.chatRecipientName),
                                              IconView(
                                                  icon: Icons.star,
                                                  iconColor: Colors.yellow,
                                                  count: item.rating.toString())
                                            ]),
                                            // SizedBox(
                                            //   height: 3,
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                IconView(
                                                    icon: Icons
                                                        .location_on_outlined,
                                                    count: item.distance
                                                        .toString()),
                                                IconView(
                                                    icon: Icons
                                                        .remove_red_eye_outlined,
                                                    count:
                                                        item.views.toString()),
                                                IconView(
                                                    icon: Icons.favorite,
                                                    count:
                                                        item.likes.toString()),
                                                IconView(
                                                    icon: Icons.ios_share,
                                                    count: "")
                                                // Expanded(flex: 1,child: Container(child: Text(item.views.toString()))),
                                                // Expanded(flex: 1,child: Container(child: Text(item.likes.toString()))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ))),
                      );
                    },
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddListing.routeName,
          );
        },
        backgroundColor: Colors.black,
      ),

      bottomNavigationBar: BottomNavigation(index: 0),
    );
  }
}
