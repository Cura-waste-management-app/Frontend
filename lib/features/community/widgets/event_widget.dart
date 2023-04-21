import 'dart:math';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/chat_detail_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/image_loader/load_circular_avatar.dart';
import '../../../constants.dart';
import '../../../models/event.dart';
import '../../conversation/providers/conversation_providers.dart';
import 'package:http/http.dart' as http;

import '../Util/util.dart';

class EventWidget extends ConsumerWidget {
  final Event event;
  final bool joined;
  final VoidCallback joinevent;

  EventWidget(
      {required this.event, required this.joined, required this.joinevent});

  @override
  Widget build(BuildContext context, ref) {
    List<String> firstNames = [
      'Emma',
      'Olivia',
      'John',
      'Simon',
      'Sophia',
      'Charlotte',
      'Andrew',
      'Amelia'
    ];

    List<String> lastNames = [
      'Smith',
      'Johnson',
      'Williams',
      'Jones',
      'Brown',
      'Garcia',
      'Miller',
      'Davis'
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(8),
          getProportionateScreenHeight(2),
          getProportionateScreenWidth(8),
          getProportionateScreenHeight(8)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EventDetailPage(
              event: event,
              isMember: joined,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(getProportionateScreenHeight(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(16),
                getProportionateScreenHeight(8),
                getProportionateScreenWidth(16),
                getProportionateScreenHeight(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadCircularAvatar(
                          radius: 20,
                          imageURL: event.adminAvatarURL ?? event.imgURL,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          // event.adminId,
                          event.adminName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatTimeAgo(event.postTime),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(2)),
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Text(
                      event.location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(2)),
                Divider(
                    height: getProportionateScreenHeight(4),
                    color: Colors.black12),
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${event.totalMembers} members',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(5)),
                      !joined
                          ? SizedBox(
                              width: getProportionateScreenWidth(60),
                              height: getProportionateScreenHeight(30),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Join Event'),
                                          content: const Text(
                                              'Are you sure you want to join this event?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              onPressed: joinevent,
                                              child: Text('Join'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        getProportionateScreenHeight(16)),
                                  ),
                                  primary: Colors.green,
                                ),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ))
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
