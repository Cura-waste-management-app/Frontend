import 'package:flutter/material.dart';

class CommunityCard extends StatefulWidget {
  final String communityName;
  final String communityLocation;
  final String numberOfMembers;
  const CommunityCard(
      {Key? key,
      required this.communityName,
      required this.communityLocation,
      required this.numberOfMembers})
      : super(key: key);

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.communityName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.communityLocation,
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ]),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.numberOfMembers,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )),
              ),
              Icon(Icons.group)
            ],
          ),
        ),
      ),
    );
  }
}
