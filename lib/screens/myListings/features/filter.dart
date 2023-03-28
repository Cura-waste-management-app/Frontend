import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Filter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        width: 80,
        height: 35,
        margin: const EdgeInsets.fromLTRB(5, 10, 20, 5),
        padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/filter.png', width: 20),
            const Text('Filter', style: TextStyle(fontSize: 14))
          ],
        ));
  }
}
