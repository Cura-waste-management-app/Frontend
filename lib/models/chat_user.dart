class ChatUser {
  String userName;
  String userID;
  String lastMessage;
  String imgURL; // profile pic
  String time; // last message time
  ChatUser(
      {required this.userName,
      required this.userID,
      required this.lastMessage,
      required this.imgURL,
      required this.time});
}
