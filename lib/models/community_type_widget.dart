import "package:flutter/material.dart";

class CommunityType {
  late String type = "";
  static final CommunityType food = CommunityType(type: "Food");
  static final CommunityType cloth = CommunityType(type: "Cloth");
  static final CommunityType furniture = CommunityType(type: "Furniture");
  static final CommunityType other = CommunityType(type: "Other");
  static final CommunityType all = CommunityType(type: "All");
  CommunityType({required this.type}) {}
}
