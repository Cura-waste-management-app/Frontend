import 'package:flutter/material.dart';

import '../../constants.dart';

class LoadNetworkCircularAvatar extends StatefulWidget {
  LoadNetworkCircularAvatar(
      {Key? key, required this.imageURL, this.radius = 20})
      : super(key: key);
  late String imageURL;
  final double radius;

  @override
  State<LoadNetworkCircularAvatar> createState() =>
      _LoadNetworkCircularAvatarState();
}

class _LoadNetworkCircularAvatarState extends State<LoadNetworkCircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CircleAvatar(
          backgroundColor: Colors.grey,
          radius: widget.radius,
          onBackgroundImageError: (exception, stackTrace) {
            setState(() {
              widget.imageURL = defaultNetworkImage;
            });
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('Failed to load Image'),
            //   ),
            // );
          },
          backgroundImage: NetworkImage(widget.imageURL),
        );
      },
    );
  }
}
