import 'package:flutter/material.dart';
import 'item_model.dart';

typedef Cb = Function(List<String>);

// ignore: use_key_in_widget_constructors, must_be_immutable
class Filter extends StatefulWidget {
  final Cb setFilters;
  List<ItemModel> chipList;
  Filter({required this.chipList, required this.setFilters, super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  List<String> _selectedFilters = [];

  void _showFilterOptions(BuildContext context) async {
    final selectedFilters = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 220,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Select Filters",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Wrap(
                  spacing: 20.0,
                  children: widget.chipList
                      .map((item) => FilterChip(
                            label: Text(item.label),
                            selected: item.isSelected,
                            onSelected: (value) {
                              setState(() {
                                final index = widget.chipList.indexWhere(
                                    (chip) => chip.label == item.label);
                                widget.chipList[index].isSelected = value;
                              });
                            },
                            selectedColor: item.color,
                          ))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i <  widget.chipList.length; i++) {
                            widget.chipList[i].isSelected = false;
                          }
                          List<String> selectedFilters = [];
                          Navigator.of(context).pop(selectedFilters);
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedFilters =  widget.chipList
                              .where((item) => item.isSelected)
                              .map((item) => item.label)
                              .toList();
                          Navigator.of(context).pop(selectedFilters);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    if (selectedFilters != null) {
      setState(() {
        _selectedFilters = selectedFilters;
        widget.setFilters(_selectedFilters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      width: 85,
      height: 35,
      margin: const EdgeInsets.fromLTRB(5, 10, 15, 5),
      padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/filter.png', width: 20),
            _selectedFilters.isEmpty
                ? const Text('Filter', style: TextStyle(fontSize: 14))
                : Text('Filter (${_selectedFilters.length})',
                    style: const TextStyle(fontSize: 14)),
          ],
        ),
        onTap: () => _showFilterOptions(context),
      ),
    );
  }
}
