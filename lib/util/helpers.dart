import 'package:cura_frontend/features/community/joined_community_page.dart';
import 'package:cura_frontend/features/conversation/conversation_list_page.dart';
import 'package:cura_frontend/providers/bottom_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../common/bottom_nav_bar.dart';
import '../common/debug_print.dart';
import '../screens/homeListings/home_listings.dart';

void handleApiErrors(int statusCode, {required BuildContext context}) {
  String message;
  switch (statusCode) {
    case 400:
      message = "400: Bad Request";
      break;
    case 401:
      message = "401: Unauthorized Access";
      break;
    case 403:
      message = "403: Forbidden";
      break;
    case 404:
      message = "404: Not Found";
      break;
    case 408:
      message = "408: Request Timeout";
      break;
    case 429:
      message = "429: Too Many Requests";
      break;
    case 500:
      message = "500: Internal Server Error";
      break;
    case 502:
      message = "502: Bad Gateway";
      break;
    case 503:
      message = "503: Service Unavailable";
      break;
    case 504:
      message = "504: Gateway Timeout";
      break;
    default:
      message = "Error occurred, status code: $statusCode";
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

handleNavBarState(context) {
  Get.back();
  String? previousRouteName = Get.currentRoute;
  // prints(Get.previousRoute);
  // prints(Get.currentRoute);
  // prints(ModalRoute.of(context)!.settings.name);

  BottomNavigationController controller =
      Get.find<BottomNavigationController>();
  if (previousRouteName == HomeListings.routeName) {
    controller.setIndex(0);
  } else if (previousRouteName == JoinedCommunityPage.routeName) {
    controller.setIndex(1);
  } else if (previousRouteName == ConversationListPage.routeName) {
    controller.setIndex(2);
  }
}
