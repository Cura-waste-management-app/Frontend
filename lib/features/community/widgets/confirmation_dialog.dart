import 'package:flutter/material.dart';

import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';

class ConfirmationDialog extends StatelessWidget {
  final String entityId;
  final DialogType dialogType;
  final DialogActionType dialogActionType;

  final VoidCallback changeMemberState;
  const ConfirmationDialog(
      {super.key,
      required this.entityId,
      required this.changeMemberState,
      required this.dialogType,
      required this.dialogActionType});

  @override
  Widget build(BuildContext context) {
    print("in dialog");
    return AlertDialog(
      title: const Text('Delete Event'),
      content: Text(
          'Are you sure you want to ${dialogActionType.type} this ${dialogType.type == DialogType.community.type ? 'community' : 'event'}?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(dialogActionType.type),
          onPressed: () async {
            await deleteEvent(entityId);
            // Call API to delete event
            Navigator.of(context).pop();
            // Remove widget from screen
          },
        ),
      ],
    );
  }

  Future<void> deleteEvent(String eventId) async {
    //TODO: delete event
    print("delete event ${eventId}");
    changeMemberState();
    // Call delete event API
  }
}
