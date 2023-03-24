import 'dart:io';
import 'package:cura_frontend/features/community/widgets/progress_dialog.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/event.dart';

class NewEventPage extends ConsumerStatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends ConsumerState<NewEventPage> {
  final _formKey = GlobalKey<FormState>();

  late String _eventName;
  late String _description = '';
  late String _location;

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
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title:
            Text('Create a new event', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 24, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.drive_file_rename_outline_sharp,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Event name',
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event name';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _eventName = newValue!,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Description field
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Colors.grey,
                      ),
                      SizedBox(
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(25, 18, 20, 18),
                              counterText: '${_description.length}/200',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
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

                  SizedBox(height: 16),

                  // Location field
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            // labelStyle: TextStyle(),
                            contentPadding: EdgeInsets.fromLTRB(25, 18, 20, 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            await saveEventToDatabase();

            // Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  saveEventToDatabase() async {
    var eventDetail = {
      'name': _eventName,
      'description': _description,
      'timestamp': DateTime.now().toString(),
      'location': _location,
    };
    print(eventDetail);
    await http.post(
      Uri.parse(
          "${ref.read(localHttpIpProvider)}event/createEvent/${ref.read(communityIdProvider.notifier).state}/${ref.read(userIDProvider.notifier).state}"),
      body: eventDetail,
    );
  }
}
