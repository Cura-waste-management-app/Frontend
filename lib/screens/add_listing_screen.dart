// import '../models/display_item.dart';
import '../screens/Listings/models/listings.dart';
import 'package:provider/provider.dart';
// import '../providers/listed_items.dart';
import '../providers/home_listings_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import '../image-uploads/cloudinary-upload.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class AddListingScreen extends StatefulWidget {
  // const AddListingScreen({super.key});
  static const routeName = '/add-listing';

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  XFile? image;
  String category = "";
  final descFocusNode = FocusNode();

  // var listItem = Listing(
  //   // userImageURL: "assets/images/male_user.png",
  //   id: DateTime.now().toString(),
  //   category: "Cloth",
  //   title: "",
  //   isFavourite: false,
  //   isRequested: false,
  //   description: "",
  //   requests: 0,
  //   imagePath: "",

  //   likes: 0,
  //   status: "Active",
  //   postTimeStamp: DateTime.now(),
  //   // distance: "2.5 km",
  //   owner: "Harsh Kumar",
  // );
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose

    descFocusNode.dispose();

    super.dispose();
  }

  final ImagePicker picker = ImagePicker();
  var img;
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    img = await picker.pickImage(source: media);
    print(img!.path);
    // print(image!.path);

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
            title: Text('Please choose media to select'),
            content: Container(
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
                      children: [
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
                      children: [
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

  void saveForm() {
    final isValid = form.currentState!.validate();

    if (isValid) {
      print("Valid");
      form.currentState!.save();
      // print(listItem.title);

      print(image!.path);
      // final itemsData =
      // Provider.of<ListedItems>(context, listen: false).addItem(listItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add New Item",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: form,
          child: ListView(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image == null
                        ? Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: const Text(
                                "No Image Selected",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 200,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        myAlert();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              // Card(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10))),
              //   elevation: 3,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     // crossAxisAlignment: CrossAxisAlignment.,
              //     children: [
              //       Container(
              //         // color: Colors.black54,
              //         height: 200,
              //         child: IconButton(
              //           onPressed: () {
              //             myAlert();
              //           },
              //           icon: Icon(Icons.camera_alt_outlined),
              //           iconSize: 50,
              //         ),
              //       ),
              //       image == null
              //           ? const Text(
              //               "No Image",
              //               style: TextStyle(fontSize: 20),
              //             )
              //           : Container(
              //               // padding: const EdgeInsets.only(horizontal: 5),
              //               child: SizedBox(
              //                 width: 200,
              //                 height: 200,
              //                 // borderRadius: BorderRadius.circular(8),
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.only(
              //                     topRight: Radius.circular(10),
              //                     bottomRight: Radius.circular(10),
              //                   ),
              //                   child: Image.file(
              //                     //to show image, you type like this.
              //                     File(image!.path),
              //                     fit: BoxFit.scaleDown,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //     ],
              //   ),
              // ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a Title';
                  }
                  return null;
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(descFocusNode);
                },
                onSaved: (value) {
                  // listItem = DisplayItem(
                  //   userImageURL: listItem.userImageURL,
                  //   id: listItem.id,
                  //   category: listItem.category,
                  //   title: value!,
                  //   isFavourite: false,
                  //   isRequested: false,
                  //   description: listItem.description,
                  //   imagePath: listItem.imagePath,
                  //   rating: listItem.rating,
                  //   requests: 0,
                  //   views: listItem.views,
                  //   likes: listItem.likes,
                  //   status: listItem.status,
                  //   timeAdded: listItem.timeAdded,
                  //   distance: listItem.distance,
                  //   owner: listItem.owner,
                  // );
                },
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                textInputAction: TextInputAction.done,
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                focusNode: descFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a Description';
                  }
                  if (value.length < 10 || value.length > 30) {
                    return "Length limit is 10 to 30 characters";
                  }
                  return null;
                },
                // onFieldSubmitted: (_) {
                //   saveForm();
                // },
                onSaved: (value) {
                  // listItem = DisplayItem(
                  //   userImageURL: listItem.userImageURL,
                  //   id: listItem.id,
                  //   category: listItem.category,
                  //   title: listItem.title,
                  //   description: value!,
                  //   imagePath: listItem.imagePath,
                  //   isFavourite: false,
                  //   isRequested: false,
                  //   requests: 0,
                  //   rating: listItem.rating,
                  //   views: listItem.views,
                  //   likes: listItem.likes,
                  //   status: listItem.status,
                  //   timeAdded: listItem.timeAdded,
                  //   distance: listItem.distance,
                  //   owner: listItem.owner,
                  // );
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Food'),
                    value: 'Food',
                  ),
                  DropdownMenuItem(
                    child: Text('Cloth'),
                    value: 'Cloth',
                  ),
                  DropdownMenuItem(
                    child: Text('Furniture'),
                    value: 'Furniture',
                  ),
                  DropdownMenuItem(
                    child: Text('Other'),
                    value: 'Other',
                  ),
                ],
                onSaved: (value) {
                  // listItem = DisplayItem(
                  //   userImageURL: listItem.userImageURL,
                  //   id: listItem.id,
                  //   category: value!,
                  //   title: listItem.title,
                  //   description: listItem.description,
                  //   imagePath: listItem.imagePath,
                  //   isFavourite: false,
                  //   isRequested: false,
                  //   requests: 0,
                  //   rating: listItem.rating,
                  //   views: listItem.views,
                  //   likes: listItem.likes,
                  //   status: listItem.status,
                  //   timeAdded: listItem.timeAdded,
                  //   distance: listItem.distance,
                  //   owner: listItem.owner,
                  // );

                  // print(listItem.category);
                },
              ),
              TextButton(
                onPressed: () async {
                  // imageUpload(image!.path);
                  String imgpath =
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1JAyQZTGv-0NMe630u5GeVkPU7oiCONzfEQ&usqp=CAU";
                  try {
                    CloudinaryResponse response = await cloudinary.uploadFile(
                      CloudinaryFile.fromFile(img.path,
                          resourceType: CloudinaryResourceType.Image),
                    );

                    print(response.secureUrl);
                    imgpath = response.secureUrl;
                  } on CloudinaryException catch (e) {
                    print("Ye kya hogya");
                    print(e.message);
                    print(e.request);
                  }

                  // listItem = DisplayItem(
                  // userImageURL: listItem.userImageURL,
                  // id: listItem.id,
                  // requests: 0,
                  // category: listItem.category,
                  // title: listItem.title,
                  // description: listItem.description,
                  // imagePath: imgpath,
                  // rating: listItem.rating,
                  // views: listItem.views,
                  // isFavourite: false,
                  // isRequested: false,
                  // likes: listItem.likes,
                  // status: listItem.status,
                  // timeAdded: listItem.timeAdded,
                  // distance: listItem.distance,
                  // owner: listItem.owner,
                  // );
                  saveForm();
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
