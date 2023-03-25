import 'package:cura_frontend/features/community/new_event_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/community.dart';
import '../../models/conversation_type.dart';
import '../conversation/chat_detail_page.dart';
import 'community_detail_page.dart';
import 'widgets/event_widget.dart';
import '../../models/event.dart';

class CommunityHome extends ConsumerStatefulWidget {
  CommunityHome({Key? key, required this.community}) : super(key: key);
  final Community community;
  late int activeIndex = 0;
  @override
  // ignore: library_private_types_in_public_api
  _CommunityHomeState createState() => _CommunityHomeState();
}

//todo get event list from api
class _CommunityHomeState extends ConsumerState<CommunityHome> {
  List<Event> eventList = ConstantDataModels.eventList;
  Iterable<Event> myEventList = ConstantDataModels.eventList.reversed;
  final buttonColor = Color(0xFF484848);
  final activeButtonColor = Color(0xFF2C2C2D);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        // leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print("in gesture");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CommunityDetailsPage(community: widget.community);
                  }));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/male_user.png'),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.community.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CommunityDetailsPage(
                                  community: widget.community,
                                );
                              }))
                            },
                        icon: Icon(Icons.more_vert)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) =>
                        widget.activeIndex == 0
                            ? activeButtonColor
                            : buttonColor)),
                onPressed: () {
                  setState(() {
                    widget.activeIndex = 0;
                  });
                },
                child: Text('Explore'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) =>
                        widget.activeIndex == 1
                            ? activeButtonColor
                            : buttonColor)),
                onPressed: () {
                  setState(() {
                    widget.activeIndex = 1;
                  });
                },
                child: Text('My Events'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => buttonColor)),
                onPressed: () {
                  ref.read(receiverIDProvider.notifier).state =
                      widget.community.id!;
                  ref.read(conversationTypeProvider.notifier).state =
                      ConversationType.community;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatDetailPage(
                      imageURL: widget.community.imgURL,
                      chatRecipientName: widget.community.name,
                      receiverID: widget.community.id!,
                      community: widget.community,
                    );
                  }));
                },
                child: Text('Discussions'),
              ),
            ],
          ),
          widget.activeIndex == 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: eventList.length,
                    itemBuilder: (context, index) {
                      return EventWidget(
                        event: eventList[index],
                      );
                    },
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: myEventList.length,
                    itemBuilder: (context, index) {
                      return EventWidget(
                        event: myEventList.elementAt(index),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewEventPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
