import 'package:cura_frontend/features/community/join_community.dart';
import 'package:cura_frontend/features/community/new_community_page.dart';
import 'package:cura_frontend/features/community/widgets/community_card.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/bottom_nav_bar.dart';
import '../../models/community.dart';
import '../../util/constants/constant_data_models.dart';
import '../conversation/components/conversationList.dart';
import 'widgets/community_tile.dart';

class JoinedCommunityPage extends ConsumerStatefulWidget {
  static const routeName = '/community-page';
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
    List<Community> communityList =
        ref.watch(userCommunitiesProvider.notifier).state;

    // Filter the communityList based on the search query
    List<Community> filteredCommunityList = communityList.where((community) {
      return community.name.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return GestureDetector(
      onTapDown: (TapDownDetails details) => _onTapDown(context, details),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leadingWidth: 0,
          leading: Container(),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
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
                    return const JoinCommunity();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _updateFilter,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemCount: filteredCommunityList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CommunityTile(community: filteredCommunityList[index]);
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const NewCommunityPage();
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
