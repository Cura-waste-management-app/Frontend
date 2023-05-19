import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hive/hive.dart';

//
part 'user_conversation.g.dart';

@HiveType(typeId: 2)
class UserConversation {
  @HiveField(0)
  late List<Message> conversations = [];
}
