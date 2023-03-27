import "package:flutter/material.dart";

class DialogType {
  late String type = "";
  static final DialogType community = DialogType(type: "community");
  static final DialogType event = DialogType(type: "event");
  DialogType({required this.type}) {}
}
