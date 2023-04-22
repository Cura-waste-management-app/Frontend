import 'package:flutter/material.dart';

class SnackBarWidget {
  final String text;

  const SnackBarWidget({required this.text});

  SnackBar getSnackBar() {
    return SnackBar(content: Text(text));
  }
}
