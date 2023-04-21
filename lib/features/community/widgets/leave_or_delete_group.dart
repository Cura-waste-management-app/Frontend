import 'package:cura_frontend/common/size_config.dart';
import 'package:cura_frontend/features/community/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../../constants.dart';
import '../../../providers/community_providers.dart';
import '../../conversation/providers/chat_providers.dart';
import '../../conversation/providers/conversation_providers.dart';
import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';
import 'confirmation_dialog.dart';

// todo get member exist from api
class LeaveOrDeleteGroup extends ConsumerStatefulWidget {
  LeaveOrDeleteGroup(
      {required this.group,
      required this.dialogType,
      required this.isMember,
      Key? key})
      : super(key: key);
  final group;
  late bool isMember;
  final DialogType dialogType;
  DialogActionType dialogActionType = DialogActionType.join;
  @override
  ConsumerState<LeaveOrDeleteGroup> createState() => _LeaveOrDeleteGroupState();
}

class _LeaveOrDeleteGroupState extends ConsumerState<LeaveOrDeleteGroup> {
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
  void initState() {
    super.initState();

    setState(() {});
  }

  handleState() async {
    widget.dialogType.type == DialogType.community.type
        ? await editCommunityStatus()
        : await editEventStatus();
    // Call API to delete event
    Navigator.of(context).pop();
  }

  DialogActionType checkDialogActionType() {
    if (widget.group.adminId == ref.read(userIDProvider.notifier).state) {
      return DialogActionType.delete;
    } else if (widget.isMember) {
      return DialogActionType.leave;
    }
    return DialogActionType.join;
  }

  Future<void> editEventStatus() async {
    print("in event edit");

    DialogActionType dialogActionType = checkDialogActionType();
    if (DialogActionType.join.type == dialogActionType.type) {
      var response = await handleAPI(
          '$joinEventAPI${widget.group.communityId}/',
          type: 'join');
      print(response.statusCode);
      handleResponse(response, eventJoinSuccessful, eventJoinFailed);
    } else if (DialogActionType.delete.type == dialogActionType.type) {
      print('deleting event');
      var response =
          await handleAPI('$deleteEventAPI${widget.group.communityId}/');
      handleResponse(response, eventDeleteSuccessful, eventDeleteFailed);
    } else {
      var response =
          await handleAPI('$leaveEventAPI${widget.group.communityId}/');
      print(response.statusCode);
      handleResponse(response, eventLeaveSuccessful, eventLeaveFailed);
    }
  }

  Future<void> editCommunityStatus() async {
    //TODO: leave event/community
    DialogActionType dialogActionType = checkDialogActionType();
    if (DialogActionType.join.type == dialogActionType.type) {
      print('ready to send api request $joinCommunityAPI');
      var response = await handleAPI(joinCommunityAPI, type: 'join');
      print(response.statusCode);
      handleResponse(response, communityJoinSuccessful, communityJoinFailed);
    } else if (DialogActionType.join.type == dialogActionType.type) {
      print('ready to delete community');
      var response = await handleAPI(deleteCommunityAPI);
      handleResponse(
          response, communityDeleteSuccessful, communityDeleteFailed);
    } else {
      var response = await handleAPI(leaveCommunityAPI);
      handleResponse(response, communityLeaveSuccessful, communityLeaveFailed);
    }

    // Call delete event API
  }

  handleAPI(String api, {String type = 'delete'}) async {
    if (type != 'join') {
      return await delete(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}$api${ref.read(userIDProvider)}/${widget.group.id}"),
      );
    } else {
      return await post(
        Uri.parse(
            "${ref.read(localHttpIpProvider)}$api${ref.read(userIDProvider)}/${widget.group.id}"),
      );
    }
  }

  void handleResponse(Response response, String successText, String failText) {
    if (response.statusCode >= 200 && response.statusCode <= 210) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBarWidget(text: successText).getSnackBar());
      Navigator.pop(context); //todo handle pop context
      Navigator.pop(context);
      if (widget.dialogType.type == DialogType.event.type) {
        ref.refresh(getEventsProvider(widget.group.id));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBarWidget(text: failText).getSnackBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isMember);
    return widget.group.adminId == ref.read(userIDProvider.notifier).state
        ? GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    dialogType: widget.dialogType,
                    dialogActionType: DialogActionType.delete,
                    handleState: handleState,
                  );
                },
              );
            },
            child: Row(
              children: const [
                Text(
                  'Delete',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 18),
                ),
                Spacer(),
                Icon(Icons.delete_forever, color: Colors.redAccent)
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    dialogType: widget.dialogType,
                    dialogActionType: widget.isMember
                        ? DialogActionType.leave
                        : DialogActionType.join,
                    handleState: handleState,
                  );
                },
              );
            },
            child: Row(children: [
              Text(
                widget.isMember ? 'Leave' : 'Join',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              if (widget.isMember) const Icon(Icons.exit_to_app)
            ]),
          );
  }
}
