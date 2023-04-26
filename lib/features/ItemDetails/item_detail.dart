import 'package:cura_frontend/features/ItemDetails/widgets/body.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/display_item.dart';
import '../home/home_listing.dart';

class ItemDetail extends StatefulWidget {
  static const routeName = '/item-detail-screen';
  final DisplayItem displayItem;
  const ItemDetail({super.key, required this.displayItem});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = 100.w;
    double screenHeight = 100.h;
    //DisplayItem item = routeArgs!=null? routeArgs== null
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 1,
        title: Text(
          widget.displayItem.title,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              overflow: TextOverflow.ellipsis),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        // actions: [
        //   const Padding(
        //     padding: EdgeInsets.only(right: 20.0),
        //     child: Icon(Icons.flag, color: Colors.black87, size: 26),
        //   ),
        // ],
        leadingWidth: 60,
        leading: Expanded(
          child: Row(children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeListing.routeName);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const SizedBox(
              width: 4,
            ),
          ]),
        ),
      ),
      body: Body(item: widget.displayItem),

      // ElevatedButton(
      //       style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      //       // ignore: prefer_const_constructors
      //       onPressed: () {

      //         Navigator.pushNamed(context, HomeListing.routeName);
      //       },
      //       child: const Text('Get Current location '))
    );
  }
}
