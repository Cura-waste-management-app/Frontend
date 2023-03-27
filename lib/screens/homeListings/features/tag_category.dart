import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_listings_provider.dart';
// import '../../providers/listed_items.dart';

class TagCategory extends StatefulWidget {
  final IconData icon;
  final String category;
  const TagCategory({Key? key, required this.icon, required this.category})
      : super(key: key);

  @override
  State<TagCategory> createState() => _TagCategoryState();
}

class _TagCategoryState extends State<TagCategory> {
  // MaterialColor chipcolor = Colors.yellow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<HomeListingsNotifier>(context, listen: false)
            .setChoices(widget.category);
        print("hello");
        // setState(() {
        //   if (chipcolor == Colors.green) {
        //     chipcolor = Colors.yellow;
        //   } else {
        //     chipcolor = Colors.green;
        //   }
        // });
      },
      child: Chip(
        elevation: 5,
        backgroundColor:
            Provider.of<HomeListingsNotifier>(context, listen: false)
                    .displayChoices[widget.category]!
                ? Color.fromARGB(255, 165, 239, 86)
                : Colors.black54,
        labelStyle: TextStyle(fontSize: 11),
        avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: Icon(widget.icon, size: 14),
        ),
        label: Text(widget.category),
      ),
    );
  }
}
