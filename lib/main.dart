import 'dart:ui';

import 'package:cura_frontend/features/SplashScreen/splash.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:cura_frontend/providers/auth.dart';
import 'package:cura_frontend/providers/bottom_nav_bar_provider.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/providers/user_provider.dart';
import 'package:cura_frontend/router.dart';
import 'package:cura_frontend/screens/help_support_screen.dart';
import 'package:cura_frontend/screens/privacy_policy_screen.dart';
import 'package:cura_frontend/screens/userDetails/update_user_details.dart';
import 'package:cura_frontend/screens/userDetails/user_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rpd;
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart' as pwd;
import 'package:sizer/sizer.dart';

import './features/profile/screens/my_profile.dart';
import './screens/add_listing_screen.dart';
import './screens/homeListings/favourite_listings_screen.dart';
import './screens/homeListings/home_listings.dart';
import './screens/list_item_detail_screen.dart';
import './screens/other_profile_screen.dart';
import 'common/check_internet_connection.dart';
import 'features/conversation/conversation_list_page.dart';
import 'firebase_options.dart';
import 'models/messages.g.dart';
import 'models/user_conversation.dart';

Future<void> main() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(ConversationAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(UserConversationAdapter());
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(rpd.ProviderScope(child: MyApp()));
}

class MyApp extends rpd.ConsumerWidget {
  MyApp({super.key});
  final container = rpd.ProviderContainer();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    return pwd.MultiProvider(
      providers: [
        pwd.ChangeNotifierProvider(create: (ctx) => HomeListingsNotifier()),
        pwd.ChangeNotifierProvider(create: (ctx) => Auth()),
        pwd.ChangeNotifierProvider(create: (ctx) => BottomNavBarProvider()),
        pwd.ChangeNotifierProvider(
          create: (ctx) => UserNotifier(),
        )
      ],
      child: CheckInternetConnection(
          child: Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          useInheritedMediaQuery: true,
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
          home: const SplashScreen(),
          routes: {
            HomeListings.routeName: (ctx) => HomeListings(),
            ConversationListPage.routeName: (ctx) => ConversationListPage(),
            JoinedCommunityPage.routeName: (ctx) => JoinedCommunityPage(),
            FavouriteListingsScreen.routeName: (ctx) =>
                FavouriteListingsScreen(),
            ListItemDetailScreen.routeName: (ctx) => ListItemDetailScreen(),
            AuthScreenPhone.routeName: (ctx) => const AuthScreenPhone(),
            MyProfile.routeName: (ctx) => MyProfile(),
            UpdateUserDetails.routeName: (ctx) => UpdateUserDetails(),
            PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
            HelpSupportScreen.routeName: (ctx) => HelpSupportScreen(),
            // ViewProfile.routeName: (ctx) => ViewProfile(),
            OtherProfileScreen.routeName: (ctx) => OtherProfileScreen(),
            AddListingScreen.routeName: (ctx) => AddListingScreen(),
            UserDetails.routeName: (ctx) => const UserDetails(),
          },
          onGenerateRoute: ((settings) => generateRoute(settings)),
        );
      })),
    );
  }
}

// This widget is the root of your application.
