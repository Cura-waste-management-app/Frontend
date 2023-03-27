import 'package:flutter/material.dart';
import 'package:cura_frontend/screens/myRequests/features/header.dart';
import 'package:cura_frontend/screens/myRequests/features/search_bar.dart';
import 'package:cura_frontend/screens/myRequests/features/filter.dart';
import 'package:cura_frontend/screens/myRequests/features/active_requests.dart';
import 'package:cura_frontend/screens/myRequests/features/past_requests.dart';
import 'package:provider/provider.dart';
import 'package:cura_frontend/providers/requests_provider.dart';

// ignore: use_key_in_widget_constructors
class UserRequests extends StatefulWidget {
  static const routeName = '/my-requests';
  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  String searchField = "";
  final controller = ScrollController();

  void updateSearchField(String text) {
    Provider.of<RequestsNotifier>(context, listen: false)
        .setSearchResults(text);
    setState(() => {searchField = text});
  }

  @override
  void initState() {
    super.initState();
    Provider.of<RequestsNotifier>(context, listen: false)
        .getUserRequests(); // cant set to true - would result in a loop
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[200],
            toolbarHeight: 70,
            elevation: 0.0,
            title: Header()),
        body: SingleChildScrollView(
          child: Column(children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SearchBar(setField: updateSearchField),
                      Filter()
                    ]),
              ),
            ),
            Container(
                height: 580,
                margin: const EdgeInsets.only(right: 3),
                child: Consumer<RequestsNotifier>(
                    builder: (context, notifier, child) {
                  return notifier.userRequests.length == 0
                      ? const Text(
                          "Nothing requested yet! Let's request something")
                      : Scrollbar(
                          controller: controller,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: ListView.builder(
                              controller: controller,
                              itemCount: notifier.userRequests.length,
                              itemBuilder: (c, i) {
                                print(
                                    "hello in user requests #######################");
                                return notifier.userRequests[i].status ==
                                        "Shared"
                                    ? PastRequests(notifier.userRequests[i])
                                    : ActiveRequests(
                                        listing: notifier.userRequests[i],
                                      );
                              }));
                }))
          ]),
        ));
  }
}
