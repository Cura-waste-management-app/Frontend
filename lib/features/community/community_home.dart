import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/community/models/allEvents.dart';
import 'package:cura_frontend/features/community/models/entity_modifier.dart';
import 'package:cura_frontend/features/community/new_event_page.dart';
import 'package:cura_frontend/features/conversation/conversation_page.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:cura_frontend/util/constants/constant_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../common/debug_print.dart';
import '../../common/image_loader/load_network_circular_avatar.dart';
import '../../models/community.dart';
import '../../models/conversation_type.dart';
import '../../models/event.dart';
import '../conversation/providers/conversation_providers.dart';
import 'community_detail_page.dart';
import 'widgets/event_widget.dart';

class CommunityHome extends ConsumerStatefulWidget {
  static const routeName = '/community_home';
  CommunityHome({Key? key, required this.community}) : super(key: key);
  final Community community;
  late int activeIndex = 0;

  final List<Event> eventList = ConstantDataModels.eventList;
  final Iterable<Event> myEventList = ConstantDataModels.eventList.reversed;
  @override
  // ignore: library_private_types_in_public_api
  _CommunityHomeState createState() => _CommunityHomeState();
}

class _CommunityHomeState extends ConsumerState<CommunityHome> {
  late AllEvents allEvents = AllEvents(explore: [], myEvents: []);

  String errorText = 'Unable to join the event. Try again later.';

  joinEvent(Event event) async {
    var eventDetail = {
      "event_id": event.id,
      "user_id": ref.read(userIDProvider)
    };
    // prints(
    //     "$joinEventAPI/${ref.read(communityIdProvider)}/${ref.read(userIDProvider)}/${event.id}");

    ref.read(conversationTypeProvider.notifier).state = ConversationType.event;
    try {
      var response = await http.post(
          Uri.parse(
              "$joinEventAPI/${ref.read(communityIdProvider)}/${ref.read(userIDProvider)}/${event.id}"),
          body: eventDetail);

      if (response.statusCode == 201) {
        ref.refresh(getEventsProvider(widget.community.id!));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBarWidget(text: errorText).getSnackBar());
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return EventDetailPage(event: event);
      // }));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBarWidget(text: errorText).getSnackBar());
    }
    Navigator.pop(context);
  }

  @override
  initState() {
    super.initState();
    // _fetchEvents();
  }

  final buttonColor = const Color(0xFF757575);
  final activeButtonColor = const Color(0xFF383838);
  @override
  Widget build(BuildContext context) {
    // ref.read(getEventsProvider)
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 60,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CommunityDetailsPage(community: widget.community);
                  }));
                },
                child: Row(
                  children: [
                    LoadNetworkCircularAvatar(
                      radius: 20,
                      imageURL: widget.community.imgURL,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.community.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                    return ConversationPage(
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
          const SizedBox(
            height: 10,
          ),
          ref.watch(getEventsProvider(widget.community.id!)).when(data: (data) {
            setState(() {
              allEvents = data;
            });

            return Expanded(
              child: RefreshIndicator(
                  //todo built refresh higher
                  onRefresh: () async {
                    ref.refresh(getEventsProvider(widget.community.id!));
                  },
                  child: widget.activeIndex == 0
                      ? allEvents.explore.isEmpty
                          ? Center(
                              child: Text(
                              noNewEvents,
                              style: Theme.of(context).textTheme.headline6,
                            ))
                          : ListView.builder(
                              itemCount: allEvents.explore.length,
                              itemBuilder: (context, index) {
                                return EventWidget(
                                  event: allEvents.explore[index],
                                  joined: false,
                                  joinevent: () => joinEvent(
                                      allEvents.explore.elementAt(index)),
                                );
                              },
                            )
                      : allEvents.myEvents.isEmpty
                          ? Center(
                              child: Text(
                              noJoinedEvents,
                              style: Theme.of(context).textTheme.headline6,
                            ))
                          : ListView.builder(
                              itemCount: allEvents.myEvents.length,
                              itemBuilder: (context, index) {
                                return EventWidget(
                                  event: allEvents.myEvents.elementAt(index),
                                  joined: true,
                                  joinevent: () => joinEvent(
                                      allEvents.myEvents.elementAt(index)),
                                );
                              },
                            )),
            );
          }, error: (Object error, StackTrace stackTrace) {
            prints(error);
            prints(stackTrace);
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
