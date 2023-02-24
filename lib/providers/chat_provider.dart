// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/models/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

class ChatsNotifier extends ChangeNotifier {
  var socket = io('wss://backend-production-e143.up.railway.app/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  List<ChatMessage> _messages = [];
  static const uid = "1";
  get userMessages => _messages;

  void getUserChats(String chatUserID) async {
    print("get user chats");
    var response = await http.get(Uri.parse(
        "https://backend-production-e143.up.railway.app/userChats/$chatUserID"));
    print(json.decode(response.body));
    Iterable list = json.decode(response.body);
    _messages =
        List<ChatMessage>.from(list.map((obj) => ChatMessage.fromJson(obj)));
    notifyListeners();
  }

  void connect() {
    print("in connect");
    socket.connect();
    socket.on("chat/$uid", (jsonData) {
      
      Map<String, dynamic> data = json.decode(jsonData);
      // ignore: prefer_interpolation_to_compose_strings
      print("message received" + data['messageContent']);

      _messages.add(ChatMessage(
          senderID: data['senderID'] as String,
          receiverID: data['receiverID'] as String,
          messageContent: data['messageContent'] as String,
          imgURL: data['imgURL'] as String,
          timeStamp: data['timeStamp'] as String));

      notifyListeners();
    });
  }

  void sendMessage(String text, String receiverID, String imgURL) async {
    _messages.add(ChatMessage(
        senderID: uid,
        receiverID: receiverID,
        messageContent: text,
        imgURL: imgURL,
        timeStamp: "9.00 PM"));
    print("send$text");
    var message = {
      'receiverID': receiverID,
      'senderID': uid,
      'messageContent': text,
      'imgURL': imgURL,
      'timeStamp': "9.00 PM"
    };
    print(socket.connected);
    socket.emit('chat', message);
    notifyListeners();

    await http.post(
        Uri.parse(
            "https://backend-production-e143.up.railway.app/userChats/addMessage"),
        body: message);
  }
}
