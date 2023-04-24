import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:cura_frontend/providers/home_listings_provider.dart';
import 'package:cura_frontend/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Listings/models/listings.dart';
import '../../list_item_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class PastRequests extends StatelessWidget {
  final Listing listing;
  const PastRequests(this.listing, {super.key});

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 listing.sharedUserID == uid
                      ? Icon(Icons.check_circle_rounded,
                          color: Colors.green, size:  getProportionateScreenWidth(20))
                      : Icon(Icons.cancel_rounded,
                          color: const Color.fromARGB(255, 240, 80, 69), size:  getProportionateScreenWidth(20)),
               
                Padding(
                   padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                  child: Text(listing.sharedUserID == uid ? 'Received' : 'Not Received',
                      style: TextStyle(fontSize: getProportionateScreenHeight(14))),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ListItemDetailScreen.routeName,
                arguments: {
                  'id': listing.id,
                  'path': 'myrequests',
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(14))),
                      Padding(
                        padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
                        child: Row(children: [
                          GestureDetector(
                            onTap: (){
                             Provider.of<HomeListingsNotifier>(context,
                                            listen: false)
                                        .getUserInfo(listing.owner.id.toString())
                                        .then((_) {
                                      
                                      Navigator.of(context).pushNamed(
                                          OtherProfileScreen.routeName,
                                         );
                                    });
                          },
                            child: CircleAvatar(
                              minRadius: getProportionateScreenWidth(15),
                              backgroundImage:
                                  NetworkImage(listing.owner.avatarURL!),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: getProportionateScreenWidth(3)),
                            child: Text(listing.owner.name),
                          )
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getProportionateScreenHeight(30)),
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
                            listing.sharedUserID == uid
                                ? Padding(
                                    padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
                                    child: Text(
                                      'Received on ${DateFormat.yMEd().format(listing.sharedTimeStamp!.toLocal())}',
                                      style: TextStyle(
                                          fontSize: getProportionateScreenHeight(14), color: Colors.grey[600]),
                                    ))
                                : const Text(''),
                          ],
                        ),
                      ),
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
