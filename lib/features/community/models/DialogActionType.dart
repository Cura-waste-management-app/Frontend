import "package:flutter/material.dart";

class DialogActionType {
  late String type = "";
  static final DialogActionType delete = DialogActionType(type: "delete");
  static final DialogActionType leave = DialogActionType(type: "leave");
  DialogActionType({required this.type}) {}
}
