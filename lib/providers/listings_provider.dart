// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../screens/Listings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  List<Listing> _listings = [];
  get userListings => _listings;
  final uid = '00000001c2e6895225b91f71';

  Future<List> getListings() async {
    var response = await http
        .get(Uri.parse('http://192.168.1.6:3000/userListings/fetch/$uid'));

    final data = response.body;
    print(data);
    Iterable list = json.decode(data);

    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _listings = listings;

    notifyListeners();

    return listings;
  }

  void deleteListing(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userListings/deleteListing'),
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

  Listing myItemsFindById(String id) {
    return _listings.firstWhere((element) => element.id == id);
  }
}
