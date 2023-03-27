import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Listings/models/listings.dart';

// ignore: use_key_in_widget_constructors
class SharedListings extends StatelessWidget {
  final Listing listing;
  const SharedListings(this.listing, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 260,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shared ', style: TextStyle(fontSize: 13)),
                    Text(
                        'Posted on ${DateFormat.yMEd().add_jms().format(listing.postTimeStamp)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]))
                  ],
                )
              ],
            ),
          ),
          Card(
              child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 6.0, bottom: 6.0, right: 2.0),
                child: Image.asset(listing.imagePath, width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                 Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(listing.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft),
                              onPressed: () {   },
                              child: Text(
                                "Requests (${listing.requests})",
                                style: const TextStyle(fontSize: 13,
                                color: Color.fromARGB(255, 142, 204, 255)),
                              ),
                            ),
                          ],
                        ),
                  Container(
                    width: 225,
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Row(
                            children: [
                              Image.asset('assets/images/likes.png',
                                  height: 16, width: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text('${listing.likes}'),
                              ),
                            ],
                          ),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              'Shared on2 ${DateFormat.yMEd().format(listing.sharedTimeStamp!)}',
                              style: const TextStyle(fontSize: 13)),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
