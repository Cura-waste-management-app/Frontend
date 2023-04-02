import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/providers/community_providers.dart';
import 'package:http/http.dart' as http;
import 'package:cura_frontend/features/conversation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEventPage extends ConsumerStatefulWidget {
  NewEventPage({Key? key, this.eventName, this.description, this.location})
      : super(key: key);
  late String? eventName;
  late String? description = '';
  late String? location;
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends ConsumerState<NewEventPage> {
  final _formKey = GlobalKey<FormState>();

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
      widget.description = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        leadingWidth: 0,
        title: const Text('Create New Event',
            style: TextStyle(color: Colors.black)),
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
                          onSaved: (newValue) => widget.eventName = newValue!,
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
                          controller: _controller,
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
                              counterText:
                                  '${widget.description != null ? widget.description!.length : 0}/200',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenWidth(12)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          onSaved: (newValue) => widget.description = newValue!,
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
                          onSaved: (newValue) => widget.location = newValue!,
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

  //todo need to update event, community details to API
  //todo refactor dialog
  saveEventToDatabase() async {
    var eventDetail = {
      'name': widget.eventName,
      'description': widget.description,
      // 'timestamp': DateTime.now().toString(),
      'imgURL': 'assets/images/male_user.png',
      'location': widget.location,
    };
    print(eventDetail);
    try {
      var response = await http.post(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}events/createevent/${ref.read(communityIdProvider.notifier).state}/${ref.read(userIDProvider.notifier).state}"),
        body: eventDetail,
      );
      if (response.statusCode == 201) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Event Created"),
            content: const Text("Your event has been created successfully."),
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
            content:
                const Text("Unable to create event. Please try again later."),
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
              const Text("Unable to create event. Please try again later."),
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
