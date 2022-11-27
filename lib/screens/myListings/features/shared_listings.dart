import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SharedListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 170,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Color.fromARGB(255, 41, 200, 47)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shared', style: TextStyle(fontSize: 13)),
                    Text('Posted on Tues, 18 Nov',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]))
                  ],
                )
              ],
            ),
          ),
          Card(
              child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/jacket.jpg',
                    width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Black Jacket',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Padding(
                          padding: const EdgeInsets.only(left: 75.0),
                          child: Image.asset('assets/images/likes.png',
                              height: 18, width: 18),
                        ),
                        const Text('6')
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: const Text('Requests - 9',
                          style: TextStyle(fontSize: 13))),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 25,
                          width: 70,
                          child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Share')),
                        ),
                        const Icon(Icons.delete)
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
