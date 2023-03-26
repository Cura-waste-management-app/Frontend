import 'package:flutter/material.dart';
import '../../common/bottom_nav_bar.dart';
import '../../models/chat_user.dart';
import 'components/conversationList.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat-page';
  const ChatPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUser> chatUsers = [
    ChatUser(
        userName: "Jane Russel",
        userID: "2",
        lastMessage: "Awesome Setup",
        imgURL: "assets/images/female_user.png",
        time: "Now"),
    ChatUser(
        userName: "Glady's Murphy",
        userID: "3",
        lastMessage: "That's Great",
        imgURL: "assets/images/female_user.png",
        time: "Yesterday"),
    ChatUser(
        userName: "Jorge Henry",
        userID: "4",
        lastMessage: "Hey where are you?",
        imgURL: "assets/images/male_user.png",
        time: "31 Mar"),
    ChatUser(
        userName: "Philip Fox",
        userID: "5",
        lastMessage: "Busy! Call me in 20 mins",
        imgURL: "assets/images/male_user.png",
        time: "28 Mar"),
    ChatUser(
        userName: "Debra Hawkins",
        userID: "6",
        lastMessage: "Thankyou, It's awesome",
        imgURL: "assets/images/female_user.png",
        time: "23 Mar"),
  ];

  String filterText = '';

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
            icon: const Icon(Icons.more_vert),
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
            ListView.builder(
              itemCount: filteredUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ConversationList(
                  name: user.userName,
                  chatUserID: user.userID,
                  messageText: user.lastMessage,
                  imageUrl: user.imgURL,
                  time: user.time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
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
