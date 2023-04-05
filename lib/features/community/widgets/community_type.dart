import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';

import '../../../models/community_type_widget.dart';

class CommunityTypeWidget extends StatefulWidget {
  final CommunityType communityType;
  final IconData icon;
  final CommunityType selectedCategory;
  final Function(CommunityType) changeCommunityType;
  const CommunityTypeWidget(
      {Key? key,
      required this.changeCommunityType,
      required this.communityType,
      required this.icon,
      required this.selectedCategory})
      : super(key: key);

  @override
  State<CommunityTypeWidget> createState() => _CommunityTypeWidgetState();
}

class _CommunityTypeWidgetState extends State<CommunityTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FloatingActionButton(
          elevation: 2,
          backgroundColor: widget.selectedCategory == widget.communityType
              ? const Color(0xfefefef)
              : const Color(0xffefedef),
          onPressed: () {
            if (widget.selectedCategory.type != widget.communityType.type) {
              widget.changeCommunityType(widget.communityType);
            } else {
              widget.changeCommunityType(CommunityType.all);
            }
          },
          child: Icon(widget.icon, color: Colors.black, size: 28)),
      SizedBox(
        height: getProportionateScreenHeight(6),
      ),
      Text(
        widget.communityType.type,
        style: const TextStyle(fontWeight: FontWeight.w600),
      )
    ]);
  }
}
