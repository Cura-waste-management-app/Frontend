import 'package:flutter/material.dart';

class CommunityType extends StatefulWidget {
  final String type;
  final IconData icon;
  const CommunityType({Key? key, required this.type, required this.icon})
      : super(key: key);

  @override
  State<CommunityType> createState() => _CommunityTypeState();
}

class _CommunityTypeState extends State<CommunityType> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Icon(widget.icon),
      ),
      SizedBox(
        height: 6,
      ),
      Container(child: Text(widget.type))
    ]);
  }
}
