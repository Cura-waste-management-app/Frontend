import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'components/message_bar.dart';

class ChatDetailPage extends StatefulWidget {
  final String imageURL;
  final String userName;
  final String chatUserID;

  const ChatDetailPage(
      {super.key,
      required this.imageURL,
      required this.userName,
      required this.chatUserID});

  @override
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  static const uid = "1";
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatsNotifier>(context, listen: false).connect();
    Provider.of<ChatsNotifier>(context, listen: false)
        .getUserChats(widget.chatUserID);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
            child: ConversationAppBar(
                imageURL: widget.imageURL, userName: widget.userName)),
      ),
      body: Stack(
        children: <Widget>[
          Consumer<ChatsNotifier>(builder: (context, notifier, child) {
            return ListView.builder(
              itemCount: notifier.userMessages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (notifier.userMessages[index].receiverID == uid
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (notifier.userMessages[index].receiverID == uid
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        notifier.userMessages[index].messageContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                     
                      Provider.of<ChatsNotifier>(context, listen: false)
                          .sendMessage(textController.text, widget.chatUserID,
                              widget.imageURL);
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: MessageBar(),
    );
  }
}
