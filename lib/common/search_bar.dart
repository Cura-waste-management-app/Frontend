import 'package:cura_frontend/common/size_config.dart';
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
        width: getProportionateScreenWidth(230),
        height: getProportionateScreenHeight(35),
        margin: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(20),
            getProportionateScreenHeight(10),
            getProportionateScreenWidth(5),
            getProportionateScreenHeight(5)),
        padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(10),
            getProportionateScreenHeight(5),
            getProportionateScreenWidth(32),
            getProportionateScreenHeight(5)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Icon(Icons.search),
          SizedBox(
            width: getProportionateScreenWidth(150),
            height: getProportionateScreenHeight(20),
            child: TextField(
              onChanged: (text) => {setField(text)},
              decoration: InputDecoration.collapsed(
                  hintText: label,
                  hintStyle: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                  )),
            ),
          ),
        ]));
  }
}
