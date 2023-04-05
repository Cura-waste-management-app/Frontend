import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../conversation/providers/chat_providers.dart';
import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';

class ConfirmationDialog extends ConsumerStatefulWidget {
  // final String? eventId;
  // final String communityId;
  final group;
  final DialogType dialogType;
  final DialogActionType dialogActionType;

  final VoidCallback changeMemberState;
  const ConfirmationDialog(
      {super.key,
      required this.group,
      required this.changeMemberState,
      required this.dialogType,
      required this.dialogActionType});

  @override
  ConsumerState<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends ConsumerState<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    print("in dialog");
    return AlertDialog(
      title: Text(
          '${widget.dialogActionType.type.toUpperCase()}  ${widget.dialogType.type.toUpperCase()}'),
      content: Text(
          'Are you sure you want to ${widget.dialogActionType.type} this ${widget.dialogType.type == DialogType.community.type ? 'community' : 'event'}?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.dialogActionType.type),
          onPressed: () async {
            widget.dialogType.type == DialogType.community.type
                ? await editCommunityStatus()
                : await editEventStatus();
            // Call API to delete event
            Navigator.of(context).pop();
            // Remove widget from screen
          },
        ),
      ],
    );
  }

  Future<void> editEventStatus() async {
    print("in event edit");
    print(widget.dialogActionType.type);
    if (DialogActionType.join.type == widget.dialogActionType.type) {
      print(
          'ready to send api request "${ref.read(localHttpIpProvider)}events/joinevent/${widget.group.communityId}/${ref.read(userIDProvider)}/${widget.group.id}")');
      var response = await http.post(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}events/joinevent/${widget.group.communityId}/${ref.read(userIDProvider)}/${widget.group.id}"),
      );
      print(response.statusCode);
    } else if (DialogActionType.delete.type == widget.dialogActionType.type) {
      print(
          "${ref.read(localHttpIpProvider)}events/deleteevent/${widget.group.communityId}/${ref.read(userIDProvider)}/${widget.group.id}");
      var response = await http.delete(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}events/deleteevent/${widget.group.communityId}/${ref.read(userIDProvider)}/${widget.group.id}"),
      );
      print(response.statusCode);
    }
    widget.changeMemberState();
  }

  Future<void> editCommunityStatus() async {
    //TODO: delete/leave/update event/community
    print("in community edit");
    print(widget.dialogActionType.type);
    if (DialogActionType.join.type == widget.dialogActionType.type) {
      print('ready to send api request');
      var response = await http.post(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}community/joincommunity/${ref.read(userIDProvider)}/${widget.group.id}"),
      );
      print(response.statusCode);
    } else if (DialogActionType.join.type == widget.dialogActionType.type) {
      print('ready to delete community');
      var response = await http.delete(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}community/deletecommunity/${ref.read(userIDProvider)}/${widget.group.id}"),
      );
      print(response.statusCode);
    }

    widget.changeMemberState();
    // Call delete event API
  }
}
