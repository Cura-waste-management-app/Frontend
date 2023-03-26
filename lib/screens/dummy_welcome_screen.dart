import 'package:cura_frontend/common/main_drawer.dart';
import 'package:flutter/material.dart';

class DummyWelcomeScreen extends StatelessWidget {
  // const DummyWelcomeScreen({super.key});
  static const routeName = '/welcome-screen-dummy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      endDrawer: MainDrawer(),
      body: Center(
        child: Text("Dummy Welcome Screen. will be changed"),
      ),
    );
  }
}
