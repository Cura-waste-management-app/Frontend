import 'package:flutter/material.dart';
import '../../Listings/models/listings.dart';

// ignore: use_key_in_widget_constructors
class PastRequests extends StatelessWidget {
  final Listing listing;
  const PastRequests(this.listing, {super.key});

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
            width: 170,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Received', style: TextStyle(fontSize: 13)),
                    Text('Posted on ${listing.postDate}',
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
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 1.0),
                child: Image.asset(listing.imgURL, width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listing.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Requests - ${listing.requests}',
                          style: const TextStyle(fontSize: 13))),
                  Container(
                    width: 225,
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                     
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/views.png',
                                height: 16, width: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text('${listing.views}'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Image.asset('assets/images/likes.png',
                                  height: 16, width: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text('${listing.likes}'),
                              ),
                            ],
                          ),
                        ),
                       Padding(
                         padding: const EdgeInsets.only(left:8.0),
                         child: Text('Received on ${listing.sharedDate}',
                         style: const TextStyle(fontSize: 13)),
                       )
                        ,
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
