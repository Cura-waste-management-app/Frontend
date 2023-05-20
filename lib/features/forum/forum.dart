import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class Forum extends StatelessWidget {
  static const routeName = '/forum-screen';

  const Forum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ignore: avoid_unnecessary_containers
        body: Container(
          child: const Text('Forum'),
        ),
        bottomNavigationBar: BottomNavigation(
          index: 2,
        ));
  }
}
