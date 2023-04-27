// ignore_for_file: use_build_context_synchronously

import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/conversation/chat_detail_page.dart';
import 'package:cura_frontend/features/conversation/conversation_page.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/screens/add_listing_arguments.dart';
import 'package:cura_frontend/screens/add_listing_screen.dart';
import 'package:cura_frontend/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../Listings/models/listings.dart';
import 'package:intl/intl.dart';

import '../../list_item_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class ActiveListings extends StatefulWidget {
  final String uid;
  final Listing listing;
  const ActiveListings({required this.uid, required this.listing, super.key});

  @override
  State<ActiveListings> createState() => _ActiveListingsState();
}

class _ActiveListingsState extends State<ActiveListings> {
  var deleteRequestLoading = false;
  var shareRequestLoading = false;

  Future<User?> _showListingRequests(BuildContext context, String title) async {
    return await showModalBottomSheet<User>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: getProportionateScreenHeight(400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(16)),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                widget.listing.requestedUsers!.isEmpty
                    ? const Text("No requests received!")
                    : Wrap(
                        spacing: getProportionateScreenHeight(20),
                        children: widget.listing.requestedUsers!
                            .map((item) => Container(
                                height: getProportionateScreenHeight(75),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(4),
                                    vertical: getProportionateScreenHeight(4)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(item);
                                  },
                                  child: Card(
                                    child: Row(children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<HomeListingsNotifier>(
                                                  context,
                                                  listen: false)
                                              .getUserInfo(item.id.toString())
                                              .then((_) {
                                            Navigator.of(context).pushNamed(
                                              OtherProfileScreen.routeName,
                                            );
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              getProportionateScreenWidth(5),
                                              getProportionateScreenHeight(4),
                                              getProportionateScreenWidth(10),
                                              getProportionateScreenHeight(5)),
                                          child: CircleAvatar(
                                            radius:
                                                getProportionateScreenHeight(
                                                    25),
                                            backgroundImage: NetworkImage(
                                                item.avatarURL ??
                                                    defaultNetworkImage),
                                          ),
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

  void deleteListing(context) async {
    setState(() {
      deleteRequestLoading = true;
    });

    var res = await Provider.of<ListingsNotifier>(context, listen: false)
        .deleteListing(widget.listing.id, widget.uid);

    setState(() {
      deleteRequestLoading = false;
    });

    if (res != "Listing deleted successfully!") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(text: "Oops, $res Please try again later!")
              .getSnackBar());
    }
  }

  void shareListing(context) async {
    User? user = await _showListingRequests(context, "Share with- ");
    if (user != null) {
      setState(() {
        shareRequestLoading = true;
      });

      var res = await Provider.of<ListingsNotifier>(context, listen: false)
          .shareListing(widget.listing.id, user.id, widget.uid);

      setState(() {
        shareRequestLoading = false;
      });
      if (res != "Listing shared!") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBarWidget(text: "Oops, $res Please try again later!")
                .getSnackBar());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(5),
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(10)),
      margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(10),
          top: getProportionateScreenHeight(5)),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenHeight(5)),
            child: Row(
              children: [
                const Icon(Icons.pending, color: Colors.blue),
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.listing.status,
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(14))),
                      Text(
                          'Posted on ${DateFormat.yMEd().add_jms().format(widget.listing.postTimeStamp.toLocal())}',
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(14),
                              color: Colors.grey[600]))
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ListItemDetailScreen.routeName, arguments: {
                'id': widget.listing.id,
                'path': 'mylistings',
              });
            },
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(2)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(3),
                        getProportionateScreenHeight(5),
                        getProportionateScreenWidth(6),
                        getProportionateScreenHeight(6)),
                    child: Image.network(widget.listing.imagePath,
                        width: getProportionateScreenWidth(100),
                        height: getProportionateScreenHeight(100)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(210),
                        height: getProportionateScreenHeight(73),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.listing.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            getProportionateScreenHeight(16))),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(
                                          getProportionateScreenWidth(50),
                                          getProportionateScreenHeight(32)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                  onPressed: () async {
                                    User? user = await _showListingRequests(
                                        context, "Select user to chat with - ");
                                    if (user != null) {
                                      var currentUserId =
                                          Provider.of<UserNotifier>(context,
                                                  listen: false)
                                              .currentUser!
                                              .id;
                                      var response = await post(Uri.parse(
                                          "$base_url/$addConversationPartnersAPI${user.id}/$currentUserId"));
                                      if (response.statusCode >= 200 &&
                                          response.statusCode <= 210) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ConversationPage(
                                            imageURL: user.avatarURL ??
                                                defaultNetworkImage,
                                            chatRecipientName: user.name,
                                            receiverID: user.id,
                                          );
                                        }));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBarWidget(
                                                    text:
                                                        'Unable to connect to the user. Try again letter')
                                                .getSnackBar());
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Requests(${widget.listing.requests})",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        color: const Color.fromARGB(
                                            255, 62, 165, 249)),
                                  ),
                                )
                              ],
                            ),
                            deleteRequestLoading
                                ? SizedBox(
                                    height: getProportionateScreenWidth(20),
                                    width: getProportionateScreenWidth(20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ))
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => deleteListing(context),
                                    icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(220),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/likes.png',
                                    height: getProportionateScreenHeight(16),
                                    width: getProportionateScreenWidth(16)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getProportionateScreenWidth(3)),
                                  child: Text('${widget.listing.likes}'),
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(3)),
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      await Navigator.of(context).pushNamed(
                                          AddListingScreen.routeName,
                                          arguments: AddListingArguments(
                                              uid: widget.uid,
                                              type: 'update',
                                              listing: widget.listing));
                                      Provider.of<ListingsNotifier>(context,
                                              listen: false)
                                          .getListings(widget.uid);
                                    },
                                    icon: Icon(Icons.edit,
                                        size: getProportionateScreenWidth(15)))
                              ],
                            ),
                            widget.listing.status == "Active"
                                ? shareRequestLoading
                                    ? SizedBox(
                                        height: getProportionateScreenWidth(20),
                                        width: getProportionateScreenWidth(20),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ))
                                    : SizedBox(
                                        height:
                                            getProportionateScreenHeight(25),
                                        width: getProportionateScreenWidth(75),
                                        child: ElevatedButton(
                                            onPressed: () =>
                                                shareListing(context),
                                            style: ElevatedButton.styleFrom(
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          15)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    getProportionateScreenWidth(
                                                        30)),
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
              ),
            )),
          ),
        ],
      ),
    );
  }
}
