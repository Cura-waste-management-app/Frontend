import 'dart:convert';

import 'package:cura_frontend/features/conversation/components/conversation_app_bar.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
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

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  static const uid = "1";

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isKeyboardVisible = false;
  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    scrollController.dispose();
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    ref.read(socketProvider).connect();
  }

  @override
  Widget build(BuildContext context) {
    // getUserChats();
    final oldChats = ref.watch(oldChatsProvider);
    final socket = ref.watch(socketProvider);
    final allMessages = ref.watch(allMessageProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
            child: ConversationAppBar(
                imageURL: widget.imageURL, userName: widget.userName)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              child:
                  // Consumer<ChatsNotifier>(builder: (context, notifier, child) {
                  // return
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SingleChildScrollView(
                          child: oldChats.when(
                        data: (oldChat) {
                          return ListView.builder(
                            itemCount: allMessages.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment:
                                      (allMessages[index].receiverID == uid
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          (allMessages[index].receiverID == uid
                                              ? Colors.grey.shade200
                                              : Colors.blue[200]),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      allMessages[index].messageContent,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) {
                          print(error);
                          return Text(error.toString());
                        },
                      ))
                      // }
                      ),
            ),
          ),
          Container(
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
                    final newMessage = ChatMessage(
                        senderID: uid,
                        receiverID: ref.read(receiverIDProvider),
                        messageContent: textController.text,
                        imgURL: "images",
                        timeStamp: "9:00");
                    ref.read(messageSendProvider(newMessage));
                    textController.clear();
                    final chatMessages = [
                      ...ref.read(allMessageProvider.notifier).state,
                      newMessage
                    ];
                    ref.read(allMessageProvider.notifier).state = chatMessages;
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
        ],
      ),
    );
  }
}
