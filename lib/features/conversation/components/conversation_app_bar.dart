import 'dart:math';

import 'package:cura_frontend/common/image_loader/load_network_circular_avatar.dart';
import 'package:cura_frontend/features/community/community_detail_page.dart';
import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event.dart';
import '../../profile/screens/view_profile.dart';
import 'package:flutter/material.dart';

import '../providers/conversation_providers.dart';

class ConversationAppBar extends ConsumerStatefulWidget {
  final String imageURL;
  final String userName;
  final VoidCallback selectDescription;
  const ConversationAppBar(
      {Key? key,
      required this.imageURL,
      required this.userName,
      required this.selectDescription})
      : super(key: key);

  @override
  ConsumerState<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends ConsumerState<ConversationAppBar> {
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

      title: ListTile(
        leading: LoadNetworkCircularAvatar(
          imageURL: widget.imageURL,
          radius: 20,
        ),
        title: Text(
          widget.userName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        // subtitle: widget.event != null || widget.community != null
        //     ? Row(
        //         children: [
        //           const SizedBox(width: 4),
        //           Text(
        //             ref.read(conversationTypeProvider.notifier).state.type ==
        //                     ConversationType.event.type
        //                 ? '${widget.event?.totalMembers} members'
        //                 : ref
        //                             .read(conversationTypeProvider.notifier)
        //                             .state
        //                             .type ==
        //                         ConversationType.community.type
        //                     ? '${widget.community?.totalMembers} members'
        //                     : '',
        //             style: const TextStyle(
        //               // color: Colors.white,
        //               fontSize: 12,
        //             ),
        //           ),
        //         ],
        //       )
        //     : null,
        trailing: const Icon(
          Icons.more_vert,
          color: Colors.black54,
        ),
        onTap: widget.selectDescription,
      ),
    );
  }
}
