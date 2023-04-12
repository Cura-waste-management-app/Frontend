// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../common/error_screen.dart';
import '../../models/location.dart' as address;
import '../providers/home_listings_provider.dart';

class AddListingScreen extends StatefulWidget {
  static const routeName = '/user-details';

  const AddListingScreen({super.key});
  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  XFile? image;
  String imgpath =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1JAyQZTGv-0NMe630u5GeVkPU7oiCONzfEQ&usqp=CAU";
  String title = "";
  String? description = "";
  String category = "Other";
  final List<String> categories = ['Food', 'Cloth', 'Furniture', 'Other'];
  address.Location? location;
  String pageTitle = "Add New Listing";
  final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  final _formKey = GlobalKey<FormState>();

  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  bool isImageNull = false;
  final String imageError = "Please provide an image of the item!";

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
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    print(img!.path);

    setState(() {
      image = img;
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
              height: MediaQuery.of(context).size.height / 6,
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

  void sendUserDetails(context) async {
    if (image == null) {
      setState(() {
        isImageNull = true;
      });
    } else {
      Provider.of<HomeListingsNotifier>(context, listen: false).addItem({
        'title': title,
        'description': description,
        'category': category,
        'imagePath': imgpath,
        'location': location,
        'ownerID': uid
      });
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          pageTitle,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        image == null
                            ? const SizedBox(
                                height: 200,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 100.0),
                                  child: Text(
                                    "No Image Selected",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 200,
                                height: 200,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 5),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                        IconButton(
                          onPressed: () {
                            myAlert();
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isImageNull
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                        child: Text(imageError,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : const Text(''),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title*'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Category*'),
                  value: category,
                  items: categories.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
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
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // imageUpload(image!.path);

                        try {
                          CloudinaryResponse response =
                              await cloudinary.uploadFile(
                            CloudinaryFile.fromFile(image!.path,
                                resourceType: CloudinaryResourceType.Image),
                          );

                          print(response.secureUrl);
                          imgpath = response.secureUrl;
                        } on CloudinaryException catch (e) {
                          print("Ye kya hogya");
                          print(e.message);
                          print(e.request);
                        }

                        _formKey.currentState!.save();
                        sendUserDetails(context);
                      }
                    },
                    child: const Text('Add Item'),
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
