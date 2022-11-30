import 'dart:ui';



import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/home/home_listing.dart';

import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/screens/myListings/user_listings.dart';


import 'package:cura_frontend/router.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import './features/profile/screens/view_profile.dart';
import './features/profile/screens/my_profile.dart';
import './features/profile/screens/edit_profile.dart';

Future<void> main() async {
  runApp(const MyApp());
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.

          ),
      home: HomeListing(),
      routes: {
        ViewProfile.routeName: (ctx)=>ViewProfile(),
      },
      onGenerateRoute: ((settings) => generateRoute(settings)),
    );
  }
}
