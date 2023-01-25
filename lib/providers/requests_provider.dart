// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../screens/Listings/models/listings.dart';

class RequestsNotifier extends ChangeNotifier {

  List<Listing> _requests = [];
  get userRequests => _requests;

  Future<List> getUserRequests() async {
    var response =
        await http.get(Uri.parse('http://192.168.1.6:3000/userRequests/fetch'));
    
    Iterable list = json.decode(response.body);

    List<Listing> listings = List<Listing>.from(list.map((obj) => 
    Listing.fromJson(obj)));

    _requests = listings;
    notifyListeners();
    return listings;
  }

  void deleteRequest(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userRequests/deleteRequest'),
        body: {'listingID': listingID});
    await getUserRequests();
    print('Response status: $response');

    notifyListeners();
  }

  void completeRequest(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userRequests/completeRequest'),
        body: {'listingID': listingID});
    print('Response status: $response');
    await getUserRequests();
    notifyListeners();
  }
}
