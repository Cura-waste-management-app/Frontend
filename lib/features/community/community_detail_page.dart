import 'dart:convert';

import 'package:cura_frontend/features/community/widgets/confirmation_dialog.dart';
import 'package:cura_frontend/features/community/widgets/leave_or_delete_group.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'models/DialogActionType.dart';
import 'models/dialog_type.dart';

class CommunityDetailsPage extends ConsumerStatefulWidget {
  bool isMember = true;
  final Community community;

  CommunityDetailsPage({Key? key, required this.community}) : super(key: key);

  @override
  _CommunityDetailsPageState createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends ConsumerState<CommunityDetailsPage> {
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
        '${ref.read(localHttpIpProvider)}community/getusersbycommunity/${widget.community.id}'));
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
      //   title: Text(widget.community.name),
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
                    // Community image
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
                                    widget.community.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${widget.community.totalMembers} members',
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
              // Community description
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
                            widget.community.description,
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
                              group: widget.community,
                              dialogType: DialogType.community,
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
                        leading: Icon(Icons.person),
                        title: Text(members[index]),
                      ),
                      SizedBox(height: 2)
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