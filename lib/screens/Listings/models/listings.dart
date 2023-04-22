import 'package:cura_frontend/models/location.dart';
import 'package:cura_frontend/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../../providers/constants/variables.dart';

class Listing with ChangeNotifier {
  String id;
  String title;
  String? description;
  final String category;
  bool? isFavourite;
  bool? isRequested;
  DateTime postTimeStamp;
  DateTime? sharedTimeStamp;
  String status;
  final User owner;
  Location location;
  String imagePath;
  int requests;
  int likes;
  List<User>? requestedUsers;
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
      "$base_url/homeListings/toggleLikeStatus",
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
    Uri url = Uri.parse("$base_url/homeListings/toggleRequestStatus");
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
        owner = User(
          id: jsonObj['owner']['_id'],
          name: jsonObj['owner']['name'],
          avatarURL: jsonObj['owner']['avatarURL'],
          points: jsonObj['owner']['points'],
          itemsReceived: jsonObj['owner']['itemsReceived'],
          itemsShared: jsonObj['owner']['itemsShared']
        ),
        location = Location(
            street: jsonObj['location']['street'],
            postalCode: jsonObj['location']['postalCode'],
            city: jsonObj['location']['city'],
            state: jsonObj['location']['state'],
            latitude: jsonObj['location']['latitude'],
            longitude: jsonObj['location']['longitude']),
        imagePath = jsonObj['imagePath'],
        requests = jsonObj['requests'],
        likes = jsonObj['likes'],
        requestedUsers = List<User>.from(jsonObj['requestedUsers'].map((obj) => User.fromJson(obj))),
        sharedUserID = jsonObj['sharedUserID'];
}
