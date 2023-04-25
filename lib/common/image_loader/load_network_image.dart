import 'package:flutter/material.dart';

import '../../constants.dart';
import '../snack_bar_widget.dart';

class LoadNetworkImage extends StatelessWidget {
  const LoadNetworkImage({Key? key, required this.imageURL, this.fit})
      : super(key: key);
  final imageLoadError = 'Unable to fetch image from the server';
  final String imageURL;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.network(imageURL, errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      SnackBarWidget(text: imageLoadError);
      // return a fallback widget in case of error
      return Image.asset(defaultAssetImage);
    }, fit: fit);
  }
}
