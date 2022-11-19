import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/forum/forum.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class BottomNavigation extends StatefulWidget {
 int index = 0;
  BottomNavigation({super.key, required this.index});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;
  

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),

      // ignore: avoid_unnecessary_containers
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: GNav(
          gap: 8,
          tabMargin: const EdgeInsets.all(10),
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
          selectedIndex: index,
          onTabChange: (index) => setState(() => this.index = index),

          
          tabs: [
            const GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            const GButton(
              icon: Icons.favorite,
              text: 'Volunteer',
            ),
            GButton(
              icon: Icons.forum,
              text: 'Forum',
              onPressed: () {
                Navigator.pushNamed(context, Forum.routeName);
              
              },
              
            ),
            GButton(
                icon: Icons.email_outlined,
                text: 'Chat',
                onPressed: () {
                  Navigator.pushNamed(context, AddListing.routeName);
                })
          ],
        ),
      ),
    );
  }
}
