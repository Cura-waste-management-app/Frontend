import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _idToken;

  Future<String?> getIdToken() async {
    if (_idToken == null) {
      const int refreshTokenInterval = 10;
      Timer.periodic(Duration(seconds: refreshTokenInterval), (timer) {
        FirebaseAuth.instance.currentUser?.getIdToken(true);
      });
      User? user = _auth.currentUser;
      if (user != null) {
        _idToken = await user.getIdToken();
        _auth.idTokenChanges().listen((event) async {
          _idToken = await event?.getIdToken();
          print('id token : $_idToken');
          notifyListeners();
        });
      }
    }
    return _idToken;
  }
}
