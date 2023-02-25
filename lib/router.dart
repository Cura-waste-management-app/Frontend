import 'package:cura_frontend/features/ItemDetails/item_detail.dart';
import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/community/join_community.dart';

import 'package:cura_frontend/features/forum/forum.dart';
import 'package:cura_frontend/features/home/home_listing.dart';
import 'package:cura_frontend/features/location/location.dart';
import 'package:cura_frontend/providers/chat_provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';

import 'package:cura_frontend/screens/myListings/user_listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/error_screen.dart';
import 'features/SplashScreen/splash.dart';
import 'features/conversation/chat_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AddListing.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return AddListing();
      });

    case (HomeListing.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return HomeListing();
      });

    case (JoinCommunity.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const JoinCommunity();
      });

    case (Location.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const Location();
      });

    case UserListings.routeName:
      return MaterialPageRoute(builder: (ctx) {
       return ChangeNotifierProvider(
      create: (context) => ListingsNotifier(),
      child: UserListings(),
    );
      });


    // case ItemDetail.routeName:
    //   return MaterialPageRoute(builder: (ctx) {
    //     return const ItemDetail(displayItem: i,);
    //   });

    case (AuthScreenOtp.routeName):
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (ctx) => AuthScreenOtp(verificationId: verificationId),
      );

    case (AuthScreenPhone.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const AuthScreenPhone();
      });

    case (ChatPage.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const ChatPage();
      });
    case (SplashScreen.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const SplashScreen();
      });

    default:
      return MaterialPageRoute(builder: (ctx) {
        return const ErrorScreen(error: "This page doesn't exist");
      });
  }
}
