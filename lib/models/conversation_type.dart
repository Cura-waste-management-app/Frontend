import "package:flutter/material.dart";

class ConversationType {
  String type = "";
  static final ConversationType user = ConversationType("user");
  static final ConversationType community = ConversationType("community");
  ConversationType(String type) {
    type = type;
  }
}
