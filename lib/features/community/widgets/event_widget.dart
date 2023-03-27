import 'dart:math';

import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/chat_detail_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event.dart';

class EventWidget extends ConsumerWidget {
  final Event event;
  final bool joined;
  EventWidget({required this.event, required this.joined});

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
    joinEvent() async {
      var eventDetail = {
        "event_id": event.id,
        "user_id": ref.read(userIDProvider)
      };
      print(eventDetail);
      ref.read(conversationTypeProvider.notifier).state =
          ConversationType.event;
      try {
        // await http.post(
        //     Uri.parse("${ref.read(localHttpIpProvider)}event/joinevent"),
        //     body: eventDetail);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EventDetailPage(event: event);
        }));
      } catch (e) {
        print(e);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: GestureDetector(
        onTap: () {
          ref.read(receiverIDProvider.notifier).state = event.id!;
          ref.read(conversationTypeProvider.notifier).state =
              ConversationType.event;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatDetailPage(
              imageURL: "assets/images/male_user.png",
              chatRecipientName: event.name,
              receiverID: event.id!,
              event: event,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/male_user.png'),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          // event.adminId,
                          firstNames[Random().nextInt(7)] +
                              ' ' +
                              lastNames[Random().nextInt(7)],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          event.timestamp,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Divider(height: 4, color: Colors.black12),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${event.totalMembers} members',
                        style: TextStyle(fontSize: 12),
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
                      const SizedBox(width: 5),
                      !joined
                          ? SizedBox(
                              width: 60,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  joinEvent();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
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
