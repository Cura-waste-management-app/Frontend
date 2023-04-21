import 'package:cura_frontend/models/community_type_widget.dart';
import 'package:flutter/material.dart';

class TagCategory extends StatefulWidget {
  final IconData icon;
  final CommunityType category;
  const TagCategory({Key? key, required this.icon, required this.category})
      : super(key: key);

  @override
  State<TagCategory> createState() => _TagCategoryState();
}

class _TagCategoryState extends State<TagCategory> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      labelStyle: TextStyle(fontSize: 11),
      avatar: CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        child: Icon(widget.icon, size: 14),
      ),
      label: Text(widget.category.type),
    );
  }
}
