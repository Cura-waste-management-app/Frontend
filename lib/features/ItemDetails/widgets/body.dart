import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/home/widgets/icon_view.dart';
import 'package:cura_frontend/models/display_item.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final DisplayItem item;
  const Body({super.key, required this.item});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Container(
          width: screenWidth,
          height: 390,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.item.imagePath), fit: BoxFit.fitWidth),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconView(
                icon: Icons.ios_share,
                text: "Share",
              ),
              const SizedBox(
                width: 10,
              ),
              IconView(
                icon: Icons.favorite,
                count: widget.item.likes.toString(),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.item.userImageURL),
                      maxRadius: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   width: 3,
                        //   height: 5,
                        // ),
                        Text("${widget.item.userName} is giving away"),
                        Text(
                          widget.item.title,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconView(
                              icon: Icons.timelapse_outlined,
                              text: "Added 10 minutes ago",
                            )
                          ],
                        )
                      ],
                    ),
                  ]

                  // Size,
                  ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ignore: prefer_const_constructors
              Container(
                width: screenWidth / 1.1,
                child: const Flexible(
                  // ignore: prefer_const_constructors
                  child: Text(
                    "Levis Leather Jacket. Grey Colour with high neck color. Good for winter wear",
                    // ignore: prefer_const_constructors
                    style:
                        TextStyle(overflow: TextOverflow.visible, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Pick-up time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("With in a Week "),
            ],
          ),
        ),
        const SizedBox(
          height: 65,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.black87,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 10.0,
              backgroundColor: Colors.black,
              minimumSize: Size(screenWidth / 1.2, 50)),
          onPressed: () {},
          child: const Text(
            'Requst This ',
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
