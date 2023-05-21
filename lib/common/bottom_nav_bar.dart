import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../features/conversation/conversation_list_page.dart';
import '../screens/homeListings/home_listings.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  RxInt index = 0.obs;

  void setIndex(int newIndex) {
    index.value = newIndex;
  }
}

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
  final BottomNavigationController controller =
      Get.put(BottomNavigationController());
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Obx(() => Padding(
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
              selectedIndex: controller.index.value,
              onTabChange: (index) => controller.setIndex(index),
              tabs: [
                GButton(
                    icon: Icons.home,
                    text: 'Home',
                    onPressed: () {
                      if (ModalRoute.of(context)?.settings.name ==
                          HomeListings.routeName) {
                        Navigator.pop(context);
                      }
                      Get.toNamed(HomeListings.routeName);
                      // Navigator.pushNamed(context, HomeListings.routeName);
                    }),
                GButton(
                  icon: Icons.forum,
                  text: 'Community',
                  onPressed: () {
                    if (ModalRoute.of(context)?.settings.name ==
                        JoinedCommunityPage.routeName) {
                      Navigator.pop(context);
                    }
                    Get.toNamed(JoinedCommunityPage.routeName);
                    // Navigator.pushNamed(context, JoinedCommunityPage.routeName);
                  },
                ),
                GButton(
                    icon: Icons.email_outlined,
                    text: 'Chat',
                    onPressed: () {
                      const String targetRoute = ConversationListPage.routeName;

                      if (ModalRoute.of(context)?.settings.name ==
                          ConversationListPage.routeName) {
                        Navigator.pop(context);
                      }
                      Get.toNamed(ConversationListPage.routeName);
                      // Navigator.pushNamed(context, ConversationListPage.routeName);
                    })
              ],
            ),
          ),
        ));
  }
}
