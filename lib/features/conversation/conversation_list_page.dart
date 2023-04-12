import 'dart:convert';

import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../../common/bottom_nav_bar.dart';
import '../../models/chat_user.dart';
import '../../models/user_conversation.dart';
import '../../models/user_conversation.dart';
import 'components/conversationList.dart';
import 'package:http/http.dart' as http;

class ConversationListPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-page';
  const ConversationListPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends ConsumerState<ConversationListPage> {
  List<ChatUser> conversationPartners = []; //todo setup value from hive
  late Box<UserConversation> _messageBox;
  late UserConversation _conversation;

  String filterText = '';
  Future<void> _openBoxes() async {
    _messageBox = await Hive.openBox<UserConversation>('chat');

    // _chatBox = await Hive.openBox<UserConversation>('chat');
  }

  Future<void> _getConversationPartners() async {
    var response = await http.get(Uri.parse(
        "${ref.read(localHttpIpProvider)}userChats/get-conversation-partners/${ref.read(userIDProvider)}"));

    if (response.statusCode == 200) {
      //todo: check status code
      List<ChatUser> chatUserList =
          (jsonDecode(response.body)['usersList'] as List)
              .map((user) => ChatUser.fromJson(user as Map<String, dynamic>))
              .toList();
      print(chatUserList.length);
      setState(() {
        conversationPartners = chatUserList;
      });
    }
  }

  @override
  void initState() {
    // ref.read(newChatsProvider);
    // _openBoxes();
    _getConversationPartners();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = conversationPartners.where((user) {
      final nameLower = user.userName.toLowerCase();
      final filterLower = filterText.toLowerCase();
      return nameLower.contains(filterLower);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        leadingWidth: 0,
        elevation: 1,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
        leading: Container(),
        title: const Text(
          "Conversations",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete Conversations'),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
              ];
            },
            onSelected: (String value) {
              // if (value == 'explore') {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return const JoinCommunity();
              //   }));
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filterText = value;
                      });
                    },
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
            FutureBuilder(
                future: _openBoxes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ValueListenableBuilder(
                      valueListenable: _messageBox.listenable(),
                      builder: (context, conversationBox, _) {
                        if (filteredUsers.isEmpty) {
                          // handle the case where the conversation is null
                          return const CircularProgressIndicator();
                        }

                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            final messages = conversationBox.get(user.userId);
                            print(user.avatarURL);
                            return ConversationList(
                              name: user.userName,
                              chatUserID: user.userId,
                              messageText: messages == null ||
                                      messages.conversations.isEmpty
                                  ? ''
                                  : messages.conversations.first
                                      .toJson()['text'],
                              imageUrl: user.avatarURL,
                              time: messages == null ||
                                      messages.conversations.isEmpty
                                  ? 0
                                  : messages.conversations.first.createdAt!,
                              isMessageRead: (index == 0 || index == 3),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(index: 3),
    );
  }
}
