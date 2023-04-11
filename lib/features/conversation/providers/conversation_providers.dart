import 'dart:convert';

import 'package:cura_frontend/models/user_conversation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../models/conversation.dart';
import 'chat_providers.dart';

final newChatsProvider = FutureProvider.autoDispose<void>((ref) async {
  final userId = ref.read(userIDProvider);
  print("in new chats");

  try {
    final response = await http.get(Uri.parse(
        "${ref.read(localHttpIpProvider)}userChats/${ref.read(userIDProvider)}"));

    final newMessages = (jsonDecode(response.body) as List)
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
    var chatBox = await Hive.openBox<UserConversation>('chat');
    for (int i = 0; i < newMessages.length; i++) {
      var id = newMessages[i].receiverId == userId
          ? newMessages[i].senderId
          : newMessages[i].receiverId;
      var messages = chatBox.get(id, defaultValue: UserConversation());
      if (i == 0) messages?.conversations.clear();
      print(newMessages[i].content.toString());
      messages?.conversations.add(newMessages[i].content);
      chatBox.put(id, messages!);
    }
  } catch (e) {
    print(e);
  }
});
