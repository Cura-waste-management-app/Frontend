import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/requests_provider.dart';
import '../../Listings/models/listings.dart';

class ReceiveItem extends StatefulWidget {
  final Listing listing;
  const ReceiveItem({required this.listing, super.key});

  @override
  State<ReceiveItem> createState() => _ReceiveItemState();
}

class _ReceiveItemState extends State<ReceiveItem> {
  double _rating = 0;
  String listingStatus = "";

  @override
  void initState() {
    super.initState();
    getListingStatus();
  }

  Future<void> getListingStatus() async {
    String response =
        await Provider.of<RequestsNotifier>(context, listen: false)
            .listingReceived(widget.listing.id);
    // // ignore: use_build_context_synchronously
    // await Provider.of<RequestsNotifier>(context, listen: false)
    //     .getUserRequests();
    setState(() {
      listingStatus = response;
      // print("heloo - $listingStatus");
    });
  }

  @override
  Widget build(BuildContext context) {
    return listingStatus != ""
        ? listingStatus == 'Item received!'
            ? AlertDialog(
                title: const Text('Please rate the item received -'),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text('Rating: $_rating'),
                      Slider(
                        value: _rating,
                        min: 0,
                        max: 10,
                        divisions: 2,
                        label: _rating.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 100.0),
                    child: ElevatedButton(
                      child: const Text('Enter'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            : const AlertDialog(
                title: Text('No confirmation from the user'),
              )
        : const AlertDialog(
            title: Text(''),
          );
  }
}
