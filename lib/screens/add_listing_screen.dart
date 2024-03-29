// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/screens/add_listing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../common/debug_print.dart';
import '../../common/error_screen.dart';
import '../../models/location.dart' as address;
import '../constants.dart';
import '../providers/home_listings_provider.dart';
import '../server_ip.dart';
import 'Listings/models/listings.dart';

class AddListingScreen extends StatefulWidget {
  static const routeName = '/add-listing';

  const AddListingScreen({super.key});
  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  String? listingID = "";
  XFile? image;
  String imgpath =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1JAyQZTGv-0NMe630u5GeVkPU7oiCONzfEQ&usqp=CAU";
  String initialImage = "";
  String category = "Other";
  final List<String> categories = ['Food', 'Cloth', 'Furniture', 'Other'];
  address.Location? location;
  final ImagePicker picker = ImagePicker();
  final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: true);
  final _formKey = GlobalKey<FormState>();
  bool isImageNull = false;
  final String imageError = "Please provide an image of the item!";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  bool isSendingData = false;
  bool loadingLocation = false;

  void getCurrentLocation() async {
    setState(() {
      loadingLocation = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const ErrorScreen(error: "LOCATION PERMISION NOT GIVEN");
        }));
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media, imageQuality: 10);

    // final file = File(img!.path);
    // final fileSizeInBytes = file.lengthSync();
    // final fileSizeInKB = fileSizeInBytes / 1024;

    // prints('Selected image size: $fileSizeInKB KB');

    setState(() {
      image = img;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    titleController.dispose();
    descriptionController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
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

  void sendListingDetails(
      context, String type, String finalImage, String uid) async {
    if (initialImage == "" && image == null) {
      setState(() {
        isImageNull = true;
        isSendingData = false;
      });
    } else {
      var res = await Provider.of<HomeListingsNotifier>(context, listen: false)
          .sendItem({
        'listingID': listingID,
        'title': titleController.text,
        'description': descriptionController.text,
        'category': category,
        'imagePath': finalImage,
        'location': location,
        'ownerID': uid,
        'type': type
      });

      await Provider.of<HomeListingsNotifier>(context, listen: false)
          .fetchListings();

      setState(() {
        isSendingData = false;
      });

      if (res == "Listing updated successfully!") {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBarWidget(text: "Oops, $res Please try again later!")
                .getSnackBar());
      }
    }
  }

  void initializeValues(Listing? listing) {
    if (listing != null) {
      setState(() {
        listingID = listing.id;
        titleController.text = listing.title;
        descriptionController.text = listing.description!;
        category = listing.category;

        streetController.text = listing.location.street;
        postalCodeController.text = listing.location.postalCode;
        cityController.text = listing.location.city;
        stateController.text = listing.location.state;

        location = address.Location(
            street: listing.location.street,
            postalCode: listing.location.postalCode,
            city: listing.location.city,
            state: listing.location.state,
            latitude: listing.location.latitude,
            longitude: listing.location.longitude);

        initialImage = listing.imagePath;
        imgpath = listing.imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddListingArguments args =
        ModalRoute.of(context)!.settings.arguments as AddListingArguments;
    Listing? listing = args.listing;
    initializeValues(listing);

    final pageTitle = args.type == 'add' ? 'Add New Item' : 'Update Item';

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
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(16)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: getProportionateScreenHeight(300),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(getProportionateScreenHeight(10)))),
                    elevation: getProportionateScreenHeight(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        image != null
                            ? SizedBox(
                                width: getProportionateScreenWidth(200),
                                height: getProportionateScreenHeight(200),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(10),
                                      bottom: getProportionateScreenHeight(5)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          getProportionateScreenHeight(10)),
                                      bottomRight: Radius.circular(
                                          getProportionateScreenHeight(10)),
                                    ),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              )
                            : initialImage != ""
                                ? SizedBox(
                                    width: getProportionateScreenWidth(200),
                                    height: getProportionateScreenHeight(200),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: getProportionateScreenHeight(10),
                                          bottom:
                                              getProportionateScreenHeight(5)),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                getProportionateScreenHeight(
                                                    10)),
                                            bottomRight: Radius.circular(
                                                getProportionateScreenHeight(
                                                    10)),
                                          ),
                                          child: Image.network(initialImage)),
                                    ),
                                  )
                                : SizedBox(
                                    height: getProportionateScreenHeight(200),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: getProportionateScreenHeight(
                                              105)),
                                      child: Text(
                                        "No Image Selected",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    20)),
                                      ),
                                    ),
                                  ),
                        IconButton(
                          onPressed: () {
                            myAlert();
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            size: getProportionateScreenHeight(35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isImageNull
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(6)),
                        child: Text(imageError,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : const Text(''),
                TextFormField(
                  maxLength: textFieldMaxLength - 5,
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title*'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    titleController.text = value!;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    descriptionController.text = value!;
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
                isSendingData == false
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // imageUpload(image!.path);

                              setState(() {
                                isSendingData = true;
                              });
                              // final stopwatch = Stopwatch()..start();

                              String finalImage = imgpath;
                              if (image != null) {
                                prints("uploading image to cloud");
                                try {
                                  CloudinaryResponse response =
                                      await cloudinary.uploadFile(
                                    CloudinaryFile.fromFile(image!.path,
                                        resourceType:
                                            CloudinaryResourceType.Image),
                                  );

                                  prints(response.secureUrl);
                                  finalImage = response.secureUrl;
                                } on CloudinaryException catch (e) {
                                  prints("Ye kya hogya");
                                  prints(e.message);
                                  prints(e.request);
                                }
                              }
                              prints(finalImage);
                              _formKey.currentState!.save();
                              // stopwatch.stop();
                              // final timeTaken = stopwatch.elapsed;

                              // prints('Time taken: $timeTaken');
                              sendListingDetails(
                                  context, args.type, finalImage, args.uid);
                            }
                          },
                          child: Text(
                              args.type == 'add' ? 'Add Item' : 'Update Item'),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
