// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserNotifier extends ChangeNotifier {
  late User user;
  User get currentUser => user;

  Future<User?> fetchUserInfo() async {
    var response = await http.get(
      Uri.parse('$base_url/user/fetch/$uid'),
    );
    final data = json.decode(response.body);
    // print("user - - $data");
    user = User.fromJson(data);
    return user;
  }
}
