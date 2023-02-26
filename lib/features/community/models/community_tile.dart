import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/community.dart';
import '../../../models/conversation_type.dart';
import '../../../providers/chat_provider.dart';
import '../community_home.dart';

class CommunityTile extends StatefulWidget {
  final Community community;
  const CommunityTile({required this.community});
  @override
  // ignore: library_private_types_in_public_api
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider(
              create: (context) => ChatsNotifier(),
              child: CommunityHome(community: widget.community));
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          )),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.community.imgURL),
                      maxRadius: 30,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.community.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${widget.community.totalMembers}  Members",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // const Divider(
                            //     color: Colors.black
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
