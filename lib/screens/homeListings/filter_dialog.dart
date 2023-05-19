import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/home_listings_provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool nearest = false;
  bool latest = false;
  @override
  void initState() {
    // TODO: implement initState
    nearest =
        Provider.of<HomeListingsNotifier>(context, listen: false).nearestfirst;
    latest =
        Provider.of<HomeListingsNotifier>(context, listen: false).latestfirst;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text("Show by:"),
      content: Container(
        height: 100.h / 5,
        child: Column(children: [
          SwitchListTile(
            title: Text('Distance'),
            subtitle: Text("Nearest listings first"),
            value: nearest,
            onChanged: (bool value) {
              Provider.of<HomeListingsNotifier>(context, listen: false)
                  .toggleDistance();
              setState(() {
                nearest = value;
              });
            },
          ),
          // SwitchListTile(
          //   title: Text('Time'),
          //   subtitle: Text("Latest listings first"),
          //   value: latest,
          //   onChanged: (bool value) {
          //     Provider.of<HomeListingsNotifier>(context, listen: false)
          //         .toggleTime();
          //     setState(() {
          //       latest = value;
          //     });
          //   },
          // ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ok'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
