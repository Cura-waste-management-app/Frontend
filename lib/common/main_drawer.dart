// import '../../screens/my_requests_screen.dart';

import 'package:cura_frontend/common/error_screen.dart';
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
            child: Text(
              "Explore Cura",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
            ),
          ),
          SizedBox(height: 5),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.headphones_battery_sharp, size: iconSize),
            title: Text(
              "Welcome Dummy",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DummyWelcomeScreen.routeName);
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: Icon(Icons.home_rounded, size: iconSize),
            title: Text(
              "Home",
              style: TextStyle(fontSize: textFontSize),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HomeListings.routeName);
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
                  .pushReplacementNamed(FavouriteListingsScreen.routeName);
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
              Navigator.of(context)
                  .pushReplacementNamed(UserListings.routeName);
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
              Navigator.of(context)
                  .pushReplacementNamed(UserRequests.routeName);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.verified_user_sharp, size: 26),
          //   title: Text(
          //     "Profile",
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName);
          //   },
          // ),
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
