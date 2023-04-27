import 'package:cura_frontend/models/conversation_type.dart';

import '../constants.dart';

class ChatUser {
  String userName;
  String userId;
  String? lastMessage;
  String avatarURL; // profile pic
  ConversationType? type;
  num? lastMessageTime =
      DateTime.now().millisecondsSinceEpoch; // last message time
  ChatUser(
      {required this.userName,
      required this.userId,
      this.lastMessage,
      required this.avatarURL,
      this.lastMessageTime});

  ChatUser.fromJson(Map<String, dynamic> json)
      : userName = json['name'],
        userId = json['_id'],
        avatarURL = json['avatarURL'] ?? json['imgURL'] ?? defaultNetworkImage;
}
