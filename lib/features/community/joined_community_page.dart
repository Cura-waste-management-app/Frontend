import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/explore_community.dart';
import 'package:cura_frontend/features/community/new_community_page.dart';
import 'package:cura_frontend/features/community/widgets/community_card.dart';
import 'package:cura_frontend/features/community/widgets/explore_new_community.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/bottom_nav_bar.dart';
import '../../common/snack_bar_widget.dart';
import '../../constants.dart';
import '../../models/community.dart';
import '../../providers/auth.dart';
import '../../util/constants/constant_data_models.dart';
import '../conversation/components/conversation_widget.dart';
import 'models/entity_modifier.dart';
import 'widgets/community_tile.dart';
import 'package:provider/provider.dart' as pd;

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

  @override
  Widget build(BuildContext context) {
    // print('id token now : ${pd.Provider.of<Auth>(context).getIdToken()}');
    print("++++++++++++++++++");
    print(ref.read(userIDProvider));
    final joinedCommunityListAsyncValue = ref.watch(getUserCommunitiesProvider);
    // Filter the communityList based on the search query
    return GestureDetector(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ExploreCommunity();
                  }));
                } else if (value == 'new') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewCommunityPage(
                      entityModifier: EntityModifier.create,
                    );
                  }));
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
          child: joinedCommunityListAsyncValue.when(
            data: (communityList) {
              // changeFilterListState
              // filter the community list based on selected type

              List<Community> filteredCommunityList =
                  communityList.where((community) {
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(16),
                                      left: getProportionateScreenWidth(16),
                                      right: getProportionateScreenWidth(16)),
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
                                        size: getProportionateScreenHeight(20),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      contentPadding: EdgeInsets.all(
                                          getProportionateScreenHeight(8)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              getProportionateScreenWidth(20)),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CommunityTile(
                                  community: filteredCommunityList[index]);
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
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stackTrace) {
              print(stackTrace);
              return const Center(child: Text('Failed to fetch communities'));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewCommunityPage(
                entityModifier: EntityModifier.create,
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
