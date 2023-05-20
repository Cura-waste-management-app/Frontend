import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart' as pwd;
import 'package:sizer/sizer.dart';

import '../../common/debug_print.dart';
import '../../models/chat_user.dart';
import '../../models/user_conversation.dart';
import '../../providers/bottom_nav_bar_provider.dart';
import 'components/conversation_widget.dart';

class ConversationListPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-page';
  const ConversationListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends ConsumerState<ConversationListPage> {
  List<ChatUser> conversationPartners = []; //todo setup value from hive
  // final Map<String, GlobalKey<ConversationWidgetState>> _conversationKeys = {};
  late Box<UserConversation> _messageBox;
  late UserConversation _conversation;
  late bool conversationPartnersLoaded = false;
  late bool messageBoxIntialised = false;
  String filterText = '';
  Future<Box<UserConversation>> _openBoxes() async {
    return await Hive.openBox<UserConversation>(hiveChatBox);
  }

  _fetchConversationPartners() async {
    await ref.read(getConversationPartnersProvider.future);
    _messageBox = await _openBoxes();
    setState(() {
      conversationPartnersLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchConversationPartners();
    ref.read(newChatsProvider);
    ref.read(getUserProvider);
    //todo find place for it
  }

  @override
  void dispose() {
    super.dispose();
    // _messageBox.close();
  }

  @override
  Widget build(BuildContext context) {
    conversationPartners = ref.watch(conversationPartnersProvider);
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
        // actions: [
        //   PopupMenuButton<String>(
        //     position: PopupMenuPosition.under,
        //     padding: EdgeInsets.zero,
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuEntry<String>>[
        //         const PopupMenuItem<String>(
        //           value: 'delete',
        //           child: Text('Delete Conversations'),
        //         ),
        //         const PopupMenuItem<String>(
        //           value: 'settings',
        //           child: Text('Settings'),
        //         ),
        //       ];
        //     },
        //     onSelected: (String value) {
        //       // if (value == 'explore') {
        //       //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //       //     return const JoinCommunity();
        //       //   }));
        //     },
        //     icon: const Icon(Icons.more_vert, color: Colors.black),
        //   )
        // ],
      ),
      body: !conversationPartnersLoaded
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.refresh(newChatsProvider);
                ref.refresh(getConversationPartnersProvider);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
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
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: _messageBox.listenable(),
                      builder: (context, conversationBox, _) {
                        if (conversationPartners.isEmpty) {
                          return conversationPartnersLoaded
                              ? SizedBox(
                                  height: 60.h,
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      Center(
                                        child: Text(
                                          'No conversation partner yet',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const CircularProgressIndicator();
                        }
                        prints("rebuilding conversation list page");
                        var sortedUsers = filteredUsers;
                        // prints(sortedUsers.length);
                        sortedUsers.sort((userA, userB) {
                          var messagesA = conversationBox.get(userA.userId);
                          var messagesB = conversationBox.get(userB.userId);
                          // prints(messagesA.toString());
                          if (messagesA == null) return 1;
                          if (messagesB == null) return -1;
                          if (messagesA.conversations.isNotEmpty &&
                              messagesB.conversations.isNotEmpty) {
                            var createdAtA =
                                messagesA.conversations.first.createdAt ?? 0;
                            var createdAtB =
                                messagesB.conversations.first.createdAt ?? 0;
                            // prints(createdAtA - createdAtB);
                            return createdAtB - createdAtA;
                          }

                          return 0;
                        });

                        return ListView.separated(
                          itemCount: sortedUsers.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final user = sortedUsers[index];
                            final messages = conversationBox.get(user.userId);
                            // prints(user.avatarURL);
                            // prints(
                            //     messages?.conversations.first.toJson()['text']);
                            return ConversationWidget(
                              key: ValueKey(user.userId),
                              name: user.userName,
                              chatUserID: user.userId,
                              messageText: (messages == null ||
                                      messages.conversations.isEmpty)
                                  ? ''
                                  : messages.conversations.first.type !=
                                          MessageType.text
                                      ? messages.conversations.first.type.name
                                      : messages.conversations.first
                                              .toJson()['text'] ??
                                          '',
                              imageUrl: user.avatarURL,
                              time: messages == null ||
                                      messages.conversations.isEmpty
                                  ? 0
                                  : messages.conversations.first.createdAt!,
                              conversationType: user.type!,
                              isMessageRead: true,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        );
                      },
                    ),
                  ],
                ),
              )),
      bottomNavigationBar:
          pwd.Provider.of<BottomNavBarProvider>(context, listen: false)
              .myBottomNavigation,
    );
  }
}
