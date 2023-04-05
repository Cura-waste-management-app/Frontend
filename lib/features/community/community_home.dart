import 'dart:convert';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/models/allEvents.dart';
import 'package:cura_frontend/features/community/models/entity_modifier.dart';
import 'package:cura_frontend/features/community/new_event_page.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/community.dart';
import '../../models/conversation_type.dart';
import '../conversation/chat_detail_page.dart';
import 'community_detail_page.dart';
import 'widgets/event_widget.dart';
import '../../models/event.dart';
import 'package:http/http.dart' as http;

class CommunityHome extends ConsumerStatefulWidget {
  CommunityHome({Key? key, required this.community}) : super(key: key);
  final Community community;
  late int activeIndex = 0;
  final List<Event> eventList = ConstantDataModels.eventList;
  final Iterable<Event> myEventList = ConstantDataModels.eventList.reversed;
  @override
  // ignore: library_private_types_in_public_api
  _CommunityHomeState createState() => _CommunityHomeState();
}

//todo get event list from api
class _CommunityHomeState extends ConsumerState<CommunityHome> {
  late AllEvents allEvents;
  Future<void> _fetchEvents() async {
    final response = await http.get(Uri.parse(
        '${ref.read(localHttpIpProvider)}events/getusersbycommunity/${widget.community.id}'));
    print("in fetch events");
    if (response.statusCode == 200) {
      // print(response.body);
      final jsonData = json.decode(response.body) as List<dynamic>;
      // print(jsonData);
      setState(() {
        widget.activeIndex = 1;
        // members= jsonData.map((json) => User.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  initState() {
    super.initState();
    // _fetchEvents();
  }

  final buttonColor = const Color(0xFF757575);
  final activeButtonColor = const Color(0xFF5D5D5D);
  @override
  Widget build(BuildContext context) {
    // ref.read(getEventsProvider)
    return Scaffold(
      appBar: AppBar(
        // actions: [Icon(Icons.more_vert)],
        leadingWidth: 0,
        elevation: 0,
        leading: Container(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
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
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/male_user.png'),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.community.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CommunityDetailsPage(
                                  community: widget.community,
                                );
                              }))
                            },
                        icon: const Icon(Icons.more_vert)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(0),
                horizontal: getProportionateScreenWidth(16)),
            child: Divider(
                thickness: getProportionateScreenHeight(1),
                color: Colors.black38),
          ),
          const SizedBox(
            height: 1,
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
                child: const Text('Explore'),
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
                child: const Text('My Events'),
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
                child: const Text('Discussions'),
              ),
            ],
          ),
          ref.watch(getEventsProvider(widget.community.id!)).when(data: (data) {
            setState(() {
              allEvents = data;
            });
            return Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(getEventsProvider(widget.community.id!));
                  },
                  child: widget.activeIndex == 0
                      ? ListView.builder(
                          itemCount: allEvents.explore.length,
                          itemBuilder: (context, index) {
                            return EventWidget(
                              event: allEvents.explore[index],
                              joined: false,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: allEvents.myEvents.length,
                          itemBuilder: (context, index) {
                            return EventWidget(
                              event: allEvents.myEvents.elementAt(index),
                              joined: true,
                            );
                          },
                        )),
            );
          }, error: (Object error, StackTrace stackTrace) {
            // print(error);
            // print(stackTrace);
            return const Center(child: Text("can't load data"));
          }, loading: () {
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: getProportionateScreenWidth(5),
              )),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: activeButtonColor,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewEventPage(
              entityModifier: EntityModifier.create,
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
