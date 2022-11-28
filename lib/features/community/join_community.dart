import 'package:cura_frontend/features/community/widgets/community_type.dart';
import 'package:cura_frontend/models/community_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/community_card.dart';

class JoinCommunity extends StatelessWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CommunityList> communityList = [
      CommunityList(
          communityName: 'ChandigarhNGO',
          communityLocation: 'Chandigarh',
          numberOfMembers: '25'),
      CommunityList(
          communityName: 'DelhiNGO',
          communityLocation: 'Delhi',
          numberOfMembers: '47'),
      CommunityList(
          communityName: 'FoodSaver',
          communityLocation: 'Agra',
          numberOfMembers: '32'),
      CommunityList(
          communityName: 'ChandigarhNGO',
          communityLocation: 'Chandiagrh',
          numberOfMembers: '25'),
      CommunityList(
          communityName: 'DelhiNGO',
          communityLocation: 'Delhi',
          numberOfMembers: '47')
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: 0,
          child: SizedBox(
            height: 300,
            width: screenWidth,
            child: SvgPicture.asset('assets/images/join_community.svg',
                width: 200, height: 200),
          ),
        ),
        Positioned(
          top: 35,
          left: 20,
          child: FloatingActionButton(
              backgroundColor: const Color(0xffefedef),
              onPressed: () {},
              child: const Icon(Icons.search, color: Colors.black, size: 28)),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: screenHeight / 1.7,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color(0xffe4e8ea),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            CommunityType(type: 'Food', icon: Icons.restaurant),
                            Spacer(),
                            CommunityType(type: 'Cloth', icon: Icons.checkroom),
                            Spacer(),
                            CommunityType(
                                type: 'Furniture', icon: Icons.chair_outlined),
                            Spacer(),
                            CommunityType(
                                type: 'Other', icon: Icons.more_outlined),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Communities List",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        height: 0,
                      ),
                      ListView.builder(
                          itemCount: communityList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 12),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CommunityCard(
                                communityName:
                                    communityList[index].communityName,
                                communityLocation:
                                    communityList[index].communityLocation,
                                numberOfMembers:
                                    communityList[index].numberOfMembers);
                          })
                    ],
                  ),
                )),
          ),
        )
      ]),
      // bottomNavigationBar: BottomNavigation(index: 2),
    );
  }
}
