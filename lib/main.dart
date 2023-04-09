import 'package:cura_frontend/features/SplashScreen/splash.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/auth/controllers/auth_controller.dart';
import 'package:cura_frontend/features/community/community_home.dart';
import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:cura_frontend/features/community/join_community.dart';
import 'dart:ui';

import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/home/home_listing.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';

import 'package:cura_frontend/screens/dummy_welcome_screen.dart';
import 'package:cura_frontend/screens/userDetails/user_details.dart';
import './screens/homeListings/home_listings.dart';
import './screens/homeListings/favourite_listings_screen.dart';

import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/screens/myListings/user_listings.dart';
import 'package:cura_frontend/screens/myRequests/user_requests.dart';
import './screens/list_item_detail_screen.dart';

import 'package:cura_frontend/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rpd;
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/providers/requests_provider.dart';
import './features/profile/screens/view_profile.dart';
import './features/profile/screens/my_profile.dart';
import './features/profile/screens/edit_profile.dart';
import './screens/other_profile_screen.dart';
import './screens/add_listing_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
  runApp(const rpd.ProviderScope(child: MyApp()));
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => HomeListingsNotifier()),
      ],
      child: MaterialApp(
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
        home: HomeListings(),
        routes: {
          HomeListings.routeName: (ctx) => HomeListings(),
          FavouriteListingsScreen.routeName: (ctx) => FavouriteListingsScreen(),
          ListItemDetailScreen.routeName: (ctx) => ListItemDetailScreen(),
          ViewProfile.routeName: (ctx) => ViewProfile(),
          OtherProfileScreen.routeName: (ctx) => OtherProfileScreen(),
          AddListingScreen.routeName: (ctx) => AddListingScreen(),
        },
        onGenerateRoute: ((settings) => generateRoute(settings)),
      ),
    );
  }
}

// This widget is the root of your application.
