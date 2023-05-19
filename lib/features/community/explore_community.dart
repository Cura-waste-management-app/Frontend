import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/community/models/community_type_model.dart';
import 'package:cura_frontend/features/community/widgets/community_type.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/community_type_widget.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart' as pwd;
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:sizer/sizer.dart';

import '../../providers/bottom_nav_bar_provider.dart';
import 'widgets/community_card.dart';

class ExploreCommunity extends ConsumerStatefulWidget {
  const ExploreCommunity({Key? key}) : super(key: key);
  static const routeName = '/join-community';

  @override
  ConsumerState<ExploreCommunity> createState() => _ExploreCommunityState();
}

class _ExploreCommunityState extends ConsumerState<ExploreCommunity> {
  late CommunityType selectedCategory = CommunityType.all;

  void changeCommunityType(CommunityType category) {
    setState(() {
      selectedCategory = category;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  late String _filter = '';

  late List<Community> _filteredList;
  void _searchedCommunity(String value) {
    setState(() {
      _filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Community> communityList = ConstantDataModels.communityList;
    // late List<Community> filteredList;
    List<CommunityTypeModel> communityTypeList =
        ConstantDataModels.communityTypeList;
    final communityListAsyncValue = ref.watch(getAllCommunitiesProvider);
    double screenWidth = 100.w;
    double screenHeight = 100.h;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(getAllCommunitiesProvider);
        },
        child: Stack(children: [
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: screenHeight / 15,
            child: SizedBox(
              height: getProportionateScreenHeight(300),
              width: screenWidth,
              child: SvgPicture.asset('assets/images/join_community.svg',
                  width: getProportionateScreenWidth(200),
                  height: getProportionateScreenHeight(200)),
            ),
          ),
          Positioned(
            top: getProportionateScreenHeight(35),
            left: getProportionateScreenWidth(20),
            child: SearchBarAnimation(
              textEditingController: _searchController,
              isOriginalAnimation: false,
              searchBoxWidth: screenWidth / 1.2,
              buttonBorderColour: Colors.black45,
              enableKeyboardFocus: true,
              trailingWidget: const Icon(Icons.search),
              onChanged: _searchedCommunity,
              secondaryButtonWidget: const Icon(Icons.close),
              buttonWidget: const Icon(Icons.search),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: screenHeight / 2.2,
              width: screenWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getProportionateScreenWidth(40)),
                    topRight: Radius.circular(getProportionateScreenWidth(40))),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(30),
                      left: getProportionateScreenWidth(25),
                      right: getProportionateScreenWidth(25),
                      bottom: getProportionateScreenHeight(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(82),
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
                                width: 100.w / (communityTypeList.length + 1),
                                child: CommunityTypeWidget(
                                  changeCommunityType: changeCommunityType,
                                  communityType: communityTypeList[index].type,
                                  icon: communityTypeList[index].icon,
                                  selectedCategory: selectedCategory,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Communities List",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(26),
                                  fontWeight: FontWeight.w600),
                            )),
                        communityListAsyncValue.when(
                          data: (communityList) {
                            // changeFilterListState
                            // filter the community list based on selected type
                            if (communityList.isEmpty) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(40)),
                                  child: const Text(noCommunityExist));
                            }
                            _filteredList =
                                selectedCategory != CommunityType.all
                                    ? communityList
                                        .where((c) =>
                                            c.category == selectedCategory.type)
                                        .toList()
                                    : communityList;
                            if (_filter != '') {
                              _filteredList = _filteredList.where((community) {
                                return community.name
                                    .toLowerCase()
                                    .contains(_filter.toLowerCase());
                              }).toList();
                            }
                            return ListView.separated(
                              itemCount: _filteredList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(12)),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommunityCard(
                                    community: _filteredList[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) =>
                              const Text('Failed to fetch communities'),
                        ),
                      ],
                    ),
                  )),
            ),
          )
        ]),
      ),
      bottomNavigationBar:
          pwd.Provider.of<BottomNavBarProvider>(context, listen: false)
              .myBottomNavigation,
    );
  }
}
//todo pagination left
