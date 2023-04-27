// ignore_for_file: avoid_print
import 'dart:ffi';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../common/error_screen.dart';
import '../../models/location.dart' as address;
import 'dart:convert';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../util/helpers.dart';

class UserDetails extends StatefulWidget {
  static const routeName = '/user-details';

  const UserDetails({super.key});
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String userName = "";
  String emailID = "";
  String userRole = "Individual";
  String uci = "";

  final List<String> userRoles = ['Individual', 'NGO', 'Restaurant'];
  address.Location? location;

  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  bool userNameExists = false;
  bool uciInvalid = false;
  final _formKey = GlobalKey<FormState>();

  final String nameError =
      "Username already exists! Please try another username";

  final uciError = "UCI code is not valid!";

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ErrorScreen(error: "LOCATION PERMISION NOT GIVEN");
        }));
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // var lastPosition = await Geolocator.getLastKnownPosition();
    // // ignore: avoid_print
    print(Position);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks.first;
    print(placemark);

    setState(() {
      location = address.Location(
          latitude: position.latitude,
          longitude: position.longitude,
          street: placemark.street!,
          postalCode: placemark.postalCode!,
          city: placemark.locality!,
          state: placemark.administrativeArea!);
    });
    streetController.text = location!.street;
    postalCodeController.text = location!.postalCode;
    cityController.text = location!.city;
    stateController.text = location!.state;
    // List<Location> locations = await locationFromAddress(location);
    // if (locations.isNotEmpty) {
    //   print(locations[0].longitude);
    // }
  }

  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    print("idtoken- $idtoken");
    // print("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

    return headers;
  }

  void sendUserDetails(context, String firebaseUID) async {
    // const firebaseUID = "123"; // set uid of user
    var response = await http.post(
      Uri.parse('$base_url/user/addUser'),
      body: {
        'uid': firebaseUID,
        'name': userName,
        'role': userRole,
        'emailID': emailID,
        'uciCode': uci,
        'location': json.encode(location!.toJson())
      },
    );
    print('response :${response.body}');
    var user = json.decode(response.body);

    if (response.body == nameError) {
      print(response.body);
      setState(() {
        userNameExists = true;
      });
    } else if (response.body == uciError) {
      setState(() {
        uciInvalid = true;
      });
    } else if (response.statusCode >= 200 && response.statusCode <= 210) {
      setState(() {
        userNameExists = false;
      });
      setState(() {
        uciInvalid = false;
      });
      // Provider.of<UserNotifier>(context, listen: false).user =
      //     User.fromJson(jsonDecode(response.body));

      // set uid
      var userData = await Hive.openBox(userDataBox);
      userData.put('uid', user['_id']);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeListings()));
    } else {
      handleApiErrors(response.statusCode, context: context);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(width: 100.w, height: 100.h);
    Map argsObj = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(16)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username*'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                ),
                userNameExists
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(6)),
                        child: Text(nameError,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : const Text(''),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Email ID (optional)'),
                  onSaved: (value) {
                    emailID = value!;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Role*'),
                  value: userRole,
                  items: userRoles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      userRole = value!;
                    });
                  },
                ),
                userRole != "Individual"
                    ? TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'UCI code (provided by Cura)'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please contact cura8090@gmail.com to get UCI code!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          uci = value!;
                        },
                      )
                    : const Text(''),
                uciInvalid
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(6)),
                        child: Text(uciError,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : const Text(''),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Please provide your location'),
                    Column(
                      children: [
                        FloatingActionButton.small(
                          onPressed: getCurrentLocation,
                          backgroundColor: Colors.grey.shade100,
                          child: const Icon(Icons.add_location,
                              color: Colors.black),
                        ),
                        Text(
                          "Live",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(13),
                              color: Colors.grey.shade500),
                        )
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: streetController,
                  decoration:
                      const InputDecoration(labelText: 'House No./ Street*'),
                  onSaved: (value) {
                    location!.street = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your street name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal code*'),
                  onSaved: (value) {
                    location!.postalCode = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a your postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City*'),
                  onSaved: (value) {
                    location!.city = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State*'),
                  onSaved: (value) {
                    location!.state = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(location!.street);
                        sendUserDetails(context, argsObj['firebaseUID']);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
