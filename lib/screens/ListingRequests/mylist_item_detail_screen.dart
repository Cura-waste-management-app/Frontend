import './features/mylisting_item_request.dart';

import '../ProfileScreen/other_profile_screen.dart';

import '../Listings/models/listings.dart';

import '../../providers/listings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyListItemDetailScreen extends StatefulWidget {
  // const ListItemScreen({super.key});
  static const routeName = '/mylist-item-detail';

  @override
  State<MyListItemDetailScreen> createState() => _MyListItemDetailScreenState();
}

class _MyListItemDetailScreenState extends State<MyListItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as String;
    Listing item =
        Provider.of<ListingsNotifier>(context).myItemsFindById(itemId);

    // bool isFavourite = item.isFavourite;
    // bool isRequested = item.isRequested;
    // item = Provider.of<DisplayItem>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // print(item.requestedUsers[0]);
    //DisplayItem item = routeArgs!=null? routeArgs== null
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          item.title,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: screenWidth,
              child: Image.network(
                item.imagePath,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text(
                    item.likes.toString(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 10,
                right: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      item.description!,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Container(
                // color: Colors.black54,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pick-up Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      "Any day after 4 pm",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Requests received (${item.requests})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    item.requests != 0
                        ? SizedBox(
                            height: 170,
                            child: ListView.builder(
                              itemCount: item.requests,
                              itemBuilder: (ctx, i) => MyListingItemRequest(
                                userID: item.requestedUsers![i],
                                objectID: item.id,
                                
                              ),
                            ),
                          )
                        : Text(""),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}