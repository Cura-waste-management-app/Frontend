import 'package:cura_frontend/common/main_drawer.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/screens/help_support_screen.dart';
import 'package:cura_frontend/screens/privacy_policy_screen.dart';
import 'package:cura_frontend/screens/userDetails/update_user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/home_listings_provider.dart';

class MyProfile extends StatelessWidget {
  static const routeName = '/my-profile';

  @override
  Widget build(BuildContext context) {
    Map user = Provider.of<HomeListingsNotifier>(context).userdata;
    print("user mei aaye");
    print(user['avatarURL'] == null);
    // print(user['avatarURL']);
    String imgurl = "";
    if (user['avatarURL'] == null || user['avatarURL'].length == 0) {
      imgurl = "";
    } else {
      imgurl = user['avatarURL'];
    }

    // print(user['avatarURL']);
    // print(imgurl);
    // print();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // toolbarHeight: 70,
        elevation: 2.0,

        leadingWidth: 65,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Padding(
          padding: EdgeInsets.only(left: 22),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: imgurl.length > 0
                ? NetworkImage(imgurl) as ImageProvider
                : AssetImage(
                    'assets/images/male_user.png',
                  ),
          ),
        ),
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
      ),
      endDrawer: MainDrawer(),
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
                            child: imgurl.length == 0
                                ? Image.network(
                                    defaultNetworkImage,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    imgurl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        )),
                    // Positioned(
                    //   top: 250,
                    //   left: 200,
                    //   child: Container(
                    //       height: 40,
                    //       width: 40,
                    //       child: FittedBox(
                    //         child: FloatingActionButton(
                    //             onPressed: () {},
                    //             backgroundColor: Colors.black,
                    //             child: Icon(Icons.edit)),
                    //       )),
                    // ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5)),
                  Text(
                    user['name'],
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // Text(
                  //   "curransam0504@gmail.com | +91-8329011233",
                  // ),
                ],
              ),
            ),
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
                            Text("Points Earned"),
                          ],
                        ),
                        Text(user['points'].toString()),
                      ],
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UpdateUserDetails.routeName);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.info),
                            SizedBox(width: 10),
                            Text("Edit Profile Information"),
                          ],
                        ),
                      ),
                      // SizedBox(height: 15),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(Icons.notifications),
                      //         SizedBox(width: 10),
                      //         Text("Notifications"),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: <Widget>[
                      //         Text(
                      //           "ON",
                      //           style:
                      //               TextStyle(color: Colors.blue, fontSize: 16),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(HelpSupportScreen.routeName);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.help_outlined),
                            SizedBox(width: 10),
                            Text("Help and Support"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PrivacyPolicyScreen.routeName);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(width: 10),
                            Text("Privacy Policy"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
