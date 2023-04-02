import 'dart:io';
import 'package:cura_frontend/common/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/community.dart';

class NewCommunityPage extends ConsumerStatefulWidget {
  const NewCommunityPage({Key? key}) : super(key: key);

  @override
  _NewCommunityPageState createState() => _NewCommunityPageState();
}

class _NewCommunityPageState extends ConsumerState<NewCommunityPage> {
  final _formKey = GlobalKey<FormState>();

  late String _communityName;
  late String _imgURL = 'as';
  late String _description = '';
  late String _category = 'Food';
  late String _location;

  File? _imageFile;
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
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_imageFile!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      return "Err";
    }
  }

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateDescription);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateDescription() {
    setState(() {
      _description = _controller.text;
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
        title: const Text('Create New Community',
            style: TextStyle(color: Colors.black)),
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
                        child: Expanded(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: ClipOval(
                              child: CircleAvatar(
                                backgroundColor: _imageFile == null
                                    ? Colors.grey
                                    : Colors.transparent,
                                radius: getProportionateScreenWidth(35),
                                child: _imageFile == null
                                    ? Icon(Icons.camera_alt,
                                        size: getProportionateScreenHeight(40),
                                        color: Colors.white)
                                    : Image.file(_imageFile!,
                                        fit: BoxFit.scaleDown),
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
                          decoration: const InputDecoration(
                            labelText: 'Community name',
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a community name';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _communityName = newValue!,
                        ),
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
                          controller: _controller,
                          minLines: 1,
                          maxLines: 10,
                          maxLength: 200,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            counterText: '${_description.length}/200',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _description = newValue!,
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
                          value: _category,
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
                              setState(() => _category = newValue!),
                          onSaved: (newValue) => _category = newValue!,
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
                          onSaved: (newValue) => _location = newValue!,
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
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            if (_imageFile != null) {
              final progressDialog = ProgressDialog(context);
              progressDialog.show();
              _imgURL = await uploadImage(_imageFile!);
              progressDialog.dismiss();
            }
            final newCommunity = Community(
              name: _communityName,
              imgURL: _imgURL,
              description: _description,
              category: _category,
              location: _location,
              adminId: ref.read(userIDProvider.notifier).state,
              totalMembers: '1',
            );
            await saveCommunityToDatabase(newCommunity);

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
      var response = await http.post(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}community/createcommunity/${newCommunity.adminId}"),
        body: communityDetail,
      );

      if (response.statusCode == 201) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Event Created"),
            content:
                const Text("Your community has been created successfully."),
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
            content: const Text(
                "Unable to create community. Please try again later."),
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
          content:
              const Text("Unable to create community. Please try again later."),
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
}
