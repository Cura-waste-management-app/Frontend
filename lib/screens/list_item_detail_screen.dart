import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/screens/Listings/models/listings.dart';

// import './home_listings_screen.dart';
// import './other_profile_screen.dart';

// import '../providers/listed_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './other_profile_screen.dart';
// import '../models/display_item.dart';
import 'package:intl/intl.dart';

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
    print(path);
    print(itemId);
    // final itemId = ModalRoute.of(context)!.settings.arguments as String;
    Listing item = (path == 'home')
        ? Provider.of<HomeListingsNotifier>(context, listen: false)
            .findById(itemId)
        : (path == 'mylistings')
            ? Provider.of<HomeListingsNotifier>(context, listen: false)
                .myItemsFindById(itemId)
            : Provider.of<HomeListingsNotifier>(context, listen: false)
                .myRequestsFindById(itemId);

    print("kaisa hua");
    bool isFavourite = true;
    bool isRequested = false;
    if (path == 'home') {
      isFavourite = item.isFavourite!;
      isRequested = item.isRequested!;
    }

    // item = Provider.of<DisplayItem>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                                  ? Text(
                                      "Listing not active. Please Refresh",
                                    )
                                  : Text("Server is unreachable!"),
                              duration: const Duration(seconds: 2),
                              action:
                                  SnackBarAction(label: "Ok", onPressed: () {}),
                            ));
                          });
                        }
                      },
                      icon: isFavourite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_outline,
                            ),
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
                                    print("no error");

                                    print("no errr");
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
                                          ? Text(
                                              "Could not fetch user details",
                                            )
                                          : Text("Server is unreachable"),
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
                                                ? AssetImage(
                                                    'assets/images/female_user.png',
                                                  )
                                                : NetworkImage(
                                                    item.owner.avatarURL!,
                                                  ) as ImageProvider,
                                        maxRadius: 25,
                                      ),
                              ),
                              Positioned(
                                top: 52,
                                left: 2,
                                child: Container(
                                  // width: 30,
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: [
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
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time),
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.access_time),
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
                        item.description!.length > 0
                            ? item.description!
                            : "No Description available!",
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
                                        ? Text(
                                            "Listing not active. Please Refresh",
                                          )
                                        : Text("Server is unreachable!"),
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
                                  : Text(
                                      'Cancel Request',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            )
                          : Text(""),
                    )
                  : Center(
                      child: Text(""),
                    ),
            ],
          ),
        ));
  }
}
