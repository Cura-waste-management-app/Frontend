import 'package:flutter/material.dart';

class OtherProfileScreen extends StatelessWidget {
  static const routeName = '/person-profile';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(137, 91, 89, 89),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(180),
                        bottomRight: Radius.circular(180),
                      ),
                    ),
                    height: 240,
                    width: 360,
                    child: const Text(" "),
                  ),
                  Positioned(
                      // bottom: 0,
                      top: 160,
                      left: 120,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(60), // Image radius
                          child: Image.network(routeArgs['userImageURL']!,
                              fit: BoxFit.cover),
                        ),
                      )),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                  routeArgs['owner']!,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            children: const <Widget>[
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
                          const Text("4.0"),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
                      children: const <Widget>[Text("Accepts Request")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "80%",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
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
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
                          children: const <Widget>[Text("Listings offered")],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: const <Widget>[
                                Text("34", style: TextStyle(fontSize: 23)),
                                Text("Last 30 days"),
                              ],
                            ),
                            Column(
                              children: const <Widget>[
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
