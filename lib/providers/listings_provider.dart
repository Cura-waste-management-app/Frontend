import 'package:flutter/cupertino.dart';
import 'package:cura_frontend/screens/myListings/dummy_data.dart';

import '../screens/myListings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  // ignore: prefer_final_fields
  var _listings = listings;
  get userListings => _listings;

  void deleteListing(id) {
    // api call;
    int i = 0;
    for (i; i < _listings.length; i++) {
      if (_listings[i].id == id) {
        _listings.remove(_listings[i]);
        break;
      }
    }
    notifyListeners();
  }

  void shareListing(id) {
    //api call;
    _listings.add(Listing(
        id: "6",
        state: "Shared",
        name: "Black Jacket",
        postDate: "Tues, 18 Nov",
        requests: 9,
        likes: 6,
        views: 100,
        imgURL: 'assets/images/jacket.jpg'));
    notifyListeners();
  }
}
