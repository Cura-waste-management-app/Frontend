import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event.dart';
import '../../profile/screens/view_profile.dart';
import 'package:flutter/material.dart';

class ConversationAppBar extends ConsumerStatefulWidget {
  final String imageURL;
  final String userName;
  final Event? event;
  const ConversationAppBar(
      {Key? key, required this.imageURL, required this.userName, this.event})
      : super(key: key);

  @override
  ConsumerState<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends ConsumerState<ConversationAppBar> {
  void selectPerson(BuildContext ctx) {
    ConversationType conversationType =
        ref.read(conversationTypeProvider.notifier).state;
    print(ref.read(conversationTypeProvider.notifier).state.type);
    if (conversationType.type == ConversationType.user.type)
      Navigator.of(ctx).pushNamed(ViewProfile.routeName, arguments: {
        'name': widget.userName,
      });
    else if (conversationType.type == ConversationType.event.type) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EventDetailPage(event: widget.event!);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 2,
          ),
          InkWell(
            onTap: () => selectPerson(context),
            child: CircleAvatar(
              backgroundImage: AssetImage(widget.imageURL),
              maxRadius: 20,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.report,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
