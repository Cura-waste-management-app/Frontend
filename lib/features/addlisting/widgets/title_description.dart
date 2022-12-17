import 'package:flutter/material.dart';
import '../../home/home_listing.dart';
import '../../../models/display_item.dart';

class TitlteDescription extends StatefulWidget {
  @override
  State<TitlteDescription> createState() => _TitlteDescriptionState();
}

class _TitlteDescriptionState extends State<TitlteDescription> {
  final titleController = TextEditingController();

  final descController = TextEditingController();

  void submitData(BuildContext ctx) {
    final enteredTitle = titleController.text;
    final enteredDesc = descController.text;

    if (enteredTitle.isEmpty || enteredDesc.isEmpty) {
      return;
    }

    // final newItem = DisplayItem(
    //     id: DateTime.now().toString(),
    //     title: enteredTitle,
    //     description: enteredDesc,
    //     imagePath: "assets/images/chair.jpg",
    //     rating: 0,
    //     views: 0,
    //     likes: 0,
    //     status: "Pending",
    //     timeAdded: DateTime.now().toString(),
    //     distance: '545');
    //
    // print(newItem.id);
    // print(newItem.title);
    // print(newItem.id);
    // print(newItem.id);
    // Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
    //   return HomeListing();
    // }));
    // Navigator.of(context).pop();
    Navigator.of(ctx).pushNamed(
      HomeListing.routeName,
      // arguments: newItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        // height: 300,
        child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    controller: titleController,
                    onSubmitted: (_) => submitData(context),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    controller: descController,
                    onSubmitted: (_) => submitData(context),
                  ),
                  ElevatedButton(
                    child: Text("Add Item"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () => submitData(context),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
