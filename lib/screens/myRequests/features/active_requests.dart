import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/providers/requests_provider.dart';
import 'package:cura_frontend/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Listings/models/listings.dart';
import 'package:cura_frontend/screens/myRequests/features/receive_item.dart';

import '../../list_item_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class ActiveRequests extends StatefulWidget {
   final String uid;
  final Listing listing;
  const ActiveRequests({required this.uid, required this.listing, super.key});

  @override
  State<ActiveRequests> createState() => _ActiveRequestsState();
}

class _ActiveRequestsState extends State<ActiveRequests> {
  var deleteRequestLoading = false;

  void deleteRequest(context) async {
    setState(() {
      deleteRequestLoading = true;
    });

    var res = await Provider.of<RequestsNotifier>(context, listen: false)
        .deleteRequest(widget.listing.id, widget.uid);

    setState(() {
      deleteRequestLoading = false;
    });

    if (res != "Request deleted successfully!") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBarWidget(text: "Oops, $res Please try again later!")
              .getSnackBar());
    }
  }

  void receiveListing(context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ChangeNotifierProvider(
            create: (context) => RequestsNotifier(),
            child: ReceiveItem(listing: widget.listing, uid: widget.uid),
          );
        });
    // ignore: use_build_context_synchronously
    Provider.of<RequestsNotifier>(context, listen: false).getUserRequests(widget.uid);
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
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.pending, color: Colors.blue),
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(10)),
                  child: Text('Pending',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: getProportionateScreenHeight(14))),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ListItemDetailScreen.routeName,
                arguments: {
                  'id': widget.listing.id,
                  'path': 'myrequests',
                },
              );
            },
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(4)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(3),
                        getProportionateScreenHeight(5),
                        getProportionateScreenWidth(6),
                        getProportionateScreenHeight(5)),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            getProportionateScreenHeight(16))),
                                Text('Requests - ${widget.listing.requests}',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14)))
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
                                    onPressed: () => deleteRequest(context),
                                    icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(5),
                            bottom: getProportionateScreenHeight(10)),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<HomeListingsNotifier>(context,
                                      listen: false)
                                  .getUserInfo(
                                      widget.listing.owner.id.toString())
                                  .then((_) {
                                Navigator.of(context).pushNamed(
                                  OtherProfileScreen.routeName,
                                );
                              }).catchError((value) {
                                bool vali =
                                    value.toString() == ('Exception: Timeout');
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: vali == false
                                      ? const Text(
                                          "Could not fetch user details",
                                        )
                                      : const Text("Server is unreachable!"),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                      label: "Ok", onPressed: () {}),
                                ));
                              });
                              ;
                            },
                            child: CircleAvatar(
                              minRadius: getProportionateScreenWidth(14),
                              backgroundImage:
                                  NetworkImage(widget.listing.owner.avatarURL != ""?
                                   widget.listing.owner.avatarURL!: 
                                   defaultNetworkImage),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(5)),
                            child: Text(widget.listing.owner.name),
                          )
                        ]),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(220),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/likes.png',
                                      height: getProportionateScreenHeight(16),
                                      width: getProportionateScreenWidth(16)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(3)),
                                    child: Text('${widget.listing.likes}'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(25),
                              width: getProportionateScreenWidth(95),
                              child: ElevatedButton(
                                  onPressed: () => receiveListing(context),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(15)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          getProportionateScreenWidth(30)),
                                    ),
                                  ),
                                  child: const Text('Received')),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
