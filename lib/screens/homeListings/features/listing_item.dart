// import 'package:curafrontend/screens/other_profile_screen.dart';

// import '../../screens/list_item_detail_screen.dart';

// import '../../common/error_screen.dart';
import './icon_view.dart';

import '../../Listings/models/listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_listings_provider.dart';
import 'package:intl/intl.dart';
import '../../../screens/list_item_detail_screen.dart';
import '../../other_profile_screen.dart';

class ListingItem extends StatelessWidget {
  // const ListingItem({super.key});

  // var isFavourite = false;
  final bool favscreen;
  final bool reqscreen;
  Function rebuildOverview;

  ListingItem(
      {required this.favscreen,
      required this.rebuildOverview,
      required this.reqscreen});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final item = Provider.of<Listing>(context);
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
          reqscreen
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
                          arguments: item.id,
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
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black54,
                                ),
                                child: Text(
                                  '2 days ago',
                                  // 'Posted on ${DateFormat.yMd().format(item.postTimeStamp)}',
                                  style: TextStyle(color: Colors.white),
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
                                  Navigator.of(context).pushNamed(
                                      OtherProfileScreen.routeName,
                                      arguments: {
                                        'owner': item.owner.name,
                                        'userImageURL': item.owner.avatarURL!,

                                        // 'rating': item.rating.toString(),
                                      });
                                },
                                child: CircleAvatar(
                                  backgroundImage: item.owner.avatarURL == null
                                      ? AssetImage(
                                          'assets/images/female_user.png',
                                        )
                                      : AssetImage(
                                          item.owner.avatarURL!,
                                        ),
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
                              count: "3 km away",
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
                                                                if (reqscreen ==
                                                                    true) {
                                                                  rebuildOverview();
                                                                }
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
                                        if (favscreen == true) {
                                          rebuildOverview();
                                        }
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
