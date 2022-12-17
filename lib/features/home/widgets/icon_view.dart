import 'package:flutter/material.dart';

class IconView extends StatefulWidget {
  final IconData icon;
  final String count;
  Color iconColor;
  IconView(
      {Key? key,
      this.iconColor = Colors.grey,
      required this.icon,
      required this.count})
      : super(key: key);
  @override
  State<IconView> createState() => _IconViewState();
}

class _IconViewState extends State<IconView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor,
              size: 20,
            ),
            SizedBox(width: 2),
            Text(widget.count,
                style: TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ));
  }
}
