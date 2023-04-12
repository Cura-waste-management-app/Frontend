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

   Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    print("idtoken- $idtoken");
    // print("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

    return headers;
  }

  Future<List<Listing>> getUserRequests() async {
    print("hello in requests");
   Map<String, String> headers = await getHeaders();
    var response =
        await http.get(Uri.parse('$base_url/userRequests/fetch/$uid'),  headers: headers);

    Iterable list = json.decode(response.body);

    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _requests = listings;
    print("requests - ${listings[0].status}, ${_requests[0].status}");
    notifyListeners();
    return listings;
  }

  void deleteRequest(listingID) async {
     Map<String, String> headers = await getHeaders();
    var response = await http.post(
        Uri.parse('$base_url/userRequests/deleteRequest'),
        body: {'listingID': listingID, 'userID': uid},  headers: headers);
    await getUserRequests();
    print('Response status: $response');
  }

  Future<String> listingReceived(listingID) async {
     Map<String, String> headers = await getHeaders();
    print("in listing received fxn");
    var response = await http.post(
        Uri.parse('$base_url/userRequests/receiveListing'),
        body: {'listingID': listingID, 'userID': uid},  headers: headers);
    // print('Response: ${response.body}');
    return response.body;
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
