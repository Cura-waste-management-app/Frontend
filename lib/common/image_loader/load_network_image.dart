import 'package:flutter/material.dart';

class LoadNetworkImage extends StatelessWidget {
  const LoadNetworkImage({Key? key, required this.imageURL}) : super(key: key);
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Image.network(imageURL);
  }
}
