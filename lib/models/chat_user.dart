class ChatUser {
  String userName;
  String userId;
  String? lastMessage;
  String avatarURL; // profile pic
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
        avatarURL = json['avatarURL'];
}
