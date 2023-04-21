import 'package:flutter/material.dart';

import '../../constants.dart';

class LoadCircularAvatar extends StatefulWidget {
  LoadCircularAvatar({Key? key, required this.imageURL, this.radius = 20})
      : super(key: key);
  late String imageURL;
  final double radius;

  @override
  State<LoadCircularAvatar> createState() => _LoadCircularAvatarState();
}

class _LoadCircularAvatarState extends State<LoadCircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: widget.radius,
      onBackgroundImageError: (exception, stackTrace) {
        setState(() {
          widget.imageURL = defaultAssetImage;
        });
      },
      backgroundImage: AssetImage(widget.imageURL),
    );
  }
}
