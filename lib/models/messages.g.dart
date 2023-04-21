import 'package:hive/hive.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class MessageTypeAdapter extends TypeAdapter<Message> {
  @override
  Message read(BinaryReader reader) {
    final data = reader.readMap();
    final dataAsString = Map<String, dynamic>.from(data);
    return Message.fromJson(dataAsString);
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    final data = Map<String, dynamic>.from(obj.toJson());
    data['author'] = Map<String, dynamic>.from(data['author']);
    writer.writeMap(data);
  }

  @override
  int get typeId => 3;
}
