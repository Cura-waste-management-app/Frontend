import 'package:cura_frontend/features/community/widgets/community_card.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/bottom_nav_bar.dart';
import '../../models/community.dart';
import '../../util/constants/constant_data_models.dart';
import '../conversation/components/conversationList.dart';
import 'models/community_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Community> communityList =
        ref.watch(userCommunitiesProvider.notifier).state;

    // Filter the communityList based on the search query
    List<Community> filteredCommunityList = communityList.where((community) {
      return community.name.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        "Communities",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: filteredCommunityList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CommunityTile(community: filteredCommunityList[index]);
            },
          )
        ],
      ),
    );
  }
}
