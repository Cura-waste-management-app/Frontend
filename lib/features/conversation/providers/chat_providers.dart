import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../models/chat_message.dart';
import '../../../models/conversation_type.dart';

final receiverIDProvider = StateProvider<String>((ref) {
  return '2';
});
final userIDProvider = StateProvider<String>((ref) {
  return '00000001c2e6895225b91f71';
});
final conversationTypeProvider = StateProvider<ConversationType>((ref) {
  return ConversationType.user;
});

final localSocketIpProvider =
    Provider<String>((ref) => 'ws://192.168.25.112:8080/');
final socketIpProvider =
    Provider<String>((ref) => 'wss://backend-production-e143.up.railway.app/');
final localHttpIpProvider =
    Provider<String>((ref) => 'http://192.168.25.112:8080/');
final httpIpProvider = Provider<String>(
    (ref) => 'https://backend-production-e143.up.railway.app/');

// String localSocketIP = 'ws://192.168.231.112:8080/';
// String socketIP = 'wss://backend-production-e143.up.railway.app/';
// String localHttpIP = 'http://192.168.231.112:8080/';
// String httpIP = 'https://backend-production-e143.up.railway.app/';

final socketProvider = Provider<Socket>((ref) {
  final socket = io(ref.read(localSocketIpProvider), <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  if (ref.read(conversationTypeProvider.notifier).state.type ==
      ConversationType.community.type) {
    print(ref.read(receiverIDProvider));
    socket.on('chat/${ref.read(receiverIDProvider)}', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      // print("message received" + data['messageContent']);
      var message = (ChatMessage(
          senderID: data['senderID'] as String,
          receiverID: data['receiverID'] as String,
          messageContent: data['messageContent'] as String,
          imgURL: data['imgURL'] as String,
          timeStamp: data['timeStamp'] as String));
      // print(message);
      if (message.senderID != ref.read(userIDProvider)) {
        final messages = ref.read(allMessageProvider.notifier).state;
        ref.read(allMessageProvider.notifier).state = [...messages, message];
      }
    });
  } else {
    socket.on('chat/${ref.read(userIDProvider)}', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      // print("message received" + data['messageContent']);
      var message = (ChatMessage(
          senderID: data['senderID'] as String,
          receiverID: data['receiverID'] as String,
          messageContent: data['messageContent'] as String,
          imgURL: data['imgURL'] as String,
          timeStamp: data['timeStamp'] as String));
      // print(message);
      if (message.senderID == ref.read(receiverIDProvider)) {
        final messages = ref.read(allMessageProvider.notifier).state;
        ref.read(allMessageProvider.notifier).state = [...messages, message];
      }
    });
  }
  return socket;
});

final messageTextProvider = StateProvider<ChatMessage>((ref) {
  return ChatMessage(
      senderID: "1",
      receiverID: "2",
      messageContent: "12",
      imgURL: "",
      timeStamp: "9:00");
});

final oldChatsProvider =
    FutureProvider.autoDispose<List<ChatMessage>>((ref) async {
  final chatUserID = ref.read(receiverIDProvider);
  print(
      "${ref.read(localHttpIpProvider)}userChats/$chatUserID"); // get chatUserID from the chatUserIDProvider
  final response = await http
      .get(Uri.parse("${ref.read(localHttpIpProvider)}userChats/$chatUserID"));
  if (response.statusCode >= 400 && response.statusCode <= 599) return [];
  final list = json.decode(response.body) as List<dynamic>;
  List<ChatMessage> allMessages = List<ChatMessage>.from(
      list.map((obj) => ChatMessage.fromJson(obj)).toList());
  ref.read(allMessageProvider.notifier).state = allMessages;
  return allMessages;
});

final messageSendProvider = FutureProvider.autoDispose
    .family<void, ChatMessage>((ref, messageText) async {
  var message = {
    'receiverID': messageText.receiverID,
    'senderID': messageText.senderID,
    'messageContent': messageText.messageContent,
    'imgURL': messageText.imgURL,
    'timeStamp': messageText.timeStamp
  };
  // print(ref.read(socketProvider).connected);
  ref.read(socketProvider).emit('chat', message);
  await http.post(
    Uri.parse("${ref.read(localHttpIpProvider)}userChats/addMessage"),
    body: message,
  );
});

final allMessageProvider = StateProvider<List<ChatMessage>>((ref) => []);
