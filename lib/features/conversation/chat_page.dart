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
  List<ChatUser> chatUsers = [ ChatUser(
        userName: "Jane Russel",
        userID: "2",
        lastMessage: "Awesome Setup",
        imgURL: "assets/images/female_user.png",
        time: "Now")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          "Conversations",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
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
                    itemCount: chatUsers.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        name: chatUsers[index].userName,
                        chatUserID: chatUsers[index].userID,
                        messageText: chatUsers[index].lastMessage,
                        imageUrl: chatUsers[index].imgURL,
                        time: chatUsers[index].time,
                        isMessageRead:
                            (index == 0 || index == 3) ? true : false,
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
