import 'package:cura_frontend/constants.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
   const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}



void showSnackBar({required BuildContext context, required String content}) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: kLightGreenColor,
    ),
  );
}