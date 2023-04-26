// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Listings/models/listings.dart';
import 'constants/variables.dart';

class RequestsNotifier extends ChangeNotifier {
  List<Listing> _requests = [];
  get userRequests => _requests;
  bool requestsFetchError = false;

  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    // print("idtoken- $idtoken");
    // print("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

    return headers;
  }

  Future<List<Listing>> getUserRequests() async {
    // print("hello in requests");
    // Map<String, String> headers = await getHeaders();
    try {
      var response =
          await http.get(Uri.parse('$base_url/userRequests/fetch/$uid'));

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        Iterable list = json.decode(response.body);
        List<Listing> listings =
            List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));
        _requests = listings;
        notifyListeners();
      } else {
        requestsFetchError = true;
      }
    } catch (err) {
      print(err);
      requestsFetchError = true;
    }
    return _requests;
  }

  Future<String> deleteRequest(listingID) async {
    // Map<String, String> headers = await getHeaders();
    try {
      var response = await http.post(
        Uri.parse('$base_url/userRequests/deleteRequest'),
        body: {'listingID': listingID, 'userID': uid},
      );

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        await getUserRequests();
        return "Request deleted successfully!";
      } else {
        return "Some error occurred!";
      }
    } catch (err) {
      print("error - $err");
      if (err.toString() == "Connection timed out") {
        return "Server Down!";
      } else {
        return "Some error occurred";
      }
    }
  }

  Future<String> listingReceived(listingID) async {
    try {
      // Map<String, String> headers = await getHeaders();
      print("in listing received fxn");
      var response = await http.post(
          Uri.parse('$base_url/userRequests/receiveListing'),
          body: {'listingID': listingID, 'userID': uid});

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        return response.body; // 'Item received!'
      } else {
        return "Some error occurred!";
      }
    } catch (err) {
      print("error - $err");
      if (err.toString() == "Connection timed out") {
        return "Server Down! Please try again latter!";
      } else {
        return "Some error occurred";
      }
    }
  }

  void setSearchResults(String searchText) async {
    var listings = await getUserRequests();
    if (searchText.isEmpty) {
      // If the search text is empty, restore the original listings
      _requests = listings;
    } else {
      // Otherwise, filter the original listings based on the search query
      _requests = listings
          .where((listing) =>
              listing.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void setFilterResults(List<String> filters) async {
    var listings = await getUserRequests();
    List<Listing> filteredList = [];
    if (filters.isEmpty) {
      _requests = listings;
    } else {
      for (int i = 0; i < listings.length; i++) {
        String listingStatus;
        if (listings[i].status == "Shared") {
          //Past Requests
          if (listings[i].sharedUserID == uid) {
            listingStatus = "Received";
          } else {
            listingStatus = "Not Received";
          }
        } else {
          //Active requests
          listingStatus = "Pending";
        }

        if (filters.contains(listingStatus)) {
          filteredList.add(listings[i]);
        }
      }

      _requests = filteredList;
    }

    print("in filters");
    notifyListeners();
  }
}
