import 'package:flutter/material.dart';

class HomeListing extends StatelessWidget {
  const HomeListing({super.key});
  static const routeName = '/home-listing-screen';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: const Text("Hello World"),
      ),
    );
  }
}
