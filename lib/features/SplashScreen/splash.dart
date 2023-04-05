import 'dart:async';

import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/location/location.dart';
import 'package:cura_frontend/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final user = auth.currentUser;
        final uid = user!.uid;
        if (user != null) {
          print('SIGNED INNNNNNNN');
          Timer(const Duration(seconds: 3), (() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Location()));
          }));
        } else {
          print('NO USERRRRRRRRR');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AuthScreenPhone()));
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: const Text('Splash Screen'),
    ));
  }
}
