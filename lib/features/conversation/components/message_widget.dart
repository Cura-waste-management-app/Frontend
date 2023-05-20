import 'package:flutter/material.dart';

import '../../../models/chat_message.dart';
import '../../../common/debug_print.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key, required this.message}) : super(key: key);
  final ChatMessage message;
  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.message.senderID.substring(9),
            style: const TextStyle(fontSize: 9)),
        Text(
          widget.message.messageContent,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
