// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../screens/Listings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  List<Listing> _listings = [];
  get userListings => _listings;

  Future<List> getListings() async {
    var response = await http.get(Uri.parse(
        'https://backend-production-e143.up.railway.app/userListings/fetch'));

    Iterable list = json.decode(response.body);

    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _listings = listings;
    notifyListeners();
    
    return listings;
  }

  void deleteListing(listingID) async {
    var response = await http.post(
        Uri.parse(
            'https://backend-production-e143.up.railway.app/userListings/deleteListing'),
        body: {'listingID': listingID});
    await getListings();
    print('Response status: $response');
  }

  void shareListing(listingID) async {
    var response = await http.post(
        Uri.parse(
            'https://backend-production-e143.up.railway.app/userListings/shareListing'),
        body: {'listingID': listingID});
    print('Response status: $response');
    await getListings();
  }
}
