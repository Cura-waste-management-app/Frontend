import 'dart:convert';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/widgets/leave_or_delete_group.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../common/image_loader/load_circular_avatar.dart';
import '../../common/image_loader/load_network_circular_avatar.dart';
import '../../common/load_error_screen.dart';
import '../../constants.dart';
import '../../providers/community_providers.dart';
import 'models/dialog_type.dart';
import 'models/entity_modifier.dart';
import 'new_event_page.dart';

class EventDetailPage extends ConsumerStatefulWidget {
  bool isMember; //todo find if member
  final Event event;
  static const routeName = '/event_detail';
  EventDetailPage({Key? key, required this.event, this.isMember = false})
      : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  List<String> members = [
    'John Doe',
    'Jane Smith',
    'Alex Johnson',
    'Samantha Williams',
    'Michael Brown',
    'Emily Davis',
    'William Wilson',
    'Jessica Thompson',
    'David Jones',
    'Amanda Clark',
  ];
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse(
        '${ref.read(localHttpIpProvider)}event/getusersbyevent/${widget.event.id}'));
    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body) as List<dynamic>;

      setState(() {
        // members= jsonData.map((json) => User.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      // appBar: AppBar(
      //   title: Text(widget.event.name),
      // ),
      body: Padding(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              // First row
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Event image
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding:
                              EdgeInsets.all(getProportionateScreenHeight(12)),
                          child: Row(
                            children: [
                              LoadCircularAvatar(
                                radius: 30,
                                imageURL:
                                    defaultAssetImage, //todo set image for event
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.event.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.event.totalMembers} members',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return NewEventPage(
                                      entityModifier: EntityModifier.update,
                                      event: widget.event,
                                    );
                                  }));
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              // Event description
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding:
                            EdgeInsets.all(getProportionateScreenHeight(8)),
                        child: Container(
                          margin:
                              EdgeInsets.all(getProportionateScreenHeight(16)),
                          child: Text(
                            widget.event.description,
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding:
                            EdgeInsets.all(getProportionateScreenHeight(8)),
                        child: Container(
                            margin: EdgeInsets.all(
                                getProportionateScreenHeight(16)),
                            child: LeaveOrDeleteGroup(
                              group: widget.event,
                              dialogType: DialogType.event,
                              isMember: widget.isMember!,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              ref
                  .watch(getEventMembersProvider(
                      '${ref.read(communityIdProvider)}/${widget.event.id!}'))
                  .when(
                      data: (members) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(16),
                                  left: getProportionateScreenWidth(16),
                                  right: getProportionateScreenWidth(16),
                                  bottom: 0),
                              child: Text(
                                'Members (${members.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(
                              // primary: false,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      hoverColor: Colors.white70,
                                      tileColor: Colors.white,
                                      leading: LoadNetworkCircularAvatar(
                                        imageURL: members[index].avatarURL!,
                                      ),
                                      title: Text(members[index].name),
                                    ),
                                    SizedBox(
                                        height: getProportionateScreenHeight(2))
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                      error: (_, __) {
                        return const LoadErrorScreen();
                      },
                      loading: () => const CircularProgressIndicator()),
            ],
            // ],
          ),
        ),
      ),
    );
  }
}
//todo count admin as member too
