import 'package:cura_frontend/models/community.dart';
import 'package:flutter/material.dart';

class CommunityDetailsPage extends StatefulWidget {
  bool isMember = true;
  final Community community;

  CommunityDetailsPage({Key? key, required this.community}) : super(key: key);

  @override
  _CommunityDetailsPageState createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      // appBar: AppBar(
      //   title: Text(widget.community.name),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isMember = !widget.isMember;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Row(children: [
                              Text(
                                widget.isMember ? 'Leave' : 'Join',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              if (widget.isMember) const Icon(Icons.exit_to_app)
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Join button
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       widget.isMember = !widget.isMember;
              //     });
              //   },
              // if (widget.isMember) ...[  //   child: Text(widget.isMember ? 'Leave' : 'Join'),
              // ),
              // List of members

              Padding(
                padding: const EdgeInsets.all(16.0),
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
