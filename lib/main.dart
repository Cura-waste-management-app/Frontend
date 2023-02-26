import 'package:cura_frontend/features/SplashScreen/splash.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/auth/controllers/auth_controller.dart';
import 'package:cura_frontend/features/community/community_home.dart';
import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:cura_frontend/features/community/join_community.dart';

import 'package:cura_frontend/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/community/community_router.dart';
import 'features/home/home_listing.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import './features/profile/screens/view_profile.dart';
import 'models/community.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  ); // DartPluginRegistrant.ensureInitialized();
// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
      home: CommunityRouter(),

      // routes: {
      //   SplashScreen.routeName: (context) => const SplashScreen(),
      //   AuthScreenPhone.routeName: (context) => const AuthScreenPhone(),
      //   AuthScreenOtp.routeName: (context) => const AuthScreenOtp(),
      //   ViewProfile.routeName: (ctx) => ViewProfile(),
      // },
      onGenerateRoute: ((settings) => generateRoute(settings)),
    );
  }
}

// This widget is the root of your application.
