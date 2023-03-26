// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../screens/Listings/models/listings.dart';

class RequestsNotifier extends ChangeNotifier {
  List<Listing> _requests = [];
  get userRequests => _requests;
  final uid = '000000023c695a9a651a5344';

  Future<List> getUserRequests() async {
    print("hello in requests");
    var response = await http
        .get(Uri.parse('http://192.168.1.6:3000/userRequests/fetch/$uid'));

    Iterable list = json.decode(response.body);

    List<Listing> listings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _requests = listings;
    print("requests - ${listings[0].status}, ${_requests[0].status}");
    notifyListeners();
    return listings;
  }

  void deleteRequest(listingID) async {
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userRequests/deleteRequest'),
        body: {'listingID': listingID, 'userID': uid});
    await getUserRequests();
    print('Response status: $response');
  }

  Future<String> listingReceived(listingID) async {
    print("in listing received fxn");
    var response = await http.post(
        Uri.parse('http://192.168.1.6:3000/userRequests/receiveListing'),
        body: {'listingID': listingID, 'userID': uid});
    // print('Response: ${response.body}');
    return response.body;
  }
}
