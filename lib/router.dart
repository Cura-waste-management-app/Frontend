import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/community/explore_community.dart';
import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:cura_frontend/features/location/location.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/providers/listings_provider.dart';
import 'package:cura_frontend/providers/requests_provider.dart';
import 'package:cura_frontend/providers/user_provider.dart';
import 'package:cura_frontend/screens/dummy_welcome_screen.dart';
import 'package:cura_frontend/screens/homeListings/favourite_listings_screen.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:cura_frontend/screens/list_item_detail_screen.dart';
import 'package:cura_frontend/screens/myListings/user_listings.dart';
import 'package:cura_frontend/screens/myRequests/user_requests.dart';
import 'package:cura_frontend/screens/userDetails/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/error_screen.dart';
import 'features/SplashScreen/splash.dart';
import 'features/community/community_home.dart';
import 'features/conversation/conversation_list_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ListItemDetailScreen.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return ChangeNotifierProvider(
          create: (context) => HomeListingsNotifier(),
          child: ListItemDetailScreen(),
        );
      });

    case DummyWelcomeScreen.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return DummyWelcomeScreen();
      });
    case (ExploreCommunity.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const ExploreCommunity();
      });

    case (Location.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const Location();
      });
    case HomeListings.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return ChangeNotifierProvider(
          create: (context) => HomeListingsNotifier(),
          child: HomeListings(),
        );
      });

    case FavouriteListingsScreen.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return ChangeNotifierProvider(
          create: (context) => HomeListingsNotifier(),
          child: FavouriteListingsScreen(),
        );
      });
    case UserRequests.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => RequestsNotifier()),
          ChangeNotifierProvider(
            create: (context) => UserNotifier(),
          )
        ], child: UserRequests());
      });
    case UserListings.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => ListingsNotifier()),
          ChangeNotifierProvider(
            create: (context) => UserNotifier(),
          )
        ], child: UserListings());
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

    case (UserDetails.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return ChangeNotifierProvider(
          create: (context) => UserNotifier(),
          child: const UserDetails(),
        );
      });

    case (ConversationListPage.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return ConversationListPage();
      });

    case (SplashScreen.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return ChangeNotifierProvider(
          create: (context) => UserNotifier(),
          child: const SplashScreen(),
        );
      });

    // case (CommunityHome.routeName):
    //   return MaterialPageRoute(builder: (ctx) {
    //     final args = settings.arguments as Map<String, dynamic>;
    //     return CommunityHome(
    //       communityId: args['communityId'],
    //     );
    //   });
    case (JoinedCommunityPage.routeName):
      return MaterialPageRoute(builder: (ctx) {
        return const JoinedCommunityPage();
      });
    default:
      return MaterialPageRoute(builder: (ctx) {
        return const ErrorScreen(error: "This page doesn't exist");
      });
  }
}
