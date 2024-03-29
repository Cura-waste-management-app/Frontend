import 'package:cura_frontend/features/community/joined_community_page.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/bottom_nav_bar.dart';
import '../../common/load_error_screen.dart';
import '../../providers/community_providers.dart';
import 'explore_community.dart';

class CommunityRouter extends ConsumerWidget {
  const CommunityRouter({Key? key}) : super(key: key);
  final bool haveJoined = false;

  static const routeName = '/forum-screen';
  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: ref.watch(getUserCommunitiesProvider).when(data: (data) {
        if (data.isNotEmpty) {
          return const JoinedCommunityPage();
        } else {
          return const ExploreCommunity();
        }
      }, error: (Object error, StackTrace stackTrace) {
        return LoadErrorScreen();
      }, loading: () {
        return Container(
          color: Colors.white,
          child: const Center(
              child: CircularProgressIndicator(
            strokeWidth: 5,
          )),
        );
      }),
      bottomNavigationBar: BottomNavigation(index: 1),
    );
  }
}
