import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 150,
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.arrow_back_outlined,
                                size: 30,
                                color: Color.fromARGB(255, 87, 86, 86)),
                            Text('My Listings',
                                style: TextStyle(color: Colors.black)),
                          ])),
                  Container(
                      width: 100,
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.notifications_none,
                                size: 30,
                                color: Color.fromARGB(255, 87, 86, 86)),
                            CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBjUuK5Qmq0vFDfUMleYdDJcX5UzPzyeYNdpkflv2haw&s'))
                          ])),
                ]);
  }
}
