import "package:flutter/material.dart";

class CommunityDescription extends StatefulWidget {
  final String commmunityId;
  const CommunityDescription({Key? key, required this.commmunityId})
      : super(key: key);

  @override
  State<CommunityDescription> createState() => _CommunityDescriptionState();
}

class _CommunityDescriptionState extends State<CommunityDescription> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("nothing here"));
  }
}
