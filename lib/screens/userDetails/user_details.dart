// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../common/debug_print.dart';
import '../../common/error_screen.dart';
import '../../features/conversation/providers/conversation_providers.dart';
import '../../models/location.dart' as address;
import '../../models/user.dart';
import '../../util/helpers.dart';

class UserDetails extends ConsumerStatefulWidget {
  static const routeName = '/user-details';

  const UserDetails({super.key});
  @override
  ConsumerState<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
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
  bool loadingLocation = false;
  bool sendingData = false;

  final _formKey = GlobalKey<FormState>();

  final String nameError =
      "Username already exists! Please try another username";

  final uciError = "UCI code is not valid!";

  void getCurrentLocation() async {
    setState(() {
      loadingLocation = true;
    });
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
    prints(Position);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks.first;
    prints(placemark);

    setState(() {
      location = address.Location(
          latitude: position.latitude,
          longitude: position.longitude,
          street: placemark.street!,
          postalCode: placemark.postalCode!,
          city: placemark.locality!,
          state: placemark.administrativeArea!);
      loadingLocation = false;
    });
    streetController.text = location!.street;
    postalCodeController.text = location!.postalCode;
    cityController.text = location!.city;
    stateController.text = location!.state;
    // List<Location> locations = await locationFromAddress(location);
    // if (locations.isNotEmpty) {
    //   prints(locations[0].longitude);
    // }
  }

  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idtoken = prefs.getString('uid');
    prints("idtoken- $idtoken");
    // prints("in lisings");
    Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

    return headers;
  }

  void sendUserDetails(context, String firebaseUID) async {
    setState(() {
      userNameExists = false;
      uciInvalid = false;
      sendingData = true;
    });

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
    setState(() {
      sendingData = false;
    });
    prints('response :${response.statusCode}');
    var resObj = json.decode(response.body);
    prints(resObj['message']);

    if (response.statusCode == 409 && resObj['message'] == nameError) {
      setState(() {
        userNameExists = true;
      });
    } else if (response.statusCode == 400 && resObj['message'] == uciError) {
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

      var jsonData = jsonDecode(response.body);
      ref.read(userIDProvider.notifier).state = jsonData['_id'];
      ref.read(userProvider.notifier).state = User.fromJson(jsonData);
      ref.read(conversationSocketProvider(jsonData['_id'])).connect();
      var userData = await Hive.openBox(userDataBox);
      userData.put('uid', resObj['_id']);

      Navigator.pushNamedAndRemoveUntil(
          context, HomeListings.routeName, (_) => false);
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
                uciInvalid && userRole != "Individual"
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
                        loadingLocation
                            ? SizedBox(
                                height: getProportionateScreenWidth(20),
                                width: getProportionateScreenWidth(20),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : FloatingActionButton.small(
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
                  child: sendingData
                      ? SizedBox(
                          height: getProportionateScreenWidth(20),
                          width: getProportionateScreenWidth(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              prints(location!.street);
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
