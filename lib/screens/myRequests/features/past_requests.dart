import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Listings/models/listings.dart';

// ignore: use_key_in_widget_constructors
class PastRequests extends StatelessWidget {
  final Listing listing;
  const PastRequests(this.listing, {super.key});

  @override
  Widget build(BuildContext context) {
    const uid = '000000023c695a9a651a5344';

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 190,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: listing.sharedUserID == uid
                      ? const Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 20)
                      : const Icon(Icons.cancel_rounded,
                          color: Color.fromARGB(255, 240, 80, 69), size: 20),
                ),
                Text(listing.sharedUserID == uid ? 'Received' : 'Not Received',
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          Card(
              child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 1.0),
                child: Image.asset(listing.imagePath, width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                      style: const TextStyle(
                          fontWeight:FontWeight.w600, fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0),
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
                        listing.sharedUserID == uid
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    'Received on ${DateFormat.yMEd().format(listing.sharedTimeStamp!)}',
                                    style: const TextStyle(fontSize: 13)),
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
