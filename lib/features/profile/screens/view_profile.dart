import 'package:flutter/material.dart';

import '../../../common/debug_print.dart';

class ViewProfile extends StatelessWidget {
  static const routeName = '/person-profile';

  @override
  Widget build(BuildContext context) {
    // final routeArgs =
    // ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Profile Screen'),
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(137, 91, 89, 89),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(180),
                        bottomRight: Radius.circular(180),
                      ),
                    ),
                    height: 240,
                    width: 360,
                    child: Text(" "),
                  ),
                  Positioned(
                      // bottom: 0,
                      top: 160,
                      left: 120,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(60), // Image radius
                          child: Image.asset('assets/images/sam_curran.jpg',
                              fit: BoxFit.cover),
                        ),
                      )),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Sam Curran",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 218, 179, 4),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Rating"),
                            ],
                          ),
                          Text("4.2"),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Text("Accepts Request")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "80\%",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Replies to text in: 5 mins",
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[Text("Listings offered")],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text("34", style: TextStyle(fontSize: 23)),
                                Text("Last 30 days"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text("47", style: TextStyle(fontSize: 23)),
                                Text("All time"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ))),
          )
        ],
      )),
    );
  }
}
