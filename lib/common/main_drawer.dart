// import '../../screens/my_requests_screen.dart';

import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/features/profile/screens/my_profile.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:provider/provider.dart';
import 'package:cura_frontend/screens/homeListings/favourite_listings_screen.dart';

import '../screens/myListings/user_listings.dart';
import '../screens/myRequests/user_requests.dart';
import '../screens/dummy_welcome_screen.dart';

// import '../../common/error_screen.dart';

import '../screens/homeListings/home_listings.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  // const MainDrawer({super.key});
  final double textFontSize = 18;
  final double iconSize = 22;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
            width: double.infinity,
            padding: EdgeInsets.only(top: 30, left: 20, bottom: 8),
            color: Color.fromARGB(255, 225, 225, 225),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Explore Cura",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
            ),
          ),
          SizedBox(height: 5),
          // ListTile(
          //   minLeadingWidth: 25,
          //   leading: Icon(Icons.headphones_battery_sharp, size: iconSize),
          //   title: Text(
          //     "Welcome Dummy",
          //     style: TextStyle(fontSize: textFontSize),
          //   ),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(DummyWelcomeScreen.routeName);
          //   },
          // ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.home_rounded, size: iconSize),
            title: Text(
              "Home",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(HomeListings.routeName);
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.favorite, size: iconSize),
            title: Text(
              "Favourites",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(FavouriteListingsScreen.routeName);
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.list, size: iconSize),
            title: Text(
              "My Listings",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Provider.of<HomeListingsNotifier>(context, listen: false)
                  .fetchListings()
                  .then((_) {
                Navigator.of(context).pushNamed(UserListings.routeName);
              }).catchError((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    "Could not fetch user listings.",
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(label: "Ok", onPressed: () {}),
                ));
              });
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.group_add, size: iconSize),
            title: Text(
              "My Requests",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Provider.of<HomeListingsNotifier>(context, listen: false)
                  .fetchRequests()
                  .then((_) {
                Navigator.of(context).pushNamed(UserRequests.routeName);
              }).catchError((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    "Could not fetch user requests.",
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(label: "Ok", onPressed: () {}),
                ));
              });
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.person, size: iconSize),
            title: Text(
              "My Profile",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Provider.of<HomeListingsNotifier>(context, listen: false)
                  .fetchMyProfile()
                  .then((_) {
                Navigator.of(context).pushNamed(MyProfile.routeName);
              }).catchError((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    "Could not fetch user details.",
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(label: "Ok", onPressed: () {}),
                ));
              });
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.logout, size: iconSize),
            title: Text(
              "Logout",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.person, size: 26),
          //   title: Text(
          //     "Account",
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName);
          //   },
          // ),
        ],
      ),
    );
  }
}
