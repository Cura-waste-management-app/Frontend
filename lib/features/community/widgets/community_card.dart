import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';

import '../../../models/community.dart';
import '../community_detail_page.dart';

class CommunityCard extends StatefulWidget {
  final Community community;
  const CommunityCard({required this.community, super.key});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

//todo add search by community name
class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenHeight(4)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CommunityDetailsPage(
              community: widget.community,
            );
          }));
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(10)),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.community.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.community.location,
                          style: const TextStyle(
                            // fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        widget.community.type != null &&
                                widget.community.type != 'Individual'
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'From: ${widget.community.type}',
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              )
                            : Container(),
                      ]),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      width: getProportionateScreenWidth(30),
                      height: getProportionateScreenHeight(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.community.totalMembers,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      )),
                ),
                const Icon(Icons.group)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
