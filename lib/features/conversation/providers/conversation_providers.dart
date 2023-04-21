import 'dart:convert';
import 'dart:io';

import 'package:cura_frontend/models/chat_user.dart';
import 'package:cura_frontend/models/user.dart';
import 'package:cura_frontend/models/user_conversation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socket_io_client/socket_io_client.dart';

import '../../../models/chat_message.dart';
import '../../../models/conversation.dart';
import '../../../models/conversation_type.dart';
import 'chat_providers.dart';

//todo handle when user will be in conversation
final receiverIDProvider = StateProvider<String>((ref) {
  return '000000023c695a9a651a5344';
});
final userIDProvider = StateProvider<String>((ref) {
  return '00000001c2e6895225b91f71';
});
final conversationTypeProvider = StateProvider<ConversationType>((ref) {
  return ConversationType.user;
});
//todo: handle chatUser
final userProvider = StateProvider<ChatUser>((ref) {
  return ChatUser(
      userName: 'userName', userId: 'userId', avatarURL: 'avatarURL');
});

final getUserProvider = FutureProvider.autoDispose<void>((ref) async {
  final response = await http.get(Uri.parse(
      "${ref.read(localHttpIpProvider)}user/fetch/${ref.read(userIDProvider)}"));
  ChatUser user = ChatUser.fromJson(jsonDecode(response.body));
  ref.read(userProvider.notifier).state = user;
  return;
});

final newChatsProvider = FutureProvider.autoDispose<void>((ref) async {
  final userId = ref.read(userIDProvider);
  print("in new chats");
  //todo : try to optimize it
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

final conversationSocketProvider = Provider<Socket>((ref) {
  final socket = io(ref.read(localSocketIpProvider), <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  final userId = ref.read(userIDProvider);
  socket.on('chat/${ref.read(userIDProvider)}', (jsonData) async {
    //handling data
    Map<String, dynamic> data = json.decode(jsonData);
    final message = Conversation.fromJson(data);
    var chatBox = await Hive.openBox<UserConversation>('chat');
    var id =
        message.receiverId == userId ? message.senderId : message.receiverId;
    var messages = chatBox.get(id, defaultValue: UserConversation());
    print(message.content.toString());
    messages?.conversations.insertAll(0, [message.content]);
    chatBox.put(id, messages!);
  });
  return socket;
});

final conversationEmitSocketProvider = Provider<Socket>((ref) {
  final socket = io(ref.read(localSocketIpProvider), <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  return socket;
});
//todo unique event, community name