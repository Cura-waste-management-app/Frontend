import 'dart:convert';
import 'dart:io';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../models/community.dart';
import 'Util/populate_random_data.dart';
import 'models/entity_modifier.dart';

class NewCommunityPage extends ConsumerStatefulWidget {
  static const routeName = '/new-community';
  const NewCommunityPage(
      {Key? key, required this.entityModifier, this.community})
      : super(
          key: key,
        );
  final EntityModifier entityModifier;
  final Community? community;
  @override
  _NewCommunityPageState createState() => _NewCommunityPageState();
}

class _NewCommunityPageState extends ConsumerState<NewCommunityPage> {
  final _formKey = GlobalKey<FormState>();
  final _communityNameKey = GlobalKey<FormFieldState>();
  final defaultImgURL = '';
  late String pageHeader;
  bool _communityNameExists = false;
  late Community _community = PopulateRandomData.community;
  // late String _communityName;
  var _descriptionController = TextEditingController();
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select image source'),
        actions: <Widget>[
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _community.imgURL = pickedFile.path;
        });
      }
    }
  }

  Future<String> uploadImage() async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_community.imgURL,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      return "Err";
    }
  }

  @override
  void initState() {
    super.initState();
    pageHeader = "${widget.entityModifier.type} Community";
    if (widget.community != null) {
      _community = widget.community!;
      _descriptionController =
          TextEditingController(text: widget.community!.description);
    }
    _descriptionController.addListener(_updateDescription);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateDescription() {
    setState(() {
      _community.description = _descriptionController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: getProportionateScreenHeight(2),
        leadingWidth: getProportionateScreenWidth(0),
        leading: Container(),
        backgroundColor: Colors.white,
        title: Text(pageHeader, style: const TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(20),
                getProportionateScreenHeight(24),
                getProportionateScreenWidth(24),
                getProportionateScreenHeight(16)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: ClipOval(
                            child: CircleAvatar(
                              backgroundColor:
                                  _community.imgURL == defaultImgURL
                                      ? Colors.grey
                                      : Colors.transparent,
                              radius: getProportionateScreenWidth(35),
                              child: _community.imgURL == defaultImgURL
                                  ? Icon(Icons.camera_alt,
                                      size: getProportionateScreenHeight(40),
                                      color: Colors.white)
                                  : widget.entityModifier.type ==
                                          EntityModifier.create.type
                                      ? Image.file(File(_community.imgURL))
                                      : Image.network(
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            // return a fallback widget in case of error
                                            return Image.asset(
                                                defaultAssetImage);
                                          },
                                          _community.imgURL,
                                          fit: BoxFit.scaleDown,
                                        ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      Expanded(
                        child: TextFormField(
                            key: _communityNameKey,
                            initialValue: _community.name,
                            decoration: const InputDecoration(
                              labelText: 'Community name',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              )),
                            ),
                            onChanged: (value) {
                              if (value != _community.name &&
                                  _communityNameExists) {
                                setState(() {
                                  _communityNameExists = false;
                                  _communityNameKey.currentState?.validate();
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a community name';
                              } else if (_communityNameExists) {
                                return 'Community name already exists';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _community.name = newValue!),
                      ),
                    ],
                  ),

                  SizedBox(height: getProportionateScreenHeight(24)),

                  // Description field
                  Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _descriptionController,
                          minLines: 1,
                          maxLines: 10,
                          maxLength: 200,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            counterText: '${_community.description.length}/200',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _community.description = newValue!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),

                  // Category field
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(12),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _community.category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Food', 'Furniture', 'Cloth', 'Other']
                              .map((category) => DropdownMenuItem(
                                  value: category, child: Text(category)))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          onChanged: (newValue) =>
                              setState(() => _community.category = newValue!),
                          onSaved: (newValue) =>
                              _community.category = newValue!,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: getProportionateScreenHeight(24)),

                  // Location field
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(12),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _community.location,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _community.location = newValue!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          _formKey.currentState!.save();
          print(_community.name);
          await checkIfCommunityNameExists();
          if (_formKey.currentState!.validate()) {
            // if (_communityNameExists) return;
            if (_community.imgURL != '') {
              final progressDialog = ProgressDialog(context);
              progressDialog.show();
              _community.imgURL =
                  await uploadImage(); //todo check image is loaded
              progressDialog.dismiss();
            }

            print(_community.imgURL);
            print(_community.description);
            // await saveCommunityToDatabase(_community);

            // Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  saveCommunityToDatabase(Community newCommunity) async {
    var communityDetail = newCommunity.toJson();
    // print(communityDetail);
    try {
      var response;
      if (widget.entityModifier.type == EntityModifier.create.type) {
        response = await http.post(
          Uri.parse(
              "${ref.read(localHttpIpProvider)}community/createcommunity/${newCommunity.adminId}"),
          body: communityDetail,
        );
      } else {
        response = await http.post(
          Uri.parse(
              "${ref.read(localHttpIpProvider)}community/updatecommunity/${newCommunity.adminId}"),
          body: communityDetail,
        );
      }

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        ref.refresh(getUserCommunitiesProvider);
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Community ${widget.entityModifier.type}d"),
            content: Text(
                "Your community has been ${widget.entityModifier.type}d successfully."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: Text(
                "Unable to ${widget.entityModifier.type} community. Please try again later."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(
              "Unable to ${widget.entityModifier.type} community. Please try again later."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  checkIfCommunityNameExists() async {
    // await Future<void>.delayed(const Duration(milliseconds: 2000));
    // setState(() {
    //   _communityNameExists = true;
    // });
    // print('got exist');
    // return;
    Response response = await http
        .get(Uri.parse('$checkIfCommunityNameExistAPI$_community.name'));

    if (response.statusCode >= 200 && response.statusCode <= 210) {
      if (jsonDecode(response.body)['exist'] == 'true') {
        setState(() {
          _communityNameExists = true;
        });
      }
    }
  }
}
