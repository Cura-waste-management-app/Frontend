import 'dart:math';

import 'package:cura_frontend/features/community/community_detail_page.dart';
import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event.dart';
import '../../profile/screens/view_profile.dart';
import 'package:flutter/material.dart';

class ConversationAppBar extends ConsumerStatefulWidget {
  final String imageURL;
  final String userName;
  final Event? event;
  final Community? community;
  const ConversationAppBar({
    Key? key,
    required this.imageURL,
    required this.userName,
    this.event,
    this.community,
  }) : super(key: key);

  @override
  ConsumerState<ConversationAppBar> createState() => _ConversationAppBarState();
}
//todo change Name

class _ConversationAppBarState extends ConsumerState<ConversationAppBar> {
  void selectDescription(BuildContext ctx) {
    ConversationType conversationType =
        ref.read(conversationTypeProvider.notifier).state;
    if (conversationType.type == ConversationType.user.type)
      Navigator.of(ctx).pushNamed(ViewProfile.routeName, arguments: {
        'name': widget.userName,
      });
    else if (conversationType.type == ConversationType.event.type) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailPage(event: widget.event!),
        ),
      );
    } else if (conversationType.type == ConversationType.community.type) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CommunityDetailsPage(community: widget.community!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 3,
      titleSpacing: 0,
      leadingWidth: 0,
      leading: Container(),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black),
      // IconButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   icon: Icon(
      //     Icons.arrow_back,
      //     color: Colors.black,
      //   ),
      // ),
      //todo change imageURL
      title: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/male_user.png"),
          maxRadius: 20,
        ),
        title: Text(
          widget.userName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: widget.event != null || widget.community != null
            ? Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    ref.read(conversationTypeProvider.notifier).state.type ==
                            ConversationType.event.type
                        ? '${widget.event?.totalMembers} members'
                        : ref
                                    .read(conversationTypeProvider.notifier)
                                    .state
                                    .type ==
                                ConversationType.community.type
                            ? '${widget.community?.totalMembers} members'
                            : '',
                    style: const TextStyle(
                      // color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : null,
        trailing: const Icon(
          Icons.more_vert,
          color: Colors.black54,
        ),
        onTap: () => selectDescription(context),
      ),
    );
  }
}
