
import 'package:flutter/material.dart';

class TitlteDescription extends StatelessWidget {
  const TitlteDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 200,
      child: Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: const <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
