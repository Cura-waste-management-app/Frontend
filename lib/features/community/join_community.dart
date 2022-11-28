import 'package:cura_frontend/features/community/widgets/community_type.dart';
import 'package:flutter/material.dart';

import 'widgets/community_card.dart';

class JoinCommunity extends StatelessWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      Container(
        color: Colors.white60,
        // height: 300,
        // width: screen_width,
        // child: Image.asset('assets/images/join_community.png',
        //     width: 200, height: 200),
      ),
      Positioned(
        top: 0,
        child: Container(
          height: 300,
          width: screen_width,
          child: Image.asset('assets/images/join_community.png',
              width: 200, height: 200),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          height: screen_height / 1.7,
          width: screen_width,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommunityType(type: 'food', icon: Icons.restaurant),
                        CommunityType(type: 'cloth', icon: Icons.checkroom),
                        CommunityType(
                            type: 'furniture', icon: Icons.chair_outlined),
                        CommunityType(type: 'other', icon: Icons.more_outlined),
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Communities List",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  CommunityCard(
                    numberOfMembers: '34',
                    communityLocation: 'chandigarh',
                    communityName: 'ChandigarhNGO',
                  ),
                  CommunityCard(
                    numberOfMembers: '34',
                    communityLocation: 'chandigarh',
                    communityName: 'ChandigarhNGO',
                  ),
                  CommunityCard(
                    numberOfMembers: '34',
                    communityLocation: 'chandigarh',
                    communityName: 'ChandigarhNGO',
                  ),
                ],
              )),
        ),
      )
    ]));
  }
}
