import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../providers/constants/variables.dart';

class Listing with ChangeNotifier {
  final uid = '00000001c2e6895225b91f71';

  String id;
  String title;
  String? description;
  final String category;
  bool? isFavourite;
  bool? isRequested;
  DateTime postTimeStamp;
  DateTime? sharedTimeStamp;
  String status;
  final String owner;
  String location;
  String imagePath;
  int requests;
  int likes;
  List<dynamic>? requestedUsers;
  String? sharedUserID; // id of user to whom listing has been given at the end

  Listing(
      {required this.id,
      required this.title,
      this.description,
      required this.category,
      this.isFavourite = false,
      this.isRequested = false,
      required this.postTimeStamp,
      this.sharedTimeStamp,
      required this.status,
      required this.owner,
      required this.location,
      required this.imagePath,
      this.requests = 0,
      this.likes = 0,
      this.requestedUsers,
      this.sharedUserID});

  Future<void> toggleFavourite() async {
    Uri url = Uri.parse(
      "${base_url}/homeListings/toggleLikeStatus",
    );
    try {
      final response =
          await http.post(url, body: {'listingID': id, 'userID': uid});

      isFavourite = !isFavourite!;
      if (isFavourite!) {
        likes = likes + 1;
      } else {
        likes = max(0, likes - 1);
      }
    } catch (err) {
      throw err;
    }

    notifyListeners();
  }

  Future<void> toggleRequest() async {
    Uri url = Uri.parse("${base_url}/homeListings/toggleRequestStatus");
    try {
      final response = await http.post(
        url,
        body: {'listingID': id, 'userID': uid},
      );
      isRequested = !isRequested!;
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }

  Listing.fromJson(Map<String, dynamic> jsonObj)
      : id = jsonObj['_id'],
        title = jsonObj['title'],
        description = jsonObj['description'],
        category = jsonObj['category'],
        postTimeStamp = DateTime.parse(jsonObj['postTimeStamp']),
        sharedTimeStamp = jsonObj['sharedTimeStamp'] != null
            ? DateTime.parse(jsonObj['sharedTimeStamp'])
            : null,
        status = jsonObj['status'],
        owner = jsonObj['owner'],
        location = jsonObj['location'],
        imagePath = jsonObj['imagePath'],
        requests = jsonObj['requests'],
        likes = jsonObj['likes'],
        requestedUsers = jsonObj['requestedUsers'],
        sharedUserID = jsonObj['sharedUserID'];
}
