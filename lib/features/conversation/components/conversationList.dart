import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../../../common/image_loader/load_circular_avatar.dart';
import '../../../models/conversation_type.dart';
import '../chat_detail_page.dart';
import '../conversation_page.dart';
import '../providers/chat_providers.dart';

class ConversationList extends ConsumerStatefulWidget {
  final String name;
  final String chatUserID;
  final String messageText;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  const ConversationList(
      {super.key,
      required this.name,
      required this.chatUserID,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead});
  @override
  // ignore: library_private_types_in_public_api
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends ConsumerState<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//todo api for chatuser
        ref.read(receiverIDProvider.notifier).state = widget.chatUserID;
        ref.read(conversationTypeProvider.notifier).state =
            ConversationType.user;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ConversationPage(
            imageURL: widget.imageUrl,
            chatRecipientName: widget.name,
            receiverID: widget.chatUserID,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  LoadCircularAvatar(
                    radius: 30,
                    imageURL: widget.imageUrl,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          // const Divider(
                          //     color: Colors.black
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
