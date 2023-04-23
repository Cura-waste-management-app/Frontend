// ignore_for_file: avoid_print

import 'dart:convert';

// import 'package:cura_frontend/features/location/location.dart';
import 'package:cura_frontend/models/location.dart';
import 'package:cura_frontend/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import './constants/variables.dart';
import '../screens/Listings/models/listings.dart';

class HomeListingsNotifier extends ChangeNotifier {
  List<Listing> _displayItems = [];
  List<Listing> _mylistings = [];
  List<Listing> _myRequests = [];
  Map _userdata = {};
  Map _otheruserdata = {};
  Map get userdata {
    return _userdata;
  }

  Map get otheruserdata {
    return _otheruserdata;
  }
  // get items => _displayItems;

  Map<String, bool> displayChoices = {
    'all': true,
    'fav': false,
    'Food': false,
    'Cloth': false,
    'Furniture': false,
    'Other': false,
  };

  List<Listing> get items {
    String choice = "";
    displayChoices.forEach((key, value) {
      if (value == true) {
        choice = key;
      }
    });

    if (choice == 'all') {
      return [..._displayItems];
    }
    return _displayItems
        .where((element) => element.category == choice)
        .toList();
    // return [..._displayItems];
  }

  List<Listing> get favitems {
    String choice = "";
    displayChoices.forEach((key, value) {
      if (value == true) {
        choice = key;
      }
    });

    if (choice == 'all') {
      print("Hi mai aya");
      print(_displayItems.length);
      for (int i = 0; i < _displayItems.length; i++) {
        print(_displayItems[i].title);
      }

      return _displayItems
          .where((element) => element.isFavourite == true)
          .toList();
    }
    return _displayItems
        .where((element) =>
            element.isFavourite == true && element.category == choice)
        .toList();
  }

  void setChoices(String category) {
    print(category);
    displayChoices.forEach((key, value) {
      if (key != category) {
        displayChoices[key] = false;
      } else {
        displayChoices[key] = !displayChoices[key]!;
        if (displayChoices[key] == false) {
          displayChoices['all'] = true;
        }
      }
    });

    print(displayChoices);
    notifyListeners();
  }

  Future<void> fetchAndSetItems() async {
    //  print("testing");
    // print(getDistance({'latitude': 30.7334687, 'longitude': 76.6678},
    //     {'latitude': 30.716267, 'longitude': 76.8331602}));
    // Map<String, String> headers = await getHeaders();
    var response = await http.get(
      Uri.parse('$base_url/userListings/fetch/$uid'),
    );

    final data = response.body;
    Iterable list = json.decode(data);
    // print(json.decode(data));
    List<Listing> mylistings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _mylistings = mylistings;

    response = await http.get(Uri.parse('$base_url/userRequests/fetch/$uid'));

    list = json.decode(response.body);

    List<Listing> requestlistings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _myRequests = requestlistings;

    Uri url = Uri.parse(
      "${base_url}/homeListings/homeproducts/${uid}",
    );
    try {
      var response = await http.get(url);

      final data = response.body;
      // print(data['user']);
      final List fetchedItems = json.decode(data)['listings'];
      final Map userData = json.decode(data)['user'];
      _userdata = userData;
      final List likedItems = userData['itemsLiked'];
      final List reqItems = userData['itemsRequested'];
      // print(fetchedItems);
      // print(userData);

      // for (int i = 0; i < list.length; i++) {}
      // List<Listing> listings =
      //     List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

      List<Listing> dummyList = [];
      for (int i = 0; i < fetchedItems.length; i++) {
        print(fetchedItems[i]['title']);

        bool fav = false;
        bool req = false;

        for (int j = 0; j < reqItems.length; j++) {
          if (fetchedItems[i]['_id'].toString() == reqItems[j].toString()) {
            req = true;
            break;
          }
        }

        for (int j = 0; j < likedItems.length; j++) {
          if (fetchedItems[i]['_id'].toString() == likedItems[j].toString()) {
            fav = true;
            break;
          }
        }

        double dist =
            getDistance(userData['location'], fetchedItems[i]['location']);
        int distance = dist.toInt();

        dummyList.add(Listing(
          id: fetchedItems[i]['_id'],
          description: fetchedItems[i]['description'],
          title: fetchedItems[i]['title'],
          status: fetchedItems[i]['status'],
          requests: fetchedItems[i]['requestedUsers'].length,
          distance: distance,

          likes: fetchedItems[i]['likes'],
          isFavourite: fav,
          isRequested: req,
          postTimeStamp: DateTime.parse(fetchedItems[i]['postTimeStamp']),
          location: Location(
            street: fetchedItems[i]['location']['street'],
            postalCode: fetchedItems[i]['location']['postalCode'],
            city: fetchedItems[i]['location']['city'],
            state: fetchedItems[i]['location']['state'],
            latitude: fetchedItems[i]['location']['latitude'],
            longitude: fetchedItems[i]['location']['longitude'],
          ),
          // userImageURL: 'assets/images/female_user.png',
          owner: User(
            name: fetchedItems[i]['owner']['name'],
            id: fetchedItems[i]['owner']['_id'],
            avatarURL: fetchedItems[i]['owner']['avatarURL'],
          ),
          category: fetchedItems[i]['category'],
          imagePath: fetchedItems[i]['imagePath'],
        ));
      }

      _displayItems = dummyList;
      // for (int i = 0; i < _displayItems.length; i++) {
      //   print(_displayItems[i].isFavourite);
      // }
      // print(listings);
      // notifyListeners();
      // return listings;
    } catch (err) {
      throw err;
    }
    print("Hi");
    notifyListeners();
  }

  Listing findById(String id) {
    return _displayItems.firstWhere((element) => element.id == id);
  }

  Future<void> findByIdAndToggleFavourite(String id) async {
    final item = _displayItems.firstWhere((element) => element.id == id);
    Uri url = Uri.parse("${base_url}/homeListings/toggleLikeStatus");
    try {
      final response = await http.post(
        url,
        body: {'listingID': id, 'userID': uid},
      );
      item.isFavourite = !item.isFavourite!;
      if (item.isFavourite!) {
        item.likes = item.likes + 1;
      } else {
        item.likes = max(0, item.likes - 1);
      }
    } catch (err) {
      throw err;
    }

    notifyListeners();
  }

  Future<void> findByIdAndToggleRequest(String id) async {
    final item = _displayItems.firstWhere((element) => element.id == id);
    Uri url = Uri.parse("${base_url}/homeListings/toggleRequestStatus");

    try {
      final response = await http.post(
        url,
        body: {'listingID': id, 'userID': uid},
      );
      item.isRequested = !item.isRequested!;
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }

  Future<void> sendItem(
    Map<String, dynamic> listingObj,
  ) async {
    Uri url = listingObj['type'] == 'add'
        ? Uri.parse("$base_url/userListings/addListing")
        : Uri.parse("$base_url/userListings/updateListing");

    try {
      await http.post(
        url,
        body: {
          'listingID': listingObj['listingID'],
          'title': listingObj['title'],
          'description': listingObj['description'],
          'category': listingObj['category'],
          'imagePath': listingObj['imagePath'],
          'location': json.encode(listingObj['location']!.toJson()),
          'ownerID': listingObj['ownerID'],
        },
      );

      // _displayItems.insert(0, item);
    } catch (err) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> getUserInfo(String uid) async {
    Uri url = Uri.parse(
      "$base_url/homeListings/ownerinfo/$uid",
    );
    try {
      final response = await http.get(
        url,
      );
      final data = response.body;
      final Map userData = json.decode(data);
      _otheruserdata = userData;
      print(userData['name']);
      print("HIIIIII");
      // print(userData['totallisted']);
      // return _otheruserdata;
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }

  Listing myItemsFindById(String id) {
    return _mylistings.firstWhere((element) => element.id == id);
  }

  Listing myRequestsFindById(String id) {
    return _myRequests.firstWhere((element) => element.id == id);
  }

  Future<void> fetchListings() async {
    var response = await http.get(
      Uri.parse('$base_url/userListings/fetch/$uid'),
    );

    final data = response.body;
    Iterable list = json.decode(data);
    // print(json.decode(data));
    List<Listing> mylistings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _mylistings = mylistings;
  }

  Future<void> fetchRequests() async {
    var response =
        await http.get(Uri.parse('$base_url/userRequests/fetch/$uid'));

    Iterable list = json.decode(response.body);

    List<Listing> requestlistings =
        List<Listing>.from(list.map((obj) => Listing.fromJson(obj)));

    _myRequests = requestlistings;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  double getDistance(Map userLoc, Map listingLoc) {
    var R = 6371; // Radius of the earth in km
    double lat1 = userLoc['latitude']!;
    double lon1 = userLoc['longitude']!;
    double lat2 = listingLoc['latitude']!;
    double lon2 = listingLoc['longitude']!;

    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  //  print("testing");
  //   print(getDistance({'latitude': 30.7334687, 'longitude': 76.6678},
  //       {'latitude': 30.716267, 'longitude': 76.8331602}));
}
