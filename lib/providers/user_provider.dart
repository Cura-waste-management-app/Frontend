// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserNotifier extends ChangeNotifier {
  User? user;
  User? get currentUser => user;
  bool userFetchError = false;

  Future<User?> fetchUserInfo() async {
    try {
      var userData = await Hive.openBox(userDataBox);

      var uid = userData.get('uid');
      var response = await http.get(
        Uri.parse('$base_url/user/fetch/$uid'),
      );
      
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        final data = json.decode(response.body);
        // print("user - - $data");
        user = User.fromJson(data);
      } else {
        userFetchError = true;
      }
      return user;
    } catch (err) {
      print(err);
      userFetchError = true;
    }
    return user;
  }
}
