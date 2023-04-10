import 'package:cura_frontend/features/conversation/chat_detail_page.dart';
import 'package:cura_frontend/models/user.dart';
import 'package:flutter/material.dart';

class ListingRequests extends StatelessWidget {
  final int requests;
  final List<User>? requestedUsers;
  const ListingRequests(
      {required this.requests, required this.requestedUsers, super.key});

  void _showListingRequests(BuildContext context) async {
    await showModalBottomSheet<User?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Select any user to chat with - ",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                requestedUsers!.isEmpty
                    ? const Text("No requests received!")
                    : Wrap(
                        spacing: 20.0,
                        children: requestedUsers!
                            .map((item) => Container(
                                height: 70,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: GestureDetector(
                                  onTap: () {
                                  
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChatDetailPage(
                                        imageURL: item.avatarURL!,
                                        chatRecipientName: item.name,
                                        receiverID: item.id,
                                      );
                                    }));
                                  },
                                  child: Card(
                                    child: Row(children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 5, 10, 5),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(item.avatarURL!),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(item.name),
                                          Text('Points - ${item.points}')
                                        ],
                                      ),
                                    ]),
                                  ),
                                )))
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );

    // if (selectedUser != null) {
    //   // setState(() {
    //   //   _selectedFilters = selectedFilters;

    //   // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft),
      onPressed: () {
        _showListingRequests(context);
      },
      child: Text(
        "Requests($requests)",
        style: const TextStyle(
            fontSize: 13, color: Color.fromARGB(255, 62, 165, 249)),
      ),
    );
  }
}
