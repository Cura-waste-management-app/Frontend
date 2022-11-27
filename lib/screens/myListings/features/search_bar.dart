import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: 230,
        height: 35,
        margin: const EdgeInsets.fromLTRB(20, 10, 5, 5),
        padding: const EdgeInsets.fromLTRB(10, 5, 32, 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.search),
              SizedBox(
                width: 150,
                height: 20,
                child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: 'Search in listings',
                      hintStyle: TextStyle(fontSize: 14)),
                ),
              ),
            ]));
  }
}
