import "package:flutter/material.dart";

class EntityModifier {
  late String type = "";
  static final EntityModifier create = EntityModifier(type: "Create");
  static final EntityModifier update = EntityModifier(type: "Update");
  EntityModifier({required this.type}) {}
}
