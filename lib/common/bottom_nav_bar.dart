import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return const GNav(
      tabs: [
        GButton(icon: Icons.home),
        GButton(icon: Icons.favorite),
        GButton(icon: Icons.forum),
        GButton(icon: Icons.location_on_outlined),
        GButton(icon: Icons.email_outlined)
      ],
    );
  }
}
