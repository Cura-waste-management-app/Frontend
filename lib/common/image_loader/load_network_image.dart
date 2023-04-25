import 'package:flutter/material.dart';

import '../../constants.dart';
import '../snack_bar_widget.dart';

class LoadNetworkImage extends StatelessWidget {
  const LoadNetworkImage({Key? key, required this.imageURL, this.fit})
      : super(key: key);
  final String imageURL;
  final BoxFit? fit;

  showSnackBar(context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBarWidget(text: imageLoadError).getSnackBar());
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(imageURL, errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      // showSnackBar(context); //todo handle snackbar
      return Image.asset(defaultAssetImage);
    }, fit: fit);
  }
}
