import 'package:flutter/material.dart';

import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String entityId;
  final DialogType dialogType;
  final DialogActionType dialogActionType;
  DeleteConfirmationDialog(
      {required this.entityId,
      required this.dialogType,
      required this.dialogActionType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Event'),
      content: Text('Are you sure you want to permanently delete this event?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
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
    // Call delete event API
  }
}
