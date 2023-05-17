import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/models/user.dart';

import 'package:cura_frontend/screens/userDetails/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user.dart' as userClass;
import '../../../constants.dart';
import '../../../providers/constants/variables.dart';
import 'package:provider/provider.dart' as pwd;

import '../../../providers/user_provider.dart';
import '../../../screens/homeListings/home_listings.dart';
import '../../conversation/providers/conversation_providers.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepository(FirebaseAuth.instance));

class AuthRepository {
  final FirebaseAuth auth;
  AuthRepository(this.auth);

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            if (!Platform.isAndroid) {
              await auth.signInWithCredential(credential);
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            throw Exception(exception.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.pushNamed(context, AuthScreenOtp.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String s) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP,
      WidgetRef ref) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final firebaseUser = auth.currentUser;
      final firebaseUID = firebaseUser!.uid;
      print('$base_url/user/getUserByFirebaseUID/$firebaseUID');

      // final idtoken = await user.getIdToken();
      // print(idtoken);
      // prefs.setString('uid', idtoken);

      // ignore: use_build_context_synchronously
      var response = await get(
        Uri.parse('$base_url/user/getUserByFirebaseUID/$firebaseUID'),
      );
      final mongooseUser = json.decode(response.body);
      // print(mongooseUser);
      if (response.statusCode == 404 &&
          mongooseUser['message'] == "User does not exists!") {
        Navigator.of(context).pushNamed(UserDetails.routeName,
            arguments: {'firebaseUID': firebaseUID});
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
        ref.read(conversationSocketProvider(mongooseUser['_id'])).connect();
        Timer(const Duration(seconds: 1), (() {
          Navigator.popAndPushNamed(context, HomeListings.routeName);
        }));
      }

      // Navigator.pushNamedAndRemoveUntil(
      //     context, UserDetails.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
