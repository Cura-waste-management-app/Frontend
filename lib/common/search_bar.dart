import 'package:flutter/material.dart';

typedef Cb = Function(String text);

class SearchBar extends StatelessWidget {
  final Cb setField;
  final String label;
  const SearchBar({required this.label, required this.setField, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
              onChanged: (text) => {setField(text)},
              decoration:  InputDecoration.collapsed(
                  hintText: label,
                  hintStyle: const TextStyle(fontSize: 14)),
            ),
          ),
        ]));
  }
}
