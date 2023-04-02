import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../conversation/providers/chat_providers.dart';
import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';
import 'confirmation_dialog.dart';

// todo get member exist from api
class LeaveOrDeleteGroup extends ConsumerStatefulWidget {
  LeaveOrDeleteGroup({required this.group, required this.dialogType, Key? key})
      : super(key: key);
  final group;
  late bool isMember = false;
  final DialogType dialogType;
  @override
  ConsumerState<LeaveOrDeleteGroup> createState() => _LeaveOrDeleteGroupState();
}

class _LeaveOrDeleteGroupState extends ConsumerState<LeaveOrDeleteGroup> {
  changeMemberState() {
    print("changing state");
    setState(() {
      widget.isMember = !widget.isMember;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.group.adminId == ref.read(userIDProvider.notifier).state
        ? GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    group: widget.group,
                    dialogType: widget.dialogType,
                    dialogActionType: DialogActionType.delete,
                    changeMemberState: changeMemberState,
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
                    //todo change eventId logic
                    group: widget.group,
                    dialogType: widget.dialogType,
                    dialogActionType: widget.isMember
                        ? DialogActionType.leave
                        : DialogActionType.join,
                    changeMemberState: changeMemberState,
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
