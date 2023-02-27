import 'package:cura_frontend/common/bottom_nav_bar.dart';
import 'package:cura_frontend/features/community/models/community_type_model.dart';
import 'package:cura_frontend/features/community/widgets/community_type.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'widgets/community_card.dart';

class JoinCommunity extends StatelessWidget {
  const JoinCommunity({Key? key}) : super(key: key);
  static const routeName = '/forum-screen';

  @override
  Widget build(BuildContext context) {
    List<Community> communityList = ConstantDataModels.communityList;
    List<CommunityTypeModel> communityTypeList =
        ConstantDataModels.communityTypeList;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: screenHeight / 18,
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
          child: SearchBarAnimation(
            textEditingController: TextEditingController(),
            isOriginalAnimation: false,
            searchBoxWidth: screenWidth / 1.2,
            buttonBorderColour: Colors.black45,
            enableKeyboardFocus: true,
            trailingWidget: const Icon(Icons.search),
            onFieldSubmitted: (String value) {
              debugPrint('onFieldSubmitted value $value');
            },
            secondaryButtonWidget: const Icon(Icons.close),
            buttonWidget: const Icon(Icons.search),
          ),
          // child: FloatingActionButton(
          //   backgroundColor: const Color(0xffefedef),
          //   onPressed: () {},
          //   child: const Icon(Icons.search, color: Colors.black, size: 28)
          //
          // ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: screenHeight / 2.2,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 82,
                        width: screenWidth / 1.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: communityTypeList.length,
                          shrinkWrap: true,
                          // padding: const EdgeInsets.only(top: 12),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width /
                                  (communityTypeList.length + 1),
                              child: CommunityType(
                                  type: communityTypeList[index].type,
                                  icon: communityTypeList[index].icon),
                            );
                          },
                        ),
                      ),
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
                      ListView.separated(
                        itemCount: communityList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 12),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CommunityCard(community: communityList[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    ],
                  ),
                )),
          ),
        )
      ]),
      bottomNavigationBar: BottomNavigation(index: 2),
    );
  }
}
