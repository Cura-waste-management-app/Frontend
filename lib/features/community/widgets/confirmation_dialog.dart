import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/debug_print.dart';
import '../models/DialogActionType.dart';
import '../models/dialog_type.dart';

//todo handle no internet connection
class ConfirmationDialog extends ConsumerStatefulWidget {
  final DialogType dialogType;
  final DialogActionType dialogActionType;

  final VoidCallback handleState;

  const ConfirmationDialog(
      {super.key,
      required this.handleState,
      required this.dialogType,
      required this.dialogActionType});

  @override
  ConsumerState<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends ConsumerState<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    prints("in dialog");
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
            onPressed: widget.handleState,
            child: Text(widget.dialogActionType.type)),
      ],
    );
  }
}
