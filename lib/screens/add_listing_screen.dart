// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/providers/constants/variables.dart';
import 'package:cura_frontend/screens/add_listing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../common/error_screen.dart';
import '../../models/location.dart' as address;
import '../providers/home_listings_provider.dart';
import 'Listings/models/listings.dart';

class AddListingScreen extends StatefulWidget {
  static const routeName = '/user-details';

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
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
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

  void getCurrentLocation() async {
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

  void sendUserDetails(context, String type, String finalImage) async {
    if (initialImage == "" && image == null) {
      setState(() {
        isImageNull = true;
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
                isSendingData == false
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // imageUpload(image!.path);

                              setState(() {
                                isSendingData = true;
                              });

                              String finalImage = imgpath;
                              if (image != null) {
                                print("uploading image to cloud");
                                try {
                                  CloudinaryResponse response =
                                      await cloudinary.uploadFile(
                                    CloudinaryFile.fromFile(image!.path,
                                        resourceType:
                                            CloudinaryResourceType.Image),
                                  );

                                  print(response.secureUrl);
                                  finalImage = response.secureUrl;
                                } on CloudinaryException catch (e) {
                                  print("Ye kya hogya");
                                  print(e.message);
                                  print(e.request);
                                }
                              }
                              print(finalImage);
                              _formKey.currentState!.save();
                              sendUserDetails(context, args.type, finalImage);
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
