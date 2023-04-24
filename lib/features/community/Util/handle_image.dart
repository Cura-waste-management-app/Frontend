import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage(context, picker) async {
  final source = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Select image source'),
      actions: <Widget>[
        TextButton(
          child: const Text('Camera'),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        TextButton(
          child: const Text('Gallery'),
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ],
    ),
  );

  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return pickedFile.path;
      // setState(() {
      //   imageFile = File(pickedFile.path);
      // });
    } else {
      return '';
    }
  } else {
    return '';
  }
}
