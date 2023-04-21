// ignore_for_file: use_build_context_synchronously

import 'package:cura_frontend/features/conversation/chat_detail_page.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/screens/add_listing_arguments.dart';
import 'package:cura_frontend/screens/add_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../Listings/models/listings.dart';
import 'package:intl/intl.dart';

import '../../list_item_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class ActiveListings extends StatelessWidget {
  final Listing listing;
  const ActiveListings({required this.listing, super.key});

  Future<User?> _showListingRequests(BuildContext context, String title) async {
    return await showModalBottomSheet<User>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                listing.requestedUsers!.isEmpty
                    ? const Text("No requests received!")
                    : Wrap(
                        spacing: 20.0,
                        children: listing.requestedUsers!
                            .map((item) => Container(
                                height: 70,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(item);
                                  },
                                  child: Card(
                                    child: Row(children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 5, 10, 5),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(item.avatarURL!),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(item.name),
                                          Text('Points - ${item.points}')
                                        ],
                                      ),
                                    ]),
                                  ),
                                )))
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
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
                        'Posted on ${DateFormat.yMEd().add_jms().format(listing.postTimeStamp.toLocal())}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]))
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ListItemDetailScreen.routeName, arguments: {
                'id': listing.id,
                'path': 'mylistings',
              });
            },
            child: Card(
                child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0, bottom: 6.0, right: 6.0),
                  child:
                      Image.network(listing.imagePath, width: 100, height: 100),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerLeft),
                                onPressed: () async {
                                  User? user = await _showListingRequests(
                                      context, "Select user to chat with - ");
                                  if (user != null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChatDetailPage(
                                        imageURL: user.avatarURL!,
                                        chatRecipientName: user.name,
                                        receiverID: user.id,
                                      );
                                    }));
                                  }
                                },
                                child: Text(
                                  "Requests(${listing.requests})",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 62, 165, 249)),
                                ),
                              )
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
                      width: 220,
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
                              IconButton(
                                  padding: const EdgeInsets.only(left: 3),
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    await Navigator.of(context).pushNamed(
                                        AddListingScreen.routeName,
                                        arguments: AddListingArguments(
                                            type: 'update', listing: listing));
                                    Provider.of<ListingsNotifier>(context,
                                            listen: false)
                                        .getListings();
                                  },
                                  icon: const Icon(Icons.edit, size: 15))
                            ],
                          ),
                          Spacer(),
                          listing.status == "Active"
                              ? SizedBox(
                                  height: 25,
                                  width: 70,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        User? user = await _showListingRequests(
                                            context, "Share with- ");
                                        Provider.of<ListingsNotifier>(context,
                                                listen: false)
                                            .shareListing(listing.id, user!.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
            )),
          )
        ],
      ),
    );
  }
}
