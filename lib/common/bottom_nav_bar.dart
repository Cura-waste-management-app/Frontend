import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../features/conversation/conversation_list_page.dart';
import '../screens/homeListings/home_listings.dart';

// ignore: must_be_immutable
class BottomNavigation extends StatefulWidget {
  int index = 0;
  BottomNavigation({super.key, required this.index});
  int getIndex() {
    return index;
  }

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
          selectedIndex: widget.index,
          onTabChange: (index) => setState(() => widget.index = index),
          tabs: [
            GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  widget.index = 0;
                  if (ModalRoute.of(context)?.settings.name ==
                      HomeListings.routeName) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, HomeListings.routeName);
                }),
            GButton(
              icon: Icons.forum,
              text: 'Community',
              onPressed: () {
                widget.index = 1;

                if (ModalRoute.of(context)?.settings.name ==
                    JoinedCommunityPage.routeName) {
                  Navigator.pop(context);
                }
                Navigator.pushNamed(context, JoinedCommunityPage.routeName);
              },
            ),
            GButton(
                icon: Icons.email_outlined,
                text: 'Chat',
                onPressed: () {
                  const String targetRoute = ConversationListPage.routeName;

// Check if the target route is already at the top of the stack
                  widget.index = 2;
                  // prints(
                  //     'Model route on top: ${ModalRoute.of(context)?.settings.name} ');
                  if (ModalRoute.of(context)?.settings.name ==
                      ConversationListPage.routeName) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, ConversationListPage.routeName);
                })
          ],
        ),
      ),
    );
  }
}
