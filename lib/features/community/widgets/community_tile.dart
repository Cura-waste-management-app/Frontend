import 'package:cura_frontend/features/community/Util/populate_random_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/image_loader/load_network_circular_avatar.dart';
import '../../../models/community.dart';
import '../../../providers/community_providers.dart';

import '../community_home.dart';

class CommunityTile extends ConsumerStatefulWidget {
  final String communityId;
  const CommunityTile({required this.communityId});
  @override
  // ignore: library_private_types_in_public_api
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends ConsumerState<CommunityTile> {
  Community _community = PopulateRandomData.community;

  @override
  void initState() {
    super.initState();
  }

  void onComingBack() {
    setState(() {
      _community =
          ref.watch(userCommunitiesProvider.notifier).get(widget.communityId) ??
              _community;
    });
  }

  @override
  Widget build(BuildContext context) {
    _community =
        ref.watch(userCommunitiesProvider.notifier).get(widget.communityId) ??
            _community;

    return GestureDetector(
      onTap: () {
        ref.read(communityIdProvider.notifier).state = _community.id!;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CommunityHome(
            communityId: widget.communityId,
            onComingBack: onComingBack,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 3),
        child: Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          // )),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    LoadNetworkCircularAvatar(
                      radius: 30,
                      imageURL: _community.imgURL,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _community.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${_community.totalMembers}  Members",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // const Divider(
                            //     color: Colors.black
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
