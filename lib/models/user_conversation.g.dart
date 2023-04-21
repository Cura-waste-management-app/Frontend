// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserConversationAdapter extends TypeAdapter<UserConversation> {
  @override
  final int typeId = 2;

  @override
  UserConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserConversation()
      ..conversations = (fields[0] as List).cast<Message>();
  }

  @override
  void write(BinaryWriter writer, UserConversation obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.conversations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
