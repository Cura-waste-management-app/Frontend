import 'dart:io';

import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';

import 'package:cura_frontend/screens/userDetails/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final firebaseUser = auth.currentUser;
      final firebaseUID = firebaseUser!.uid;
      print("firebaseuid - $firebaseUID");

      // final idtoken = await user.getIdToken();
      // print(idtoken);
      // prefs.setString('uid', idtoken);

      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamed(UserDetails.routeName, arguments: {'firebaseUID': firebaseUID});
      // Navigator.pushNamedAndRemoveUntil(
      //     context, UserDetails.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
