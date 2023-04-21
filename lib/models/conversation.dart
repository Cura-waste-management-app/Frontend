import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:hive/hive.dart';

class Conversation {
  // @HiveField(0)
  String id;
  // @HiveField(1)
  String senderId;
  // @HiveField(2)
  String receiverId;
  // @HiveField(3)
  Message content;
  // @HiveField(4)
  num createdAt;
  Conversation(
      {required this.senderId,
      required this.receiverId,
      required this.content,
      required this.createdAt,
      required this.id});

  Conversation.fromJson(Map<String, dynamic> jsonObj)
      : senderId = jsonObj['senderId'],
        receiverId = jsonObj['receiverId'],
        content = Message.fromJson(jsonDecode(jsonObj['content'])),
        createdAt = jsonObj['createdAt'],
        id = jsonObj['_id'];
}
