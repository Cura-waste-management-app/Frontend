import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listings.dart';

// ignore: use_key_in_widget_constructors
class ActiveListings extends StatelessWidget {
  final Listing listing;
  const ActiveListings({required this.listing, super.key});

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
            width: 170,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.blue),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(listing.status, style: const TextStyle(fontSize: 13)),
                    Text('Posted on ${listing.postDate}',
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
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 6.0),
                        child: Image.asset(listing.imgURL,
                            width: 100, height: 100),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(listing.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 30,
                                  child: IconButton(
                                      onPressed: () =>
                                     Provider.of<ListingsNotifier>(context, listen: false).deleteListing(listing.id) ,
                                      icon: const Icon(Icons.delete)),
                                )
                              ],
                            ),
                          ),
                          Text('Requests - ${listing.requests}',
                              style: const TextStyle(fontSize: 13)),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/images/views.png',
                                        height: 16, width: 16),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text('${listing.views}'),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/likes.png',
                                          height: 16, width: 16),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Text('${listing.likes}'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  width: 70,
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          Provider.of<ListingsNotifier>(context, listen: false).shareListing(listing.id) ,
                                      style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Share')),
                                ),
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
