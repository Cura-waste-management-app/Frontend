import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/event.dart';

class EventWidget extends ConsumerWidget {
  final Event event;

  get http => null;

  joinEvent(ref) async {
    var eventDetail = {
      "event_id": event.id,
      "user_id": ref.read(userIDProvider)
    };
    print(eventDetail);
    // await http.post(
    //   Uri.parse("${ref.read(localHttpIpProvider)}userChats/addMessage"),
    //   body:eventDetail
    // );
  }

  EventWidget({required this.event});

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/male_user.png'),
                  ),
                  SizedBox(width: 2),
                  Text(
                    event.adminId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${event.timestamp}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                event.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                event.location,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 2),
              const Divider(height: 4, color: Colors.black12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${event.totalMembers} members'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          joinEvent(ref);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: Colors.green,
                        ),
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
