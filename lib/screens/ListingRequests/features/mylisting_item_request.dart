import '../../Listings/models/listings.dart';
import 'package:flutter/material.dart';
import '../../ProfileScreen/other_profile_screen.dart';
import '../../ProfileScreen/other_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/listings_provider.dart';

class MyListingItemRequest extends StatefulWidget {
  final String userID;
  final String objectID;

  MyListingItemRequest({
    required this.userID,
    required this.objectID,
  });
  @override
  State<MyListingItemRequest> createState() => _MyListingItemRequestState();
}

class _MyListingItemRequestState extends State<MyListingItemRequest> {
  // const MyListingItemRequest({super.key});
  var buttonText = 'Accept';
  @override
  Widget build(BuildContext context) {
    // final item = Provider.of<MyDisplayItem>(context);
    return Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 3,
            top: 5,
            bottom: 5,
          ),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  OtherProfileScreen.routeName,
                  arguments: {
                    'userImageURL': "assets/images/male_user.png",
                    'owner': "Billa Singh",
                  },
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/male_user.png"),
                maxRadius: 30,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Billa Singh",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text("2 Days ago"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonText == 'Accept'
                    ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 11, 136, 26)),
                      )
                    : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 227, 45, 17)),
                      ),
                onPressed: () {

                    
                  // item.toggleRequest();
                },
                child: Text(buttonText),
              ),
            )
          ]),
        ));
  }
}
