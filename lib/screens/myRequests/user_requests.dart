import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/profile/screens/my_profile.dart';
import 'package:cura_frontend/providers/requests_provider.dart';
import 'package:cura_frontend/providers/user_provider.dart';
import 'package:cura_frontend/screens/myRequests/features/active_requests.dart';
import 'package:cura_frontend/screens/myRequests/features/past_requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/filter/filter.dart';
import '../../common/filter/item_model.dart';
import '../../common/main_drawer.dart';
import '../../common/search_bar.dart';

// ignore: use_key_in_widget_constructors
class UserRequests extends StatefulWidget {
  static const routeName = '/my-requests';
  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  String searchField = "";
  final controller = ScrollController();
  bool isLoadingData = true;
  bool isLoadingUser = true;
  String uid = "";
  String avatarURL = "";

  List<ItemModel> states = [
    ItemModel("Received", Colors.green, false),
    ItemModel("Pending", Colors.blue, false),
    ItemModel("Not Received", const Color.fromARGB(255, 243, 113, 104), false),
  ];

  List<String> filters = [];

  void updateSearchField(String text) {
    Provider.of<RequestsNotifier>(context, listen: false)
        .setSearchResults(text, uid);
    setState(() => {searchField = text});
  }

  void updateFilters(List<String> filterValues) {
    Provider.of<RequestsNotifier>(context, listen: false)
        .setFilterResults(filterValues, uid);
    setState(() {
      filters = filterValues;
    });
  }

  @override
  void initState() {
    super.initState();

    Provider.of<UserNotifier>(context, listen: false)
        .fetchUserInfo()
        .then((user) {
      setState(() {
        uid = user!.id;
        avatarURL = user.avatarURL ?? defaultNetworkImage;
        isLoadingUser = false;
      });

      if (Provider.of<UserNotifier>(context, listen: false).userFetchError) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBarWidget(
                text: "Oops, Some Error Occurred, Please try again later!")
            .getSnackBar());
      } else {
        Provider.of<RequestsNotifier>(context, listen: false)
            .getUserRequests(uid)
            .then((value) {
          setState(() {
            isLoadingData = false;
          });

          if (Provider.of<RequestsNotifier>(context, listen: false)
              .requestsFetchError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBarWidget(
                    text: "Oops, Some Error Occurred, Please try again later!")
                .getSnackBar());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // toolbarHeight: 70,
          elevation: getProportionateScreenHeight(2),

          leadingWidth: getProportionateScreenWidth(65),
          iconTheme: const IconThemeData(color: Colors.black),
          leading: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(22)),
            child: isLoadingUser
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(MyProfile.routeName);
                    },
                    child: CircleAvatar(
                        radius: getProportionateScreenWidth(25),
                        backgroundImage: NetworkImage(
                            avatarURL != "" ? avatarURL : defaultNetworkImage)),
                  ),
          ),
          title:
              const Text('My Requests', style: TextStyle(color: Colors.black)),
        ),
        endDrawer: MainDrawer(),
        body: isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(6),
                          bottom: getProportionateScreenHeight(6)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SearchBar(
                                label: "Search in requests",
                                setField: updateSearchField),
                            Filter(chipList: states, setFilters: updateFilters)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                            height: getProportionateScreenHeight(620),
                            margin: EdgeInsets.only(
                                right: getProportionateScreenWidth(3)),
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
                                          itemCount:
                                              notifier.userRequests.length,
                                          itemBuilder: (c, i) {
                                            print(
                                                "hello in user requests #######################");
                                            return notifier.userRequests[i]
                                                        .status ==
                                                    "Shared"
                                                ? PastRequests(uid,
                                                    notifier.userRequests[i])
                                                : ActiveRequests(
                                                    listing: notifier
                                                        .userRequests[i],
                                                    uid: uid);
                                          }));
                            }))
                      ]),
                    ),
                  ),
                ],
              ));
  }
}
