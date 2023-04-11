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

class ConversationListPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-page';
  const ConversationListPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends ConsumerState<ConversationListPage> {
  List<ChatUser> chatUsers = [
    ChatUser(
        userName: "Jane Russel",
        userID: "000000023c695a9a651a5344",
        lastMessage: "Awesome Setup",
        imgURL: "assets/images/female_user.png",
        time: "Now"),
    ChatUser(
        userName: "Glady's Murphy",
        userID: "000000023c695a9a651a5344",
        lastMessage: "That's Great",
        imgURL: "assets/images/female_user.png",
        time: "Yesterday"),
    ChatUser(
        userName: "Jorge Henry",
        userID: "000000023c695a9a651a5344",
        lastMessage: "Hey where are you?",
        imgURL: "assets/images/male_user.png",
        time: "22 Mar"),
    ChatUser(
        userName: "Philip Fox",
        userID: "000000023c695a9a651a5344",
        lastMessage: "Busy! Call me in 20 mins",
        imgURL: "assets/images/male_user.png",
        time: "21 Mar"),
    ChatUser(
        userName: "Debra Hawkins",
        userID: "000000023c695a9a651a5344",
        lastMessage: "Thankyou, It's awesome",
        imgURL: "assets/images/female_user.png",
        time: "19 Mar"),
  ];
  late Box<UserConversation> _messageBox;
  late UserConversation _conversation;

  String filterText = '';
  Future<void> _openBoxes() async {
    _messageBox = await Hive.openBox<UserConversation>('chat');
    // _chatBox = await Hive.openBox<UserConversation>('chat');
  }

  @override
  void initState() {
    // ref.read(newChatsProvider);
    _openBoxes();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = chatUsers.where((user) {
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
        titleTextStyle: TextStyle(color: Colors.black),
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
                // SafeArea(
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.only(left: 16, right: 16, top: 10),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: const <Widget>[
                //         Text(
                //           "Conversations",
                //           style: TextStyle(
                //               fontSize: 26, fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
            ValueListenableBuilder(
              valueListenable: _messageBox.listenable(),
              builder: (context, conversation, _) {
                if (conversation == null) {
                  // handle the case where the conversation is null
                  return Container();
                }

                final messages = _messageBox.get(ref.read(receiverIDProvider));
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];

                    return ConversationList(
                      name: user.userName,
                      chatUserID: user.userID,
                      messageText: 'text',
                      imageUrl: user.imgURL,
                      time: user.time,
                      isMessageRead: (index == 0 || index == 3),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(index: 3),
    );
  }
}
