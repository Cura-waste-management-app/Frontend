
import 'package:flutter/material.dart';
import '../../home/home_listing.dart';

class TitlteDescription extends StatefulWidget {
  Function addNewItem;
  TitlteDescription(this.addNewItem);

  @override
  State<TitlteDescription> createState() => _TitlteDescriptionState();
}

class _TitlteDescriptionState extends State<TitlteDescription> {
  final titleController = TextEditingController();

  final descController = TextEditingController();

  void submitData(){
    final enteredTitle = titleController.text;
    final enteredDesc = descController.text;

    if(enteredTitle.isEmpty || enteredDesc.isEmpty){
      return ;
    }

    widget.addNewItem(enteredTitle,enteredDesc);
    // Navigator.of(context).pop();
    // Navigator.pushNamed(context, HomeListing.routeName);

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
                    onSubmitted: (_) => submitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    controller: descController,
                    onSubmitted: (_) => submitData(),
                  ),
                  ElevatedButton(
                    child: Text("Add Item"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: submitData,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
