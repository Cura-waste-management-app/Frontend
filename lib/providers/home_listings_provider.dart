import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import './constants/variables.dart';
import '../screens/Listings/models/listings.dart';

class HomeListingsNotifier extends ChangeNotifier {
  List<Listing> _displayItems = [];
  // get items => _displayItems;

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

  List<Listing> get favitems {
    String choice = "";
    displayChoices.forEach((key, value) {
      if (value == true) {
        choice = key;
      }
    });

    if (choice == 'all') {
      print("Hi mai aya");
      print(_displayItems.length);
      for (int i = 0; i < _displayItems.length; i++) {
        print(_displayItems[i].title);
      }

      return _displayItems
          .where((element) => element.isFavourite == true)
          .toList();
    }
    return _displayItems
        .where((element) =>
            element.isFavourite == true && element.category == choice)
        .toList();
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

        // dummyList.add(Listing(
        //   id: fetchedItems[i]['_id'],
        //   description: fetchedItems[i]['description'],
        //   title: fetchedItems[i]['title'],
        //   status: fetchedItems[i]['status'],
        //   requests: fetchedItems[i]['requestedUsers'].length,

        //   likes: fetchedItems[i]['likes'],
        //   isFavourite: fav,
        //   isRequested: req,
        //   postTimeStamp: DateTime.parse(fetchedItems[i]['postTimeStamp']),
        //   location: "552 m",
        //   // userImageURL: 'assets/images/female_user.png',
        //   owner: "john",
        //   category: fetchedItems[i]['category'],
        //   imagePath: fetchedItems[i]['imagePath'],
        // ));
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

  Listing findById(String id) {
    return _displayItems.firstWhere((element) => element.id == id);
  }

  Future<void> findByIdAndToggleFavourite(String id) async {
    final item = _displayItems.firstWhere((element) => element.id == id);
    Uri url = Uri.parse("${base_url}/homeListings/toggleLikeStatus");
    try {
      final response = await http.post(
        url,
        body: {'listingID': id, 'userID': uid},
      );
      item.isFavourite = !item.isFavourite!;
      if (item.isFavourite!) {
        item.likes = item.likes + 1;
      } else {
        item.likes = max(0, item.likes - 1);
      }
    } catch (err) {
      throw err;
    }

    notifyListeners();
  }

  Future<void> findByIdAndToggleRequest(String id) async {
    final item = _displayItems.firstWhere((element) => element.id == id);
    Uri url = Uri.parse("${base_url}/homeListings/toggleRequestStatus");

    try {
      final response = await http.post(
        url,
        body: {'listingID': id, 'userID': uid},
      );
      item.isRequested = !item.isRequested!;
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }
}