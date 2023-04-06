import 'package:flutter/material.dart';

class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage({Key? key, required this.imageURL}) : super(key: key);
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Image.asset(imageURL);
  }
}
