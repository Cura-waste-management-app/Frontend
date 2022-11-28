import 'package:flutter/material.dart';

typedef Cb = Function(String text);

class SearchBar extends StatelessWidget {
  final Cb setField;
  const SearchBar({required this.setField, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: 230,
        height: 35,
        margin: const EdgeInsets.fromLTRB(20, 10, 5, 5),
        padding: const EdgeInsets.fromLTRB(10, 5, 32, 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Icon(Icons.search),
          SizedBox(
            width: 150,
            height: 20,
            child: TextField(
              onChanged: (text) => setField(text),
              decoration: const InputDecoration.collapsed(
                  hintText: 'Search in listings',
                  hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
        ]));
  }
}
