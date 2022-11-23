
import 'package:cura_frontend/features/forum/forum.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../features/conversation/chatPage.dart';

// ignore: must_be_immutable
class BottomNavigation extends StatefulWidget {
  int index = 0;
  BottomNavigation({super.key, required this.index});
   int getIndex(){
     return index;
   }

  @override
  // ignore: no_logic_in_create_state
  State<BottomNavigation> createState() => _BottomNavigationState(index: index);
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;
  _BottomNavigationState({required this.index});
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
                  Navigator.pushNamed(context, ChatPage.routeName);
                })
          ],
        ),
      ),
    );
  }
}
