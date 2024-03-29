// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../common/debug_print.dart';
import '../screens/Listings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  List<Listing> _listings = [];
  bool listingsFetchError = false;
  List<Listing> get userListings => _listings;

  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    // prints("idtoken- $idtoken");
    // prints("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

    return headers;
  }

  Future<List<Listing>> getListings(String uid) async {
    try {
      // Map<String, String> headers = await getHeaders();
      var response = await http.get(
        Uri.parse('$base_url/userListings/fetch/$uid'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        final data = response.body;
        Iterable list = json.decode(data);
        // prints(json.decode(data));
        List<Listing> listings =
            List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));
        _listings = listings;
        // prints("listings - ${_listings[0].requestedUsers![0].avatarURL}");
        notifyListeners();
      } else {
        prints('Response status: ${response.statusCode} ');

        listingsFetchError = true;
      }
    } catch (err) {
      prints(err);
      listingsFetchError = true;
    }
    return _listings;
  }

  Future<String> deleteListing(listingID, String uid) async {
    try {
      // Map<String, String> headers = await getHeaders();
      var response = await http.post(
        Uri.parse('$base_url/userListings/deleteListing'),
        body: {'listingID': listingID, 'userID': uid},
      );
      prints('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        await getListings(uid);
        return "Listing deleted successfully!";
      } else {
        return "Some error occurred!";
      }
    } catch (err) {
      prints("error - $err");
      if (err.toString() == "Connection timed out") {
        return "Server Down!";
      } else {
        return "Some error occurred";
      }
    }
  }

  Future<String> shareListing(listingID, sharedUserID, String uid) async {
    try {
      // Map<String, String> headers = await getHeaders();
      prints(sharedUserID);
      var response = await http.post(
          Uri.parse('$base_url/userListings/shareListing'),
          body: {'listingID': listingID, 'sharedUserID': sharedUserID});

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        await getListings(uid);
        return "Listing shared!";
      } else {
        return "Some error occurred!";
      }
    } catch (err) {
      if (err.toString() == "Connection timed out") {
        return "Server Down!";
      } else {
        return "Some error occurred!";
      }
    }
  }

  void setSearchResults(String searchText, String uid) async {
    var listings = await getListings(uid);
    if (searchText.isEmpty) {
      // If the search text is empty, restore the original listings
      _listings = listings;
    } else {
      // Otherwise, filter the original listings based on the search query
      _listings = listings
          .where((listing) =>
              listing.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void setFilterResults(List<String> filters, String uid) async {
    var listings = await getListings(uid);
    if (filters.isEmpty) {
      _listings = listings;
    } else {
      _listings = listings
          .where((listing) => filters.contains(listing.status))
          .toList();
    }
    prints("in filters");
    notifyListeners();
  }

  Listing myItemsFindById(String id) {
    return _listings.firstWhere((element) => element.id == id);
  }
}
