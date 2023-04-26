// import 'package:curafrontend/screens/other_profile_screen.dart';

// import '../../screens/list_item_detail_screen.dart';

// import '../../common/error_screen.dart';
import 'package:sizer/sizer.dart';

import './icon_view.dart';

import '../../Listings/models/listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_listings_provider.dart';
import 'package:intl/intl.dart';
import '../../../screens/list_item_detail_screen.dart';
import '../../other_profile_screen.dart';

class ListingItem extends StatefulWidget {
  final bool favscreen;
  final bool reqscreen;
  Function rebuildOverview;

  ListingItem(
      {required this.favscreen,
      required this.rebuildOverview,
      required this.reqscreen});

  @override
  State<ListingItem> createState() => _ListingItemState();
}

class _ListingItemState extends State<ListingItem> {
  // const ListingItem({super.key});
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = 100.w;
    final item = Provider.of<Listing>(context);
    final days = DateTime.now().difference(item.postTimeStamp).inDays;
    final hours = DateTime.now().difference(item.postTimeStamp).inHours;
    final mints = DateTime.now().difference(item.postTimeStamp).inMinutes;
    final secs = DateTime.now().difference(item.postTimeStamp).inSeconds;
    String ans = '';
    if (days > 1) {
      ans = '$days days ago';
    } else if (days == 1) {
      ans = '$days day ago';
    } else if (days < 1 && hours > 1) {
      ans = '$hours hours ago';
    } else if (days < 1 && hours == 1) {
      ans = '$hours hour ago';
    } else if (hours < 1 && mints > 1) {
      ans = '$mints minutes ago';
    } else if (hours < 1 && mints == 1) {
      ans = '$mints minute ago';
    } else if (mints < 1) {
      secs > 1 ? ans = '$secs seconds ago' : ans = '$secs second ago';
    }

    print(DateTime.now().difference(item.postTimeStamp).inDays);
    return Container(
      // color: Colors.black54,
      // margin: const EdgeInsets.only(
      //   top: 3,
      //   left: 3,
      //   right: 2,
      // ),
      // padding: const EdgeInsets.all(3),

      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.reqscreen
              ? Container(
                  height: 32,

                  // width: 170,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                          item.status == "Accepted" || item.status == 'Shared'
                              ? Icons.check_circle_rounded
                              : item.status == "Cancelled"
                                  ? Icons.cancel_outlined
                                  : Icons.access_time_rounded,
                          color: item.status == "Pending"
                              ? Colors.blue
                              : item.status == "Cancelled"
                                  ? Colors.red
                                  : Colors.green),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.status,
                              style: const TextStyle(fontSize: 13)),
                          Text('Posted 3 days ago',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]))
                        ],
                      )
                    ],
                  ),
                )
              : Text(""),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print(item.id);
                        Navigator.of(context).pushNamed(
                          ListItemDetailScreen.routeName,
                          arguments: {
                            'id': item.id,
                            'path': 'home',
                          },
                        );
                      },
                      child: Image.network(
                        item.imagePath,
                        fit: BoxFit.cover,
                        // height: 100,
                        // width: 125,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  width: screenWidth - 158,
                  // width: double,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              // margin: EdgeInsets.only(
                              //   // top: 5,
                              //   left: 4,
                              // ),
                              // padding: const EdgeInsets.all(5),
                              child: Container(
                                margin: EdgeInsets.only(
                                  // top: 5,
                                  left: 3,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  item.title,
                                  // overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                // color: Colors.black54,
                                margin: EdgeInsets.only(
                                  // top: 5,
                                  right: 1,
                                ),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black54,
                                ),
                                child: Text(
                                  ans,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                            // Text("H")
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.blue,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Provider.of<HomeListingsNotifier>(context,
                                          listen: false)
                                      .getUserInfo(item.owner.id.toString())
                                      .then((_) {
                                    print("no error");

                                    print("no errr");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.of(context).pushNamed(
                                      OtherProfileScreen.routeName,
                                    );
                                  }).catchError((value) {
                                    bool vali = value.toString() ==
                                        ('Exception: Timeout');
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: vali == false
                                          ? Text(
                                              "Could not fetch user details",
                                            )
                                          : Text("Server is unreachable!"),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                          label: "Ok", onPressed: () {}),
                                    ));
                                  });
                                },
                                child: isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            item.owner.avatarURL == null
                                                ? const AssetImage(
                                                    'assets/images/female_user.png',
                                                  )
                                                : NetworkImage(
                                                        item.owner.avatarURL!)
                                                    as ImageProvider,
                                        maxRadius: 20,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Flexible(
                              child: Text(
                                item.owner.name,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconView(
                              icon: Icons.location_on_outlined,
                              count: "${item.distance.toString()} km away",
                            ),
                            item.status != "Shared" &&
                                    item.status != "Cancelled"
                                ? IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,

                                    onPressed: () {
                                      // item.toggleRequest();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                title: item.isRequested!
                                                    ? Text('Cancel request?')
                                                    : Text("Request item?"),
                                                content: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            24,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ElevatedButton(
                                                            //if user click this button, user can upload image from gallery
                                                            onPressed: () {
                                                              item
                                                                  .toggleRequest()
                                                                  .then((_) {
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                                if (widget
                                                                        .reqscreen ==
                                                                    true) {
                                                                  widget
                                                                      .rebuildOverview();
                                                                }
                                                              }).catchError(
                                                                      (value) {
                                                                bool vali = value
                                                                        .toString() ==
                                                                    ('Exception: Timeout');

                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: vali ==
                                                                          false
                                                                      ? Text(
                                                                          "Listing not active. Please Refresh.",
                                                                        )
                                                                      : Text(
                                                                          "Server is unreachable!"),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                  action: SnackBarAction(
                                                                      label:
                                                                          "Ok",
                                                                      onPressed:
                                                                          () {}),
                                                                ));
                                                              });

                                                              // getImage(ImageSource.gallery);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                // Icon(Icons.image),
                                                                Text('Yes'),
                                                              ],
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            //if user click this button, user can upload image from gallery
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                              // getImage(ImageSource.gallery);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                // Icon(Icons.image),
                                                                Text('No'),
                                                              ],
                                                            ),
                                                          ),
                                                        ])));
                                          });
                                    },
                                    // color:
                                    //     isFavourite == true ? Colors.red : Colors.white,
                                    icon: item.isRequested!
                                        ? Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.ios_share_sharp,
                                            color: Color.fromARGB(
                                                255, 126, 213, 26),
                                          ),
                                  )
                                : Text(""),
                            Container(
                              // color: Colors.red,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,

                                    onPressed: () {
                                      item.toggleFavourite().then((_) {
                                        if (widget.favscreen == true) {
                                          widget.rebuildOverview();
                                        }
                                      }).catchError((value) {
                                        bool vali = value.toString() ==
                                            ('Exception: Timeout');
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: vali == false
                                              ? Text(
                                                  "Listing not active. Please Refresh.",
                                                )
                                              : Text("Server is unreachable"),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                              label: "Ok", onPressed: () {}),
                                        ));
                                      });
                                    },
                                    // color:
                                    //     isFavourite == true ? Colors.red : Colors.white,
                                    icon: item.isFavourite!
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_outline),
                                  ),
                                  // const SizedBox(width: 2),
                                  Text((item.likes).toString()),
                                ],
                              ),
                            ),

                            // IconView(
                            //   icon: Icons.favorite,
                            //   count: likes.toString(),
                            // ),
                            // IconView(
                            //   icon: Icons.ios_share_sharp,
                            //   count: "",
                            // ),
                            // Expanded(flex: 1,child: Container(child: Text(item.views.toString()))),
                            // Expanded(flex: 1,child: Container(child: Text(item.likes.toString()))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
