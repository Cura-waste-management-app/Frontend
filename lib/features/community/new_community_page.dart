import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/community.dart';

class NewCommunityPage extends StatefulWidget {
  const NewCommunityPage({Key? key}) : super(key: key);

  @override
  _NewCommunityPageState createState() => _NewCommunityPageState();
}

class _NewCommunityPageState extends State<NewCommunityPage> {
  final _formKey = GlobalKey<FormState>();

  late String _communityName;
  late String _imgURL;
  late String _description;
  late String _category = 'Food';
  late String _location;

  File? _imageFile;
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Select image source'),
        actions: <Widget>[
          TextButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: Text('Gallery'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new community'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Community name field

                  // Picture field
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Expanded(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: ClipOval(
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: _imageFile == null
                                    ? Icon(Icons.camera_alt,
                                        size: 48, color: Colors.grey)
                                    : Image.file(_imageFile!,
                                        fit: BoxFit.scaleDown),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
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

                  SizedBox(height: 16),

                  // Description field
                  TextFormField(
                    minLines: 4,
                    maxLines: 10,
                    maxLength: null,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(200),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Description',
                      counterText: 'max 200 char',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _description = newValue!,
                  ),

                  SizedBox(height: 16),

                  // Category field
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: InputDecoration(
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

                  SizedBox(height: 16),

                  // Location field
                  TextFormField(
                    decoration: InputDecoration(
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
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            final newCommunity = Community(
              name: _communityName,
              imgURL: '',
              description: _description,
              category: _category,
              location: _location,
              adminId: '2',
              totalMembers: '1',
            );
            if (_imageFile != null) {
              final progressDialog = ProgressDialog(context);
              progressDialog.show();
              final imageUrl = await uploadImage(_imageFile!);

              progressDialog.dismiss();
              newCommunity.imgURL = imageUrl;
            }

            await saveCommunityToDatabase(newCommunity);

            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  saveCommunityToDatabase(newCommunity) {}
}
