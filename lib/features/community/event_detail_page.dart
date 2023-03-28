import 'dart:convert';

import 'package:cura_frontend/features/community/widgets/confirmation_dialog.dart';
import 'package:cura_frontend/features/community/widgets/leave_or_delete_group.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'models/DialogActionType.dart';
import 'models/dialog_type.dart';

//todo add option for editing
class EventDetailPage extends ConsumerStatefulWidget {
  bool isMember = true;
  final Event event;
  EventDetailPage({Key? key, required this.event}) : super(key: key);

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
      print(jsonData);
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
      backgroundColor: Color(0xFFF3F3F3),
      // appBar: AppBar(
      //   title: Text(widget.event.name),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
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
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/images/male_user.png'),
                              ),
                              SizedBox(
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
                              // Spacer(),
                              // IconButton(
                              //   onPressed: () {
                              //     Navigator.pop(context);
                              //   },
                              //   icon: Icon(
                              //     Icons.arrow_back,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Event description
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Text(
                            widget.event.description,
                            style: const TextStyle(fontSize: 16),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            margin: EdgeInsets.all(16),
                            child: LeaveOrDeleteGroup(
                              group: widget.event,
                              dialogType: DialogType.event,
                            )),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 16, right: 16, bottom: 0),
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
                        leading: const Icon(Icons.person),
                        title: Text(members[index]),
                      ),
                      const SizedBox(height: 2)
                    ],
                  );
                },
              ),
            ],
            // ],
          ),
        ),
      ),
    );
  }
}
//todo count admin as member too
