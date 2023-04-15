import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/Util/populate_random_data.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:http/http.dart' as http;
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/event.dart';
import '../conversation/providers/conversation_providers.dart';
import 'models/entity_modifier.dart';

//todo setup only admin can edit
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
  late Event _event = PopulateRandomData.event;
  var _descriptionController = TextEditingController();
  late String pageHeader;
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
                      const Icon(
                        Icons.drive_file_rename_outline_sharp,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(12),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _event.name,
                          decoration: const InputDecoration(
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
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            await saveEventToDatabase();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  //todo need to update community details to API
  //todo refactor dialog
  saveEventToDatabase() async {
    var eventDetail = {
      'name': _event.name,
      'description': _event.description,
      // 'timestamp': DateTime.now().toString(),
      'imgURL': 'assets/images/male_user.png', //todo change imgURL
      'location': _event.location,
    };
    print(eventDetail);
    // return;
    try {
      var response;
      if (widget.entityModifier.type == EntityModifier.create.type) {
        response = await http.post(
          Uri.parse(
              "${ref.read(localHttpIpProvider)}events/createevent/${ref.read(communityIdProvider.notifier).state}/${ref.read(userIDProvider.notifier).state}"),
          body: eventDetail,
        );
      } else {
        response = await http.put(
          Uri.parse(
              "${ref.read(localHttpIpProvider)}events/updateevent/${widget.event?.id}"),
          body: eventDetail,
        );
      }
      print(response.statusCode);
      if (response.statusCode >= 200 && response.statusCode < 210) {
        // Show success dialog
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
}
//todo change error dialog in event and community
