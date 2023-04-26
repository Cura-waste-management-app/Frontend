import 'dart:convert';

import 'package:cura_frontend/common/image_loader/load_network_image.dart';
import 'package:cura_frontend/common/load_error_screen.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/new_community_page.dart';
import 'package:cura_frontend/features/community/widgets/confirmation_dialog.dart';
import 'package:cura_frontend/features/community/widgets/leave_or_delete_group.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:cura_frontend/features/conversation/providers/conversation_providers.dart';
import 'package:cura_frontend/models/community.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../common/image_loader/load_asset_image.dart';
import '../../common/image_loader/load_circular_avatar.dart';
import '../../common/image_loader/load_network_circular_avatar.dart';
import '../../constants.dart';
import '../../providers/constants/variables.dart';
import 'models/DialogActionType.dart';
import 'models/entity_modifier.dart';
import 'models/dialog_type.dart';

class CommunityDetailsPage extends ConsumerStatefulWidget {
  bool isMember;
  late Community? community;
  final String? id;
  static const routeName = '/community_detail';

  CommunityDetailsPage(
      {Key? key, this.community, this.isMember = false, this.id})
      : super(key: key);

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
    print('is Member ${widget.isMember}');
    if (!widget.isMember) checkMember();
    // _fetchUsers();
  }

  checkMember() async {
    var dataBox = await Hive.openBox<List<String>>(hiveDataBox);
    List<String>? joinedCommunityIdList =
        dataBox.get(joinedCommunityIdListKey, defaultValue: []);

    String id = widget.id ?? widget.community?.id ?? '';
    bool exist = joinedCommunityIdList?.contains(id) ?? false;
    joinedCommunityIdList?.forEach((element) {
      print(element);
    });
    if (exist) {
      setState(() {
        widget.isMember = true;
      });
    }
  }

  Future _fetchCommunity() async {
    if (widget.community != null) return;
    final response =
        await http.get(Uri.parse('$getCommunityByIdAPI/${widget.id}'));
    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      setState(() {
        widget.community = Community.fromJson(jsonData);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.community == null) {
      _fetchCommunity();
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: Builder(builder: (context) {
          final double topPadding = getProportionateScreenHeight(22);

          return Padding(
            padding: EdgeInsets.only(top: topPadding),
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
                        // Community image
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(10)),
                              child: Row(
                                children: [
                                  LoadCircularAvatar(
                                    imageURL: widget.community!.imgURL,
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(15),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.community!.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              getProportionateScreenHeight(8)),
                                      Text(
                                        '${widget.community!.totalMembers} members',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  widget.community?.adminId ==
                                          ref.read(userIDProvider)
                                      ? IconButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return NewCommunityPage(
                                                entityModifier:
                                                    EntityModifier.update,
                                                community: widget.community,
                                              );
                                            }));
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
                  // Community description
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
                              child: Text(
                                widget.community!.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
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
                                  group: widget.community,
                                  dialogType: DialogType.community,
                                  isMember: widget.isMember,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ref
                      .watch(getCommunityMembersProvider(widget.community!.id!))
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
                                          trailing: members[index].id ==
                                                  widget.community?.adminId
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
                                            imageURL: members[index].avatarURL!,
                                          ),
                                          title: Text(members[index].name),
                                        ),
                                        SizedBox(
                                            height:
                                                getProportionateScreenHeight(2))
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
          );
        }),
      );
    }
  }
}
