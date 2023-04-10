// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:cura_frontend/screens/myListings/features/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Listings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  List<Listing> _listings = [];
  List<Listing> get userListings => _listings;

//     SharedPreferences prefs =  await SharedPreferences.getInstance().then((_){
//       String? idtoken = prefs.getString('uid');
//     print(idtoken);
//     Map<String, String> headers = {'Authorization': 'Bearer $idtoken'};

//     }
// );
 Future<Map<String, String>> getHeaders() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    // print("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};
    ;
    return headers;
  }

  Future<List<Listing>> getListings() async {
    Map<String, String> headers = await getHeaders();
    var response = await http.get(
        Uri.parse('${base_url}/userListings/fetch/$uid'),
        headers: headers);

    final data = response.body;
    Iterable list = json.decode(data);
    // print(json.decode(data));
    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _listings = listings;
    // print("listings - ${_listings[0].requestedUsers![0].avatarURL}");
    notifyListeners();

    return listings;
  }

 

  void deleteListing(listingID) async {
    var response = await http.post(
        Uri.parse('${base_url}/userListings/deleteListing'),
        body: {'listingID': listingID, 'userID': uid});
    await getListings();
    print('Response status: $response');
  }

  void shareListing(listingID, sharedUserName) async {
    var response = await http.post(
        Uri.parse(
            'https://backend-production-e143.up.railway.app/userListings/shareListing'),
        body: {'listingID': listingID, 'sharedUserName': sharedUserName});
    print('Response status: $response');
    await getListings();
  }

  void setSearchResults(String searchText) async {
    var listings = await getListings();
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

  void setFilterResults(List<String> filters) async {
    var listings = await getListings();
    if (filters.isEmpty) {
      _listings = listings;
    } else {
      _listings = listings
          .where((listing) => filters.contains(listing.status))
          .toList();
    }
    print("in filters");
    notifyListeners();
  }

  Listing myItemsFindById(String id) {
    return _listings.firstWhere((element) => element.id == id);
  }
}
