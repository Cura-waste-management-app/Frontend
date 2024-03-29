import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/explore_community.dart';
import 'package:cura_frontend/features/community/new_community_page.dart';
import 'package:cura_frontend/features/community/widgets/explore_new_community.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:cura_frontend/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart' as pd;

import '../../common/debug_print.dart';
import '../../models/community.dart';
import '../../providers/bottom_nav_bar_provider.dart';
import 'models/entity_modifier.dart';
import 'widgets/community_tile.dart';

class JoinedCommunityPage extends ConsumerStatefulWidget {
  static const routeName = '/joined_community';
  const JoinedCommunityPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _JoinedCommunityPageState createState() => _JoinedCommunityPageState();
}

class _JoinedCommunityPageState extends ConsumerState<JoinedCommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';

  void _updateFilter(String value) {
    setState(() {
      _filter = value;
    });
  }

  void _onTapDown(BuildContext context, TapDownDetails details) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  void onComingBack() {
    setState(() {
      filteredCommunityList = ref
          .watch(userCommunitiesProvider)
          .entries
          .map((entry) => entry.value)
          .toList()
          .where((community) {
        return community.name.toLowerCase().contains(_filter.toLowerCase());
      }).toList();
    });
  }

  List<Community> filteredCommunityList = [];
  @override
  Widget build(BuildContext context) {
    // prints('id token now : ${pd.Provider.of<Auth>(context).getIdToken()}');
    final joinedCommunityListAsyncValue = ref.watch(getUserCommunitiesProvider);
    // Filter the communityList based on the search query
    return WillPopScope(
        onWillPop: () async {
          handleNavBarState(context);
          return false;
        },
        child: GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(context, details),
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              leadingWidth: 0,
              leading: Container(),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              titleTextStyle: const TextStyle(color: Colors.black),
              // backgroundColor: Colors.black,
              title: const Text(
                "Communities",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              actions: [
                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'explore',
                        child: Text('Explore New Communities'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'new',
                        child: Text('Create New Community'),
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    if (value == 'explore') {
                      Get.to(const ExploreCommunity());
                    } else if (value == 'new') {
                      Get.to(NewCommunityPage(
                        entityModifier: EntityModifier.create,
                      ));
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(getUserCommunitiesProvider);
              },
              child: ListView(
                children: [
                  joinedCommunityListAsyncValue.when(
                    data: (communityList) {
                      filteredCommunityList = ref
                          .watch(userCommunitiesProvider)
                          .entries
                          .map((entry) => entry.value)
                          .toList()
                          .where((community) {
                        return community.name
                            .toLowerCase()
                            .contains(_filter.toLowerCase());
                      }).toList();
                      return filteredCommunityList.isNotEmpty ||
                              (filteredCommunityList.isEmpty && _filter != '')
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getProportionateScreenHeight(
                                                  16),
                                              left: getProportionateScreenWidth(
                                                  16),
                                              right:
                                                  getProportionateScreenWidth(
                                                      16)),
                                          child: TextField(
                                            controller: _searchController,
                                            onChanged: _updateFilter,
                                            decoration: InputDecoration(
                                              hintText: "Search...",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade600),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.grey.shade600,
                                                size:
                                                    getProportionateScreenHeight(
                                                        20),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey.shade100,
                                              contentPadding: EdgeInsets.all(
                                                  getProportionateScreenHeight(
                                                      8)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getProportionateScreenWidth(
                                                              20)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .grey.shade100)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(5),
                                  ),
                                  ListView.separated(
                                    itemCount: filteredCommunityList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                        top: getProportionateScreenHeight(12)),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return CommunityTile(
                                          communityId:
                                              filteredCommunityList[index].id ??
                                                  '0');
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Divider();
                                    },
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(100),
                                  )
                                ],
                              ),
                            )
                          : const ExploreNewCommunity();
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, stackTrace) {
                      prints(stackTrace);
                      return const Center(
                          child: Text('Failed to fetch communities'));
                    },
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black87,
              onPressed: () async {
                Get.to(NewCommunityPage(
                  entityModifier: EntityModifier.create,
                ));
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar:
                pd.Provider.of<BottomNavBarProvider>(context, listen: false)
                    .myBottomNavigation,
          ),
        ));
  }
}
