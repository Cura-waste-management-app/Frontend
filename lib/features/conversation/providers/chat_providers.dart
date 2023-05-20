import 'dart:core';

// final localSocketIpProvider = Provider<String>((ref) => 'ws://$serverIp/');
// final socketIpProvider =
//     Provider<String>((ref) => 'wss://backend-production-e143.up.railway.app/');
// final localHttpIpProvider = Provider<String>((ref) => 'http://$serverIp/');
// final httpIpProvider = Provider<String>(
//     (ref) => 'https://backend-production-e143.up.railway.app/');
//
// final socketProvider = Provider<Socket>((ref) {
//   final socket = io(ref.read(localSocketIpProvider), <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': true,
//   });
//
//   if (ref.read(conversationTypeProvider.notifier).state.type !=
//       ConversationType.user.type) {
//     prints(ref.read(receiverIDProvider));
//     socket.on('chat/${ref.read(receiverIDProvider)}', (response) {
//       // Map<String, dynamic> data = json.decode(response);
//       // prints("message received" + data['messageContent']);
//       // var message = (ChatMessage(
//       //     senderID: data['senderID'] as String,
//       //     receiverID: data['receiverID'] as String,
//       //     messageContent: data['messageContent'] as String,
//       //     imgURL: data['imgURL'] as String,
//       //     timeStamp: data['timeStamp'] as String));
//       final message = (jsonDecode(response.body))
//           .map((e) => types.Message.fromJson(
//               jsonDecode(e['content']) as Map<String, dynamic>))
//           .toList();
//       if (message.senderId != ref.read(userIDProvider)) {
//         // final messages = ref.read(allMessageProvider.notifier).state;
//         // ref.read(allMessageProvider.notifier).state = [...messages, message];
//
//       }
//     });
//   } else {
//     socket.on('chat/${ref.read(userIDProvider)}', (jsonData) {
//       Map<String, dynamic> data = json.decode(jsonData);
//       // prints("message received" + data['messageContent']);
//       var message = (ChatMessage(
//           senderID: data['senderID'] as String,
//           receiverID: data['receiverID'] as String,
//           messageContent: data['messageContent'] as String,
//           imgURL: data['imgURL'] as String,
//           timeStamp: data['timeStamp'] as String));
//       // prints(message);
//       if (message.senderID == ref.read(receiverIDProvider)) {
//         final messages = ref.read(allMessageProvider.notifier).state;
//         ref.read(allMessageProvider.notifier).state = [...messages, message];
//       }
//     });
//   }
//   return socket;
// });
//
// final messageTextProvider = StateProvider<ChatMessage>((ref) {
//   return ChatMessage(
//       senderID: "1",
//       receiverID: "2",
//       messageContent: "12",
//       imgURL: "",
//       timeStamp: "9:00");
// });
//
// final oldChatsProvider =
//     FutureProvider.autoDispose<List<ChatMessage>>((ref) async {
//   final chatUserID = ref.read(receiverIDProvider);
//   prints("$getUserChatsAPI/$chatUserID");
//   // get chatUserID from the chatUserIDProvider
//
//   try {
//     final response =
//         await http.get(Uri.parse("$getUserChatsAPI/$chatUserID"));
//     if (response.statusCode >= 400 && response.statusCode <= 599) return [];
//     prints(response.body);
//     final list = json.decode(response.body) as List<dynamic>;
//     List<ChatMessage> allMessages = List<ChatMessage>.from(
//         list.map((obj) => ChatMessage.fromJson(obj)).toList());
//     ref.read(allMessageProvider.notifier).state = allMessages;
//     return allMessages;
//   } catch (e) {
//     prints("caught in error");
//   }
//   List<ChatMessage> message = [];
//   return message;
// });
//
// final messageSendProvider = FutureProvider.autoDispose
//     .family<void, ChatMessage>((ref, messageText) async {
//   var message = {
//     'receiverID': messageText.receiverID,
//     'senderID': messageText.senderID,
//     'messageContent': messageText.messageContent,
//     'imgURL': messageText.imgURL,
//     'timeStamp': messageText.timeStamp
//   };
//   // prints(ref.read(socketProvider).connected);
//   ref.read(socketProvider).emit('chat', message);
//   await http.post(
//     Uri.parse(addUserMessageAPI),
//     body: message,
//   );
// });
//
// final allMessageProvider = StateProvider<List<ChatMessage>>((ref) => []);
