import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/community.dart';
import '../../models/conversation_type.dart';
import '../conversation/chat_detail_page.dart';
import 'event_widget.dart';
import '../../models/event.dart';

class CommunityHome extends ConsumerStatefulWidget {
  const CommunityHome({Key? key, required this.community}) : super(key: key);
  final Community community;
  @override
  // ignore: library_private_types_in_public_api
  _CommunityHomeState createState() => _CommunityHomeState();
}

class _CommunityHomeState extends ConsumerState<CommunityHome> {
  List<Event> eventList = ConstantDataModels.eventList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Community'),
      // ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/male_user.png'),
                ),
                SizedBox(width: 5),
                Text(
                  widget.community.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal divider
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(),
          ),
          // Second row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle explore button press
                },
                child: Text('Explore'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle my events button press
                },
                child: Text('My Events'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(receiverIDProvider.notifier).state =
                      widget.community.id;
                  ref.read(conversationTypeProvider.notifier).state =
                      ConversationType.community;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatDetailPage(
                      imageURL: widget.community.imgURL,
                      chatRecipientName: widget.community.name,
                      receiverID: widget.community.id,
                    );
                  }));
                },
                child: Text('Discussions'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                return EventWidget(
                  event: eventList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
