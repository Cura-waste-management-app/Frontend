import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/screens/Listings/models/listings.dart';
// import '../providers/listed_items.dart';
import 'package:flutter/material.dart';
// import '../models/display_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import './other_profile_screen.dart';
import '../../common/debug_print.dart';
import '../constants.dart';

class ListItemDetailScreen extends StatefulWidget {
  // const ListItemScreen({super.key});
  static const routeName = '/list-item-detail';

  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final itemId = routeArgs['id']!;
    final path = routeArgs['path']!;
    prints(path);
    prints(itemId);
    // final itemId = ModalRoute.of(context)!.settings.arguments as String;
    Listing item = (path == 'home')
        ? Provider.of<HomeListingsNotifier>(context, listen: false)
            .findById(itemId)
        : (path == 'mylistings')
            ? Provider.of<HomeListingsNotifier>(context, listen: false)
                .myItemsFindById(itemId)
            : Provider.of<HomeListingsNotifier>(context, listen: false)
                .myRequestsFindById(itemId);

    bool isFavourite = true;
    bool isRequested = false;
    if (path == 'home') {
      isFavourite = item.isFavourite!;
      isRequested = item.isRequested!;
    }
    if (item.owner.avatarURL == null) {
      prints("NULL");
    } else {
      prints("NOT NULL");
    }

    // item = Provider.of<DisplayItem>(context);

    double screenWidth = 100.w;
    double screenHeight = 100.h;
    //DisplayItem item = routeArgs!=null? routeArgs== null
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
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
              SizedBox(
                height: 300,
                width: screenWidth,
                child: Image.network(
                  item.imagePath,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 26,
                      onPressed: () {
                        if (path == 'home') {
                          Provider.of<HomeListingsNotifier>(context,
                                  listen: false)
                              .findByIdAndToggleFavourite(itemId)
                              .then((_) {
                            setState(() {
                              isFavourite = !isFavourite;
                            });
                          }).catchError((value) {
                            bool vali =
                                value.toString() == ('Exception: Timeout');
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: vali == false
                                  ? const Text(
                                      "Listing not active. Please Refresh",
                                    )
                                  : const Text("Server is unreachable!"),
                              duration: const Duration(seconds: 2),
                              action:
                                  SnackBarAction(label: "Ok", onPressed: () {}),
                            ));
                          });
                        }
                      },
                      icon: isFavourite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                            ),
                    ),
                    Text(
                      item.likes.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              path == 'home' || path == 'myrequests'
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 5.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Provider.of<HomeListingsNotifier>(context,
                                          listen: false)
                                      .getUserInfo(item.owner.id.toString())
                                      .then((_) {
                                    prints("no error");

                                    prints("no errr");
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.of(context).pushNamed(
                                      OtherProfileScreen.routeName,
                                    );
                                  }).catchError((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    bool vali = value.toString() ==
                                        ('Exception: Timeout');
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: vali == false
                                          ? const Text(
                                              "Could not fetch user details",
                                            )
                                          : const Text("Server is unreachable"),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                          label: "Ok", onPressed: () {}),
                                    ));
                                  });
                                },
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          item.owner.avatarURL != null &&
                                                  item.owner.avatarURL != ""
                                              ? item.owner.avatarURL!
                                              : defaultNetworkImage,
                                        ),
                                        maxRadius: 25,
                                      ),
                              ),
                              Positioned(
                                top: 52,
                                left: 2,
                                child: Container(
                                  // width: 30,
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: const [
                                      // Icon(
                                      //   Icons.star,
                                      //   color: Colors.white,
                                      //   size: 19,
                                      // ),
                                      // Text(
                                      //   "4.0",
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   width: 3,
                              //   height: 5,
                              // ),
                              Text("${item.owner.name} is giving away"),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.access_time),
                                  Text(
                                      'Posted on ${DateFormat.yMEd().add_jms().format(item.postTimeStamp.toLocal())}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600])),
                                  // Text(
                                  //   DateFormat('dd/MM/yyyy hh:mm:ss')
                                  //       .format(item.postTimeStamp.toLocal()),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 5.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.access_time),
                              Text(
                                  'Posted on ${DateFormat.yMEd().add_jms().format(item.postTimeStamp.toLocal())}',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600])),
                              // Text(
                              //   DateFormat('dd/MM/yyyy hh:mm:ss')
                              //       .format(item.postTimeStamp.toLocal()),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 10,
                  right: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item.description!.isNotEmpty
                            ? item.description!
                            : "No Description available!",
                        style: const TextStyle(fontSize: 18),
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
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Text(
                      //   "Pick-up Time",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 19,
                      //   ),
                      // ),
                      // Text(
                      //   "Any day after 4 pm",
                      //   style: TextStyle(fontSize: 14),
                      // )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              path == 'home'
                  ? Center(
                      child: item.status != "Shared" &&
                              item.status != "Cancelled"
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 10.0,
                                  backgroundColor: Colors.black,
                                  minimumSize: Size(screenWidth / 1.2, 50)),
                              onPressed: () {
                                Provider.of<HomeListingsNotifier>(context,
                                        listen: false)
                                    .findByIdAndToggleRequest(itemId)
                                    .then((_) {
                                  setState(() {
                                    isRequested = !isRequested;
                                  });
                                }).catchError((value) {
                                  bool vali = value.toString() ==
                                      ('Exception: Timeout');
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: vali == false
                                        ? const Text(
                                            "Listing not active. Please Refresh",
                                          )
                                        : const Text("Server is unreachable!"),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                        label: "Ok", onPressed: () {}),
                                  ));
                                });
                              },
                              child: isRequested == false
                                  ? const Text(
                                      'Request This',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : const Text(
                                      'Cancel Request',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            )
                          : const Text(""),
                    )
                  : const Center(
                      child: Text(""),
                    ),
            ],
          ),
        ));
  }
}
