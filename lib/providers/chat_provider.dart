// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/models/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

class ChatsNotifier extends ChangeNotifier {
  var socket = io('http://192.168.1.6:3001/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  List<ChatMessage> _messages = [];
  static const uid = "1";
  get userMessages => _messages;

  void getUserChats(String chatUserID) async {
    print("get user chats");
    // final queryParameters = {'chatUserID': chatUserID};
    // final uri =
    //     Uri.http('http://192.168.1.2:3000/', 'userChats/', queryParameters);
    var response =
        await http.get(Uri.parse("http://192.168.1.6:3001/userChats/$chatUserID"));
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
      print("message received");
    
      _messages.add(ChatMessage(
          senderID: data['senderID'] as String,
          receiverID: data['receiverID'] as String,
          messageContent: data['messageContent'] as String,
          imgURL: data['imgURL'] as String,
          timeStamp: data['timeStamp'] as String));
           print(_messages.length);
    });
    notifyListeners();
  }

  void sendMessage(String text, String receiverID, String imgURL) {
    _messages.add(ChatMessage(
        senderID: uid,
        receiverID: receiverID,
        messageContent: text,
        imgURL: imgURL,
        timeStamp: "9.00 PM"));
    print("send$text");
    socket.emit(
      'chat',
      {
        'receiverID': receiverID,
        'senderID': uid,
        'content': text,
        'imgURL': imgURL,
        'timeStamp': "9.00 PM"
      }
    );
    // socket.emit(
    //     'chat',
    //     {
    //       'senderID': '2',
    //       'receiverID': '1',
    //       'messageContent': 'ok',
    //       'imgURL': '',
    //       'timeStamp': '9.00 pm'
    //     });
    notifyListeners();
  }
}
