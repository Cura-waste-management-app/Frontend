import 'package:cura_frontend/constants.dart';
import 'package:cura_frontend/features/community/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../providers/community_providers.dart';
import '../../conversation/providers/chat_providers.dart';
import '../../conversation/providers/conversation_providers.dart';
import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';

//todo check if editor is creator during update
//todo handle no internet connection
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
  String eventDeleteSuccessful = 'Event successfully deleted';
  String eventDeleteFailed = 'Event delete failed. Try again later';
  String communityDeleteSuccessful = 'Community successfully deleted';
  String communityDeleteFailed = 'Failed to leave community. Try again later';
  String eventJoinSuccessful = 'Event successfully joined';
  String eventJoinFailed = 'Event join failed. Try again later';
  String communityJoinSuccessful = 'Community successfully joined';
  String communityJoinFailed = 'Community join failed. Try again later';
  String eventLeaveSuccessful = 'Event successfully leaved';
  String eventLeaveFailed = 'Failed to leave event. Try again later';
  String communityLeaveSuccessful = 'Community successfully leaved';
  String communityLeaveFailed = 'Community leave failed. Try again later';

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
      var response = handleAPI('$joinEventAPI${widget.group.communityId}/');
      print(response.statusCode);
      handleResponse(response, eventJoinSuccessful, eventJoinFailed);
    } else if (DialogActionType.delete.type == widget.dialogActionType.type) {
      print('deleting event');
      var response = handleAPI('$deleteEventAPI${widget.group.communityId}/');
      handleResponse(response, eventDeleteSuccessful, eventDeleteFailed);
    } else {
      var response = handleAPI('$leaveEventAPI${widget.group.communityId}/');
      print(response.statusCode);
      handleResponse(response, eventLeaveSuccessful, eventLeaveFailed);
    }
    widget.changeMemberState(); //todo handle this
  }

  Future<void> editCommunityStatus() async {
    //TODO: leave event/community
    if (DialogActionType.join.type == widget.dialogActionType.type) {
      print('ready to send api request');
      var response = handleAPI(joinCommunityAPI);
      print(response.statusCode);
      handleResponse(response, communityJoinSuccessful, communityJoinFailed);
    } else if (DialogActionType.join.type == widget.dialogActionType.type) {
      print('ready to delete community');
      var response = handleAPI(deleteCommunityAPI);
      handleResponse(
          response, communityDeleteSuccessful, communityDeleteFailed);
    } else {
      var response = handleAPI(leaveCommunityAPI);
      handleResponse(response, communityLeaveSuccessful, communityLeaveFailed);
    }

    widget.changeMemberState();
    // Call delete event API
  }

  handleAPI(String api) async {
    return await http.delete(
      Uri.parse(
          "${ref.read(localHttpIpProvider)}$api${ref.read(userIDProvider)}/${widget.group.id}"),
    );
  }

  void handleResponse(response, String successText, String failText) {
    if (response.statusCode >= 200 && response.statusCode <= 210) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBarWidget(text: successText).getSnackBar());
      Navigator.pop(context); //todo handle pop context
      Navigator.pop(context);
      if (widget.dialogType.type == DialogType.event.type)
        ref.refresh(getEventsProvider(widget.group.id));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBarWidget(text: failText).getSnackBar());
    }
  }
}
