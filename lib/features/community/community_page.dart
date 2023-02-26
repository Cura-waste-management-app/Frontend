import 'package:cura_frontend/features/community/widgets/community_card.dart';
import 'package:flutter/material.dart';
import '../../common/bottom_nav_bar.dart';
import '../../models/community.dart';
import '../../util/constants/constant_data_models.dart';
import '../conversation/components/conversationList.dart';

class CommunityPage extends StatefulWidget {
  static const routeName = '/community-page';
  const CommunityPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Community> communityList = ConstantDataModels.communityList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
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
              itemCount: communityList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CommunityCard(communityList[index]);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(index: 3),
    );
  }
}
