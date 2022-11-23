import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:flutter/material.dart';

import 'components/message_bar.dart';

class ChatDetailPage extends StatefulWidget{

  final String imageURL;
  final String userName;

  const ChatDetailPage({super.key, required this.imageURL, required this.userName});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child:ConversationAppBar(imageURL: widget.imageURL,userName: widget.userName)
        ),
      ),
      body: const MessageBar()
    );
  }
}