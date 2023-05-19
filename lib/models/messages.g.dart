import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hive/hive.dart';

class MessageTypeAdapter extends TypeAdapter<Message> {
  @override
  Message read(BinaryReader reader) {
    final data = reader.read();
    var dataAsString = Map<String, dynamic>.from(data);
    dataAsString['author'] = Map<String, dynamic>.from(dataAsString['author']);
    return Message.fromJson(dataAsString);
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    var data = obj.toJson();
    data = Map<String, dynamic>.from(data);
    data['author'] = Map<String, dynamic>.from(data['author']);
    writer.write(data);
  }

  @override
  int get typeId => 3;
}
