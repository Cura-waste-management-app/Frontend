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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color.fromARGB(255, 218, 185, 88),
            alignment: Alignment.centerLeft,
            child: Text(
              "Explore Cura",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.headphones_battery_sharp, size: 26),
            title: Text(
              "Welcome Dummy",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DummyWelcomeScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.home_rounded, size: 26),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HomeListings.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, size: 26),
            title: Text(
              "Favourites",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FavouriteListingsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.list, size: 26),
            title: Text(
              "My Listings",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserListings.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.group_add, size: 26),
            title: Text(
              "My Requests",
              style: TextStyle(fontSize: 20),
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