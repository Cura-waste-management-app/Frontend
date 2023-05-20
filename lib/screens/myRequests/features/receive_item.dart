import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/requests_provider.dart';
import '../../Listings/models/listings.dart';
import '../../../common/debug_print.dart';

class ReceiveItem extends StatefulWidget {
  String uid;
  final Listing listing;
  ReceiveItem({required this.uid, required this.listing, super.key});

  @override
  State<ReceiveItem> createState() => _ReceiveItemState();
}

class _ReceiveItemState extends State<ReceiveItem> {
  double _rating = 0;
  String listingStatus = "";
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getListingStatus();
  }

  Future<void> getListingStatus() async {
    setState(() {
      isLoading = true;
    });
    var response = await Provider.of<RequestsNotifier>(context, listen: false)
        .listingReceived(widget.listing.id, widget.uid);
    setState(() {
      isLoading = false;
      listingStatus = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : listingStatus == 'Item received!'
            ? AlertDialog(
                title: const Text('Please rate the item received -'),
                content: SizedBox(
                  height: getProportionateScreenHeight(110),
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
                    padding: EdgeInsets.only(
                        right: getProportionateScreenWidth(110)),
                    child: ElevatedButton(
                      child: const Text('Enter'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(listingStatus),
              );
  }
}
