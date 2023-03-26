// import 'package:curafrontend/screens/other_profile_screen.dart';

// import '../../screens/list_item_detail_screen.dart';

// import '../../common/error_screen.dart';
import './icon_view.dart';

import '../../Listings/models/listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListingItem extends StatelessWidget {
  // const ListingItem({super.key});

  // var isFavourite = false;

  final Listing listing;

  ListingItem({required this.listing});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // final item = Provider.of<DisplayItem>(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        // Navigator.of(context).pushNamed(
                        //   ListItemDetailScreen.routeName,
                        //   arguments: item.id,
                        // );
                      },
                      child: Image.network(
                        listing.imagePath,
                        fit: BoxFit.cover,
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
                                  listing.title,
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
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black54,
                                ),
                                child: Text(
                                  "Posted on ${DateFormat.yMEd().add_jms().format(listing.postTimeStamp)}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            // Text("H")
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
                            listing.status != "Shared" &&
                                    listing.status != "Cancelled"
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
                                                title: listing.isRequested!
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
                                                              // item
                                                              //     .toggleRequest()
                                                              //     .then((_) {
                                                              //   Navigator.of(
                                                              //           ctx)
                                                              //       .pop();
                                                              //   if (reqscreen ==
                                                              //       true) {
                                                              //     rebuildOverview();
                                                              //   }
                                                              // });

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
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
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
                                    icon: listing.isRequested!
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
                                      // item.toggleFavourite().then((_) {
                                      //   if (favscreen == true) {
                                      //     rebuildOverview();
                                      //   }
                                      // });
                                    },
                                    // color:
                                    //     isFavourite == true ? Colors.red : Colors.white,
                                    icon: listing.isFavourite!
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_outline),
                                  ),
                                  // const SizedBox(width: 2),
                                  Text((listing.likes).toString()),
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
