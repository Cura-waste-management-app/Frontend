import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/common/snack_bar_widget.dart';
import 'package:cura_frontend/features/community/Util/populate_random_data.dart';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/image_loader/load_network_image.dart';
import '../../constants.dart';
import '../../models/event.dart';
import '../conversation/providers/conversation_providers.dart';
import 'models/entity_modifier.dart';

class NewEventPage extends ConsumerStatefulWidget {
  static const routeName = '/new-event';
  NewEventPage({Key? key, this.event, required this.entityModifier})
      : super(key: key);
  final Event? event;
  final EntityModifier entityModifier;
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends ConsumerState<NewEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameKey = GlobalKey<FormFieldState>();
  final defaultImgURL = '';
  bool _eventNameExists = false;
  late bool _imageUpdated = false;
  late Event _event = PopulateRandomData.event;
  var _descriptionController = TextEditingController();
  late String pageHeader;
  final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: true);
  final _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    pageHeader = "${widget.entityModifier.type} Event";
    if (widget.event != null) {
      _event = widget.event!;
      _descriptionController =
          TextEditingController(text: widget.event!.description);
    }
    _descriptionController.addListener(_updateDescription);
  }

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
          _event.imgURL = pickedFile.path;
          _imageUpdated = true;
        });
      }
    }
  }

  Future<String> uploadImage() async {
    if (_event.imgURL == '') return '';
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_event.imgURL,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBarWidget(text: imageUploadErrorText).getSnackBar());
      print(e.message);
      return "Error";
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateDescription() {
    setState(() {
      _event.description = _descriptionController.text;
    });
  }
  // final _picker = ImagePicker();
  //
  // _pickImage()async{
  //   String url=await pickImage(context,_picker);
  //   setState(() {
  //     _event.imgURL=url;
  //   });
  // }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        leadingWidth: 0,
        title: Text(pageHeader, style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(20),
                getProportionateScreenHeight(16),
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
                              backgroundColor: _event.imgURL == defaultImgURL
                                  ? Colors.grey
                                  : Colors.transparent,
                              radius: getProportionateScreenWidth(35),
                              child: _event.imgURL == defaultImgURL
                                  ? Icon(Icons.camera_alt,
                                      size: getProportionateScreenHeight(40),
                                      color: Colors.white)
                                  : _event.imgURL.startsWith(
                                          'http') //todo handle image here
                                      ? LoadNetworkImage(
                                          imageURL: _event.imgURL)
                                      : Image.file(File(_event.imgURL)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      const Icon(
                        Icons.drive_file_rename_outline_sharp,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(12),
                      ),
                      Expanded(
                        child: TextFormField(
                          key: _eventNameKey,
                          initialValue: _event.name,
                          decoration: const InputDecoration(
                            labelText: 'Event name',
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                          ),
                          onChanged: (value) {
                            if (value != _event.name && _eventNameExists) {
                              _eventNameExists = false;
                              _eventNameKey.currentState?.validate();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event name';
                            } else if (_eventNameExists) {
                              return 'Event name already exists';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _event.name = newValue!,
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
                      SizedBox(
                        width: getProportionateScreenWidth(12),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _descriptionController,
                          minLines: 1,
                          maxLines: 10,
                          maxLength: 200,
                          decoration: InputDecoration(
                              labelText: 'Description',
                              contentPadding: EdgeInsets.fromLTRB(
                                  getProportionateScreenWidth(25),
                                  getProportionateScreenHeight(18),
                                  getProportionateScreenWidth(20),
                                  getProportionateScreenHeight(18)),
                              counterText: '${_event.description.length}/200',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidth(12)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _event.description = newValue!,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: getProportionateScreenWidth(16)),

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
                          initialValue: _event.location,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            // labelStyle: TextStyle(),
                            contentPadding: EdgeInsets.fromLTRB(
                                getProportionateScreenWidth(25),
                                getProportionateScreenHeight(18),
                                getProportionateScreenWidth(20),
                                getProportionateScreenHeight(18)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(8))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _event.location = newValue!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _formKey.currentState!.save();
          // await checkIfEventNameExists();
          if (_formKey.currentState!.validate()) {
            await saveEventToDatabase();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  //todo refactor dialog
  saveEventToDatabase() async {
    if (_event.imgURL != '' && _imageUpdated) {
      final progressDialog = ProgressDialog(context);
      progressDialog.show();
      _event.imgURL = await uploadImage();
      progressDialog.dismiss();
    }
    if (_event.imgURL == 'Error') return;
    var eventDetail = {
      'name': _event.name,
      'description': _event.description,
      // 'timestamp': DateTime.now().toString(),
      'imgURL': _event.imgURL == '' ? defaultNetworkImage : _event.imgURL,
      'location': _event.location,
    };
    print(eventDetail);
    // return;
    try {
      var response;
      if (widget.entityModifier.type == EntityModifier.create.type) {
        response = await http.post(
          Uri.parse(
              "$createEventAPI/${ref.read(communityIdProvider.notifier).state}/${ref.read(userIDProvider.notifier).state}"),
          body: eventDetail,
        );
      } else {
        // ref.refresh(conversationPartnersProvider);
        response = await http.put(
          Uri.parse("$updateEventAPI/${widget.event?.id}"),
          body: eventDetail,
        );
      }
      print(response.statusCode);
      if (response.statusCode >= 200 && response.statusCode < 210) {
        // Show success dialog
        ref.refresh(
            getEventsProvider(ref.read(communityIdProvider.notifier).state));
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Event ${widget.entityModifier.type}d"),
            content: Text(
                "Your event has been ${widget.entityModifier.type}d successfully."),
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
                "Unable to  ${widget.entityModifier.type} event. Please try again later."),
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
              "Unable to ${widget.entityModifier.type} event. Please try again later."),
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

  checkIfEventNameExists() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // setState(() {
    //   _eventNameExists = true;
    // });
    // print('got exist');
    // return;
    Response response =
        await http.get(Uri.parse('$checkIfEventNameExistAPI$_event.name'));

    if (response.statusCode >= 200 && response.statusCode <= 210) {
      if (jsonDecode(response.body)['exist'] == 'true') {
        setState(() {
          _eventNameExists = true;
        });
      }
    }
  }
}
