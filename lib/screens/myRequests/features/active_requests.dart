import 'package:cura_frontend/providers/requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Listings/models/listings.dart';
import 'package:cura_frontend/screens/myRequests/features/receive_item.dart';

// ignore: use_key_in_widget_constructors
class ActiveRequests extends StatefulWidget {
  final Listing listing;
  const ActiveRequests({required this.listing, super.key});

  @override
  State<ActiveRequests> createState() => _ActiveRequestsState();
}

class _ActiveRequestsState extends State<ActiveRequests> {
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
            height: 20,
            width: 85,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.pending, color: Colors.blue),
                Text('Pending',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15))
              ],
            ),
          ),
          Card(
              child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 6.0),
                child: Image.asset(widget.listing.imagePath,
                    width: 100, height: 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.listing.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('Requests - ${widget.listing.requests}',
                                style: const TextStyle(fontSize: 13))
                          ],
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Provider.of<RequestsNotifier>(
                                    context,
                                    listen: false)
                                .deleteRequest(widget.listing.id),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Row(
                            children: [
                              Image.asset('assets/images/likes.png',
                                  height: 16, width: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text('${widget.listing.likes}'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          width: 90,
                          child: ElevatedButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChangeNotifierProvider(
                                        create: (context) => RequestsNotifier(),
                                        child: ReceiveItem(
                                            listing: widget.listing),
                                      );
                                    });
                               // ignore: use_build_context_synchronously
                               Provider.of<RequestsNotifier>(context,
                                        listen: false)
                                    .getUserRequests();
                              },
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Received')),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
