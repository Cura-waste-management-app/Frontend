import 'dart:convert';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/widgets/leave_or_delete_group.dart';
import 'package:cura_frontend/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../common/debug_print.dart';
import '../../common/image_loader/load_network_circular_avatar.dart';
import '../../common/load_error_screen.dart';
import '../../constants.dart';
import '../../providers/community_providers.dart';
import '../conversation/providers/conversation_providers.dart';
import 'models/dialog_type.dart';
import 'models/entity_modifier.dart';
import 'new_event_page.dart';

class EventDetailPage extends ConsumerStatefulWidget {
  bool isMember;
  Event? event;
  String? id;
  static const routeName = '/event_detail';
  EventDetailPage({Key? key, this.event, this.id, this.isMember = false})
      : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  @override
  void initState() {
    super.initState();
    _fetchEvent();
    checkMember();
    // _fetchUsers();
  }

  checkMember() async {
    var dataBox = await Hive.openBox<List<String>>(hiveDataBox);
    List<String>? joinedEventIdList =
        dataBox.get(joinedEventIdListKey, defaultValue: []);

    String id = widget.id ?? widget.event?.id ?? '';
    bool exist = joinedEventIdList?.contains(id) ?? false;
    // prints('member exist $exist');
    // joinedEventIdList?.forEach((element) {
    //   prints(element);
    // });
    if (exist) {
      setState(() {
        widget.isMember = true;
      });
    }
  }

  Future _fetchEvent() async {
    if (widget.event != null) return;
    final response = await http.get(Uri.parse('$getEventByIdAPI/${widget.id}'));
    prints(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        widget.event = Event.fromJson(jsonData);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Future<void> _fetchUsers() async {
  //   prints(
  //       '$base_url/events/getusersbyevent/${widget.event?.id ?? widget.id}');
  //   final response = await http.get(Uri.parse(
  //       '$base_url/events/getusersbyevent/${widget.event?.id ?? widget.id}'));
  //   if (response.statusCode == 200) {
  //     prints(response.body);
  //     final jsonData = json.decode(response.body) as List<dynamic>;
  //
  //     setState(() {
  //       // members= jsonData.map((json) => User.fromJson(json)).toList();
  //     });
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.event == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop(widget.event);
            // if (widget.onComingBack != null) widget.onComingBack!();
            return false;
          },
          child: Scaffold(
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
                                padding: EdgeInsets.all(
                                    getProportionateScreenHeight(12)),
                                child: Row(
                                  children: [
                                    LoadNetworkCircularAvatar(
                                      radius: 30,
                                      imageURL: '${widget.event?.imgURL}',
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.event?.name}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${widget.event?.totalMembers} members',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    widget.event?.adminId ==
                                            ref.read(userIDProvider)
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return NewEventPage(
                                                  entityModifier:
                                                      EntityModifier.update,
                                                  event: widget.event,
                                                );
                                              })).then((event) {
                                                setState(() {
                                                  widget.event = event;
                                                });
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
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
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(8)),
                              child: Container(
                                margin: EdgeInsets.all(
                                    getProportionateScreenHeight(16)),
                                child: Text(
                                  '${widget.event?.description}',
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16)),
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
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(8)),
                              child: Container(
                                  margin: EdgeInsets.all(
                                      getProportionateScreenHeight(16)),
                                  child: LeaveOrDeleteGroup(
                                    group: widget.event,
                                    dialogType: DialogType.event,
                                    isMember: widget.isMember,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ref
                        .watch(getEventMembersProvider(
                            '${widget.event?.communityId}/${widget.event?.id ?? widget.id}'))
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
                                      'Member${members.length > 1 ? 's' : ''} (${members.length})',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    // primary: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: members.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            hoverColor: Colors.white70,
                                            tileColor: Colors.white,
                                            trailing: members[index].id ==
                                                    widget.event?.adminId
                                                ? const Text(
                                                    'admin',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black54),
                                                  )
                                                : const SizedBox(
                                                    width: 0,
                                                  ),
                                            leading: LoadNetworkCircularAvatar(
                                              imageURL:
                                                  members[index].avatarURL ??
                                                      defaultNetworkImage,
                                            ),
                                            title: Text(members[index].name),
                                          ),
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      2))
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
                            loading: () => const Center(
                                child: CircularProgressIndicator())),
                  ],
                  // ],
                ),
              ),
            ),
          ));
    }
  }
}
