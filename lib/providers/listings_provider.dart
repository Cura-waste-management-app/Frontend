import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cura_frontend/screens/myListings/models/listings.dart';

class ListingsNotifier extends ChangeNotifier {
  var _listings = [];
  get userListings => _listings;

  void getListings() async {
    var response =
        await http.get(Uri.parse('http://192.168.1.6:3000/userListings/fetch'));
    _listings = jsonDecode(response.body);

  }

  void deleteListing(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userListings/deleteListing'),
        body: {'listingID': listingID});

    print('Response status: $response');

    notifyListeners();
  }

  void shareListing(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userListings/shareListing'),
        body: {'listingID': listingID});
    print('Response status: $response');

    notifyListeners();
  }
}
