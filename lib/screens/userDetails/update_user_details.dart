// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/providers/user_provider.dart';
import 'package:cura_frontend/screens/homeListings/home_listings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';
import '../../common/error_screen.dart';
import '../../models/location.dart' as address;
import 'dart:convert';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../../providers/home_listings_provider.dart';
import '../../constants.dart';

class UpdateUserDetails extends StatefulWidget {
  static const routeName = '/update-user-details';

  const UpdateUserDetails({super.key});
  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

// final FirebaseAuth auth = FirebaseAuth.instance;
// final user = auth.currentUser;
// final uid = user!.uid;

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  // Map user = Provider.of<HomeListingsNotifier>(context).userdata;
  String uid = "";
  bool isLoading = false;
  String userName = "";
  String emailID = "";
  String userRole = "Individual";
  String imgurl = "";
  String imgpath =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1JAyQZTGv-0NMe630u5GeVkPU7oiCONzfEQ&usqp=CAU";
  // final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);

  final List<String> userRoles = ['Individual', 'NGO', 'Restaurant'];
  address.Location? location;

  final emailIDcontroller = TextEditingController();
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  bool userNameExists = false;
  final _formKey = GlobalKey<FormState>();

  final String nameError =
      "Username already exists! Please try another username";

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

  void sendUserDetails(context) {
    // print(location!.street);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeListings()));
  }

  var isInit = true;
  @override
  void didChangeDependencies() {
    print(isInit);
    if (isInit) {
      Map user = Provider.of<HomeListingsNotifier>(context).userdata;
      // print(user['avatarURL'].length);
      if (user['avatarURL'] == null || user['avatarURL'].length == 0) {
        imgurl = "";
      } else {
        imgurl = user['avatarURL'];
      }

      // print(user['name']);
      userName = user['name'].toString();
      emailID = user['emailID'] == null ? "" : user['emailID'].toString();
      userRole = user['role'].toString();
      print(userName);
      print(emailID);
      emailIDcontroller.text = emailID;

      final loca = address.Location(
        street: user['location']['street'],
        postalCode: user['location']['postalCode'],
        city: user['location']['city'],
        state: user['location']['state'],
        latitude: user['location']['latitude'],
        longitude: user['location']['longitude'],
      );
      print(loca.street);
      location = loca;

      streetController.text = loca.street.toString();
      postalCodeController.text = loca.postalCode.toString();
      cityController.text = loca.city.toString();
      stateController.text = loca.state.toString();
    }
    isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // Future<Map<String, String>> getHeaders() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? idtoken = prefs.getString('uid');
  //   print("idtoken- $idtoken");
  //   // print("in lisings");
  //   Map<String, String>? headers = {'Authorization': 'Bearer $idtoken'};

  //   return headers;
  // }
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print(img!.path);

    setState(() {
      image = img;
    });
  }

  @override
  void initState() {
    super.initState();

    Provider.of<UserNotifier>(context, listen: false)
        .fetchUserInfo()
        .then((user) {
      setState(() {
        uid = user!.id;
      });
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: 100.h / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    image == null
                        ? ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(60), // Image radius
                              child: imgurl.length == 0
                                  ? Image.network(
                                      defaultNetworkImage,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imgurl,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )
                        : ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(60), // Image radius
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 2,
                      right: 10,
                      child: Container(
                          height: 40,
                          width: 40,
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: "btn2",
                                onPressed: () {
                                  print("hi");
                                  myAlert();
                                },
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.edit)),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: userName,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Username*'),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter a username';
                  //   }
                  //   return null;
                  // },
                  // onSaved: (value) {
                  //   userName = value!;
                  // },
                ),
                // userNameExists
                //     ? Padding(
                //         padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                //         child: Text(nameError,
                //             style: const TextStyle(color: Colors.red)),
                //       )
                //     : const Text(''),
                TextFormField(
                  controller: emailIDcontroller,
                  // initialValue: emailID,
                  decoration:
                      const InputDecoration(labelText: 'Email ID (optional)'),
                  onSaved: (value) {
                    emailIDcontroller.text = value!;
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
                  onChanged: null,
                ),
                const SizedBox(height: 10),
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
                              fontSize: 12, color: Colors.grey.shade500),
                        )
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  // initialValue: loca.street.toString(),
                  controller: streetController,
                  decoration:
                      const InputDecoration(labelText: 'House No./ Street*'),
                  onSaved: (value) {
                    streetController.text = value!;
                    // location!.street = value!;
                  },
                  validator: (value) {
                    if (streetController.text.isEmpty) {
                      return 'Please enter your street name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: postalCodeController,
                  // initialValue: loca.postalCode.toString(),
                  decoration: const InputDecoration(labelText: 'Postal code*'),
                  onSaved: (value) {
                    postalCodeController.text = value!;
                    // location!.postalCode = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a your postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // initialValue: loca.city.toString(),
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City*'),
                  onSaved: (value) {
                    cityController.text = value!;
                    // location!.city = value!;
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
                  // initialValue: loca.state.toString(),
                  decoration: const InputDecoration(labelText: 'State*'),
                  onSaved: (value) {
                    stateController.text = value!;
                    // location!.state = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      // print(imgurl);
                      if (_formKey.currentState!.validate()) {
                        if (image != null) {
                          try {
                            CloudinaryResponse response = await cloudinary
                                .uploadFile(
                              CloudinaryFile.fromFile(image!.path,
                                  resourceType: CloudinaryResourceType.Image),
                            )
                                .timeout(
                              const Duration(seconds: 10),
                              onTimeout: () {
                                throw new Exception("Timeout");
                              },
                            );

                            print(response.secureUrl);
                            imgurl = response.secureUrl;
                          } catch (e) {
                            print("Ye kya hogya");
                            // print(e.message);
                            // print(e.request);

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Could not change the profile picture",
                              ),
                              duration: const Duration(seconds: 10),
                              action:
                                  SnackBarAction(label: "Ok", onPressed: () {}),
                            ));

                            setState(() {
                              isLoading = false;
                            });

                            return;
                          }
                        }

                        _formKey.currentState!.save();

                        print("jai ho");
                        print(uid);
                        print(userRole);
                        print(emailIDcontroller.text);

                        location!.street = streetController.text;
                        location!.postalCode = postalCodeController.text;
                        location!.city = cityController.text;
                        location!.state = stateController.text;
                        print(location!.street);

                        final daatta = {
                          'uid': uid,
                          'name': userName,
                          'role': userRole,
                          'emailID': emailIDcontroller.text,
                          'location': json.encode(location!.toJson()),
                          'avatarURL': imgurl,
                        };
                        print(daatta['emailID']);
                        // Map<String, String> headers = await getHeaders();
                        var userData2 = await Hive.openBox(userDataBox);
                        print(userData2);
                        var uid2 = userData2.get('uid');

                        var response = await http.post(
                          Uri.parse('${base_url}/user/updateUser'),
                          body: {
                            'uid': uid2,
                            'role': userRole,
                            'name': userName,
                            'avatarURL': imgurl,
                            'emailID': emailIDcontroller.text,
                            'location': json.encode(location!.toJson())
                          },
                        ).timeout(
                          const Duration(seconds: 10),
                          onTimeout: () {
                            throw new Exception("Timeout");
                          },
                        ).then((_) async {
                          setState(() {
                            isLoading = false;
                          });
                          await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "Profile updated successfully"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ));
                          Navigator.of(context)
                              .pushReplacementNamed(HomeListings.routeName);
                        }).catchError((value) async {
                          setState(() {
                            isLoading = false;
                          });
                          await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "Could not update the profile"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ));

                          Navigator.of(context)
                              .pushReplacementNamed(HomeListings.routeName);
                        });

                        // sendUserDetails(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading == false
                        ? Text('Update')
                        : CircularProgressIndicator(),
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
