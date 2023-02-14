class ChatMessage {
  String senderID;
  String receiverID;
  String messageContent;
  String imgURL;
  String timeStamp;
  ChatMessage(
      {required this.senderID,
      required this.receiverID,
      required this.messageContent,
      required this.imgURL,
      required this.timeStamp});
      
  ChatMessage.fromJson(Map<String, dynamic> jsonObj)
      : senderID = jsonObj['senderID'],
        receiverID = jsonObj['receiverID'],
        messageContent = jsonObj['messageContent'],
        imgURL = jsonObj['imgURL'],
        timeStamp = jsonObj['timeStamp'];
}
