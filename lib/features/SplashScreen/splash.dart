// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:cura_frontend/features/home/home_listing.dart';
import 'package:cura_frontend/features/location/location.dart';
import 'package:cura_frontend/firebase_options.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pwd;
import 'package:cura_frontend/util/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cura_frontend/providers/constants/variables.dart';
import '../../models/user.dart' as userClass;
import '../../constants.dart';
import '../../providers/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeName = 'splash-screen';
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // SharedPreferences prefs = await SharedPreferences.getInstance();

        final user = auth.currentUser;
        print("user -- $user");
        if (user != null) {
          // final idtoken = await user.getIdToken();
          // print(idtoken);
          // prefs.setString('uid', idtoken);

          final firebaseUID = user.uid;
          print(firebaseUID);
          var response = await http.get(
            Uri.parse('$base_url/user/getMongooseUID/$firebaseUID'),
          );
          final mongooseUser = json.decode(response.body);
          print(mongooseUser);
          if (mongooseUser['message'] == "User does not exists!") {

            Navigator.popAndPushNamed(context, AuthScreenPhone.routeName);

          } else {
            // const uid =  mongooseUser['mongooseUID];
            var userData = await Hive.openBox(userDataBox);
            userData.put('uid', mongooseUser['_id']);
            // user.=mongooseUser['_id'];
            // set the current user, this method - does not work
            userClass.User user = userClass.User.fromJson(mongooseUser);
            pwd.Provider.of<UserNotifier>(context, listen: false).user = user;

            ref.read(userIDProvider.notifier).state = mongooseUser['_id'];
            ref.read(userProvider.notifier).state = user;
            Timer(const Duration(seconds: 1), (() {
              Navigator.popAndPushNamed(context, HomeListings.routeName);
            }));
          }
        } else {
          print('NO USERRRRRRRRR');
          Navigator.popAndPushNamed(context, AuthScreenPhone.routeName);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
        //     stops: [0, 1],
        //     begin: AlignmentDirectional(1, -1),
        //     end: AlignmentDirectional(-1, 1),
        //   ),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash1.png',
              width: 200,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Text(
                'CURA',
                style: TextStyle(color: Colors.white, fontSize: 56),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
              child: Text(
                'One-stop solution for minimizing everyday waste',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
