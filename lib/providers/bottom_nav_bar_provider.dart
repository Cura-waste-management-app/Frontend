import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarProvider extends ChangeNotifier {
  BottomNavigation _myBottomNavigation = BottomNavigation(
    index: 0,
  );

  BottomNavigation get myBottomNavigation => _myBottomNavigation;
}
