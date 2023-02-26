import 'package:cura_frontend/features/community/joined_community_page.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'community_home.dart';
import 'join_community.dart';

class CommunityRouter extends ConsumerWidget {
  const CommunityRouter({Key? key}) : super(key: key);
  final bool haveJoined = true;
  @override
  Widget build(BuildContext context, ref) {
    return haveJoined ? JoinedCommunityPage() : JoinCommunity();
  }
}
