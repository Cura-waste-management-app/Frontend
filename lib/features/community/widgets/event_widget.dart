import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/event_detail_page.dart';
import 'package:cura_frontend/features/conversation/conversation_page.dart';
import 'package:cura_frontend/models/conversation_type.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/image_loader/load_network_circular_avatar.dart';
import '../../../models/event.dart';
import '../../conversation/providers/conversation_providers.dart';
import '../Util/util.dart';

class EventWidget extends ConsumerStatefulWidget {
  late final Event event;
  final bool joined;
  final VoidCallback joinevent;

  EventWidget(
      {required this.event, required this.joined, required this.joinevent});

  @override
  ConsumerState<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends ConsumerState<EventWidget> {
  _confirmEventJoin(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Join Event'),
            content: const Text('Are you sure you want to join this event?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: widget.joinevent,
                child: const Text('Join'),
              ),
            ],
          );
        });
  }

  // void onComingBack(event) {
  //   print('---------------------');
  //   setState(() {
  //     widget.event = event;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(8),
          getProportionateScreenHeight(2),
          getProportionateScreenWidth(8),
          getProportionateScreenHeight(8)),
      child: GestureDetector(
        onTap: () {
          if (widget.joined) {
            ref.read(receiverIDProvider.notifier).state = widget.event.id!;
            ref.read(conversationTypeProvider.notifier).state =
                ConversationType.event;
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ConversationPage(
                event: widget.event,
                imageURL: widget.event.imgURL,
                chatRecipientName: widget.event.name,
                receiverID: widget.event.id!,
              );
            }));
          } else {
            ref.read(currentEvent.notifier).state = widget.event;
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EventDetailPage(
                  isMember: widget.joined, id: widget.event.id);
            }));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(getProportionateScreenHeight(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(16),
                getProportionateScreenHeight(10),
                getProportionateScreenWidth(16),
                getProportionateScreenHeight(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadNetworkCircularAvatar(
                          radius: 16,
                          imageURL: widget.event.imgURL,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          // event.adminId,
                          widget.event.adminName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatTimeAgo(widget.event.postTime),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    // SizedBox(height: getProportionateScreenHeight(5)),
                    // Text(
                    //   event.location,
                    //   style: const TextStyle(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
                // SizedBox(height: 10),
                Divider(
                    height: getProportionateScreenHeight(16),
                    color: Colors.black12),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.event.location,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.event.totalMembers}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.group,
                        color: Colors.black87,
                      ),

                      // SizedBox(
                      //   height: 30,
                      //   child: IconButton(
                      //     padding: EdgeInsets.zero,
                      //     onPressed: () {},
                      //     icon: const Icon(
                      //       Icons.share,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: getProportionateScreenWidth(5)),
                      !widget.joined
                          ? SizedBox(
                              width: getProportionateScreenWidth(60),
                              height: getProportionateScreenHeight(30),
                              child: ElevatedButton(
                                onPressed: () => _confirmEventJoin(context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        getProportionateScreenHeight(16)),
                                  ),
                                  primary: Colors.green,
                                ),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ))
                          : Container(),
                      SizedBox(width: getProportionateScreenHeight(2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
