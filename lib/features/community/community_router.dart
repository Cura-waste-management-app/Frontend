import 'package:cura_frontend/features/community/joined_community_page.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/community_providers.dart';
import 'community_home.dart';
import 'join_community.dart';

class CommunityRouter extends ConsumerWidget {
  const CommunityRouter({Key? key}) : super(key: key);
  final bool haveJoined = false;

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(getAllCommunitiesProvider).when(
        data: (data) {
          print(data);
        },
        error: (Object error, StackTrace stackTrace) {
          print(error);
        },
        loading: () {});

    return haveJoined ? JoinedCommunityPage() : JoinCommunity();
  }
}
