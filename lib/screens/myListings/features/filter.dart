import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Filter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              width: 90,
              height: 35,
              margin: const EdgeInsets.fromLTRB(5, 10, 20, 5),
              padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Icon(Icons.filter, size: 15), Text('Filter')],
              ));
  }
}