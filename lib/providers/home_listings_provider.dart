// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import './constants/variables.dart';
import '../screens/Listings/models/listings.dart';

class HomeListingsNotifier extends ChangeNotifier {
  List<Listing> _displayItems = [];
  // get items => _displayItems;
  final uid = '00000001c2e6895225b91f71';

  Map<String, bool> displayChoices = {
    'all': true,
    'fav': false,
    'Food': false,
    'Cloth': false,
    'Furniture': false,
    'Other': false,
  };

  List<Listing> get items {
    String choice = "";
    displayChoices.forEach((key, value) {
      if (value == true) {
        choice = key;
      }
    });

    if (choice == 'all') {
      return [..._displayItems];
    }
    return _displayItems
        .where((element) => element.category == choice)
        .toList();
    // return [..._displayItems];
  }

  void setChoices(String category) {
    print(category);
    displayChoices.forEach((key, value) {
      if (key != category) {
        displayChoices[key] = false;
      } else {
        displayChoices[key] = !displayChoices[key]!;
        if (displayChoices[key] == false) {
          displayChoices['all'] = true;
        }
      }
    });

    print(displayChoices);
    notifyListeners();
  }

  final baseUrl = 'http://192.168.1.6:3000';

  Future<void> fetchAndSetItems() async {
    Uri url = Uri.parse(
      "${base_url}/homeListings/homeproducts/${uid}",
    );
    try {
      var response = await http.get(url);

      final data = response.body;
      // print(data['user']);
      final List fetchedItems = json.decode(data)['listings'];
      final Map userData = json.decode(data)['user'];
      final List likedItems = userData['itemsLiked'];
      final List reqItems = userData['itemsRequested'];
      print(fetchedItems);
      print(userData);

      // for (int i = 0; i < list.length; i++) {}
      // List<Listing> listings =
      //     List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

      List<Listing> dummyList = [];
      for (int i = 0; i < fetchedItems.length; i++) {
        print(fetchedItems[i]['title']);

        bool fav = false;
        bool req = false;

        for (int j = 0; j < reqItems.length; j++) {
          if (fetchedItems[i]['_id'].toString() == reqItems[j].toString()) {
            req = true;
            break;
          }
        }

        for (int j = 0; j < likedItems.length; j++) {
          if (fetchedItems[i]['_id'].toString() == likedItems[j].toString()) {
            fav = true;
            break;
          }
        }

        dummyList.add(Listing(
          id: fetchedItems[i]['_id'],
          description: fetchedItems[i]['description'],
          title: fetchedItems[i]['title'],
          status: fetchedItems[i]['status'],
          requests: fetchedItems[i]['requestedUsers'].length,

          likes: fetchedItems[i]['likes'],
          isFavourite: fav,
          isRequested: req,
          postTimeStamp: DateTime.parse(fetchedItems[i]['postTimeStamp']),
          location: "552 m",
          // userImageURL: 'assets/images/female_user.png',
          owner: "john",
          category: fetchedItems[i]['category'],
          imagePath: fetchedItems[i]['imagePath'],
        ));
      }

      _displayItems = dummyList;
      for (int i = 0; i < _displayItems.length; i++) {
        print(_displayItems[i].isFavourite);
      }
      // print(listings);
      // notifyListeners();
      // return listings;
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }

  // Future<List> fetchAndSetItems() async {
  //   Uri url = Uri.parse(
  //     "$baseUrl/homeListings/homeproducts/$uid",
  //   );
  //   try {
  //     var response = await http.get(url);
  //     final data = json.decode(response.body);
  //     // print(data);
  //     Iterable list = data['listings'];
  //     List<dynamic> itemsLiked = data['itemsLiked'] ;
  //     List<dynamic> itemsRequested = data['itemsRequested'] ;

     

  //     List<Listing> listings =
  //         List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

  //     for (int i = 0; i < list.length; i++) {
  //       listings[i].isFavourite = itemsLiked.contains(listings[i].id as dynamic);
  //       listings[i].isRequested = itemsRequested.contains(listings[i].id as dynamic);
  //     }

  //     _displayItems = listings;
  //     // print(listings);
  //     notifyListeners();
  //     return listings;
  //   } catch (err) {
  //     throw err;
  //   }
  //   notifyListeners();
  // }
}
