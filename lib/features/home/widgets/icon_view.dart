import 'package:flutter/material.dart';

class IconView extends StatefulWidget {
  final IconData icon;
  String count;
  String text;

  Color iconColor;
  IconView(
      {Key? key,
      this.iconColor = Colors.black,
      required this.icon,
      this.count = "",
      this.text = ""})
      : super(key: key);
  @override
  State<IconView> createState() => _IconViewState();
}

class _IconViewState extends State<IconView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor,
              size: 20,
            ),
            const SizedBox(width: 2),
            Text(widget.text),
            const SizedBox(
              width: 2,
            ),
            Text(widget.count,
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ));
  }
}
