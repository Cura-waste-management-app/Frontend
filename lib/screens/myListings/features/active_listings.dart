import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ListingRequests/mylist_item_detail_screen.dart';
import '../../Listings/models/listings.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class ActiveListings extends StatelessWidget {
  final Listing listing;
  const ActiveListings({required this.listing, super.key});

  void getUserName(context) async {
    String userName = ''; // to whom the listing has to be shared
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter name of the user'),
          content: TextField(
            onChanged: (value) {
              userName = value;
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Enter'),
              onPressed: () {
                Navigator.of(context).pop(userName);
              },
            ),
          ],
        );
      },
    );
    Provider.of<ListingsNotifier>(context, listen: false)
        .shareListing(listing.id, userName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 260,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.pending, color: Colors.blue),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(listing.status, style: const TextStyle(fontSize: 13)),
                    Text(
                        'Posted on ${DateFormat.yMEd().add_jms().format(listing.postTimeStamp)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]))
                  ],
                )
              ],
            ),
          ),
          Card(
              child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 6.0, bottom: 6.0, right: 6.0),
                child: Image.asset(listing.imagePath, width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 210,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(listing.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  MyListItemDetailScreen.routeName,
                                  arguments: listing.id,
                                );
                              },
                              child: Text(
                                "Requests (${listing.requests})",
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 62, 165, 249)),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Provider.of<ListingsNotifier>(
                                    context,
                                    listen: false)
                                .deleteListing(listing.id),
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/likes.png',
                                height: 16, width: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text('${listing.likes}'),
                            ),
                          ],
                        ),
                        Spacer(),
                        listing.status == "Active"
                            ? SizedBox(
                                height: 25,
                                width: 70,
                                child: ElevatedButton(
                                    onPressed: () {
                                      getUserName(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text('Share')),
                              )
                            : const Text(''),
                      ],
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
