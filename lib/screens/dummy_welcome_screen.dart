import 'package:cura_frontend/common/main_drawer.dart';
import 'package:flutter/material.dart';

class DummyWelcomeScreen extends StatelessWidget {
  // const DummyWelcomeScreen({super.key});
  static const routeName = '/welcome-screen-dummy';

  const DummyWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      endDrawer: MainDrawer(),
      body: const Center(
        child: Text("Dummy Welcome Screen. will be changed"),
      ),
    );
  }
}
