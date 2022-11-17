import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddImage extends StatelessWidget {
  const AddImage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
    return Container(
      width: 378,
      height: 99,
      decoration: const BoxDecoration(),
      child: Column(children: <Widget>[
        Container(),

        // ignore: prefer_const_constructors
        Text(
          'Add up to 5 images',
          textAlign: TextAlign.center,
          // ignore: prefer_const_constructors
          style: GoogleFonts.openSans(
              // ignore: prefer_const_constructors
              textStyle: TextStyle(
            color: const Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
            height: 1,
          )),
        ),
      ]),
    );
  }
}
