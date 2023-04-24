import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Listings/models/listings.dart';
import '../../list_item_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class SharedListings extends StatelessWidget {
  final Listing listing;
  const SharedListings(this.listing, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(5),
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(10)),
      margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(10),
          top: getProportionateScreenHeight(5)),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
           
           margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenHeight(5)),
            child: Row(
              
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green),
                Padding(
                 padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text('Shared ', style: TextStyle(fontSize: getProportionateScreenHeight(14))),
                      Text(
                          'Posted on ${DateFormat.yMEd().add_jms().format(listing.postTimeStamp.toLocal())}',
                          style: TextStyle(fontSize: getProportionateScreenHeight(14), color: Colors.grey[600]))
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ListItemDetailScreen.routeName,
                arguments: {
                  'id': listing.id,
                  'path': 'mylistings',
                },
              );
            },
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  child: Row(
              children: [
                  Padding(
                     padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(4),
                        getProportionateScreenHeight(5),
                        getProportionateScreenWidth(8),
                        getProportionateScreenHeight(6)),
                   child:
                        Image.network(listing.imagePath, width: getProportionateScreenWidth(100),
                         height: getProportionateScreenHeight(100)),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: getProportionateScreenHeight(16))),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size( getProportionateScreenWidth(50),
                                      getProportionateScreenHeight(32) ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () {},
                            child: Text(
                              "Requests (${listing.requests})",
                              style:  TextStyle(
                                  fontSize:getProportionateScreenHeight(14),
                                  color: const Color.fromARGB(255, 142, 204, 255)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width:  getProportionateScreenWidth(220),
                        padding: EdgeInsets.only(top: getProportionateScreenHeight(25)),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                 Image.asset('assets/images/likes.png',
                                    height: getProportionateScreenHeight(16),
                                     width:  getProportionateScreenWidth(16)),
                                Padding(
                                 padding: EdgeInsets.only(left: getProportionateScreenWidth(3)),
                                  child: Text('${listing.likes}'),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              'Shared on 2 ${DateFormat.yMEd().format(listing.sharedTimeStamp!.toLocal())}',
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(14), color: Colors.black45),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ],
            ),
                )),
          ),
        ],
      ),
    );
  }
}
