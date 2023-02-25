import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../models/chat_message.dart';

final chatUserIDProvider = StateProvider<String>((ref) {
  return '2';
});
final userIDProvider = StateProvider<String>((ref) {
  return '1';
});

final socketProvider = Provider<Socket>((ref) {
  final socket = io('ws://192.168.80.112:3000/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  socket.on('chat/${ref.read(userIDProvider)}', (jsonData) {
    Map<String, dynamic> data = json.decode(jsonData);
    // print("message received" + data['messageContent']);
    var message = (ChatMessage(
        senderID: data['senderID'] as String,
        receiverID: data['receiverID'] as String,
        messageContent: data['messageContent'] as String,
        imgURL: data['imgURL'] as String,
        timeStamp: data['timeStamp'] as String));
    final messages = ref.read(allMessageProvider.notifier).state;
    ref.read(allMessageProvider.notifier).state = [...messages, message];
  });
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

final userChatsProvider =
    FutureProvider.autoDispose<List<ChatMessage>>((ref) async {
  final chatUserID = ref
      .watch(chatUserIDProvider); // get chatUserID from the chatUserIDProvider
  final response = await http
      .get(Uri.parse("http://192.168.80.112:3000/userChats/$chatUserID"));
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
    Uri.parse("http://192.168.80.112:3000/userChats/addMessage"),
    body: message,
  );
});

final allMessageProvider = StateProvider<List<ChatMessage>>((ref) => []);
