import 'package:cura_frontend/features/addlisting/add_screen.dart';
import 'package:cura_frontend/features/forum/forum.dart';
import 'package:cura_frontend/features/home/home_listing.dart';
import 'package:cura_frontend/features/location/location.dart';

import 'package:flutter/material.dart';

import 'common/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AddListing.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return const AddListing();
      });

    case HomeListing.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return HomeListing();
      });

    case Forum.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return const Forum();
      });

    case Location.routeName:
      return MaterialPageRoute(builder: (ctx) {
        return const Location();
      });

    default:
      return MaterialPageRoute(builder: (ctx) {
        return const ErrorScreen(error: "This page doesn't exist");
      });
  }
}
