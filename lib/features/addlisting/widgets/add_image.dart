import 'package:cura_frontend/features/addlisting/widgets/title_description.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddImage extends StatelessWidget {
  const AddImage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          // padding: EdgeInsets.symmetric(vertical: 20),
          child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 38, 36, 39),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        highlightColor: Colors.transparent,
                        onPressed: () {},
                        iconSize: 40,
                      ),
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15,),
                      child: Text(
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
                    ),
                  ],
                ),
              )),
        ),
        const TitlteDescription(),
      ],
    );
  }
}
