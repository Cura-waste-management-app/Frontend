import "package:flutter/material.dart";

class ConversationType {
  late String type = "";
  static final ConversationType user = ConversationType(type: "user");
  static final ConversationType community = ConversationType(type: "community");
  static final ConversationType event = ConversationType(type: "event");
  ConversationType({required this.type}) {}
}
