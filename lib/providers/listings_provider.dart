// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../screens/Listings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  List<Listing> _listings = [];
  List<Listing> get userListings => _listings;

  final uid = '00000001c2e6895225b91f71';

  Future<List<Listing>> getListings() async {
    // print("in lisings");
    var response =
        await http.get(Uri.parse('${base_url}/userListings/fetch/$uid'));

    final data = response.body;
    Iterable list = json.decode(data);

    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _listings = listings;
    // print("listings - $_listings");
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

  Listing myItemsFindById(String id) {
    return _listings.firstWhere((element) => element.id == id);
  }
}
