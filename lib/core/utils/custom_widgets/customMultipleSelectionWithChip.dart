import 'package:flutter/material.dart';
import '../navigation_helper.dart';
import '../theams/color_resource.dart';


class CustomMultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onChanged;
  final String? Function(List<String>?)? validator;

  const CustomMultiSelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedItems);
  }

  void _openMultiSelectDialog() async {
    List<String> tempSelected = List.from(_selected);
    String searchQuery = "";

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              final filteredItems = widget.items
                  .where((item) =>
                  item.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();

              return Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Search Field
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        hintText: "Search ${widget.label}...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setStateDialog(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // 🔹 List with search applied
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (filteredItems.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("No exact matches found."),
                              ),
                            ...filteredItems.map((item) {
                              final isSelected = tempSelected.contains(item);
                              return CheckboxListTile(
                                value: isSelected,
                                title: Text(item),
                                controlAffinity:
                                ListTileControlAffinity.leading,
                                activeColor: ColorResource.primaryColor,
                                onChanged: (checked) {
                                  setStateDialog(() {
                                    if (checked == true) {
                                      tempSelected.add(item);
                                    } else {
                                      tempSelected.remove(item);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                            if (searchQuery.isNotEmpty && !widget.items.map((e)=>e.toLowerCase()).contains(searchQuery.toLowerCase()))
                              ListTile(
                                leading: const Icon(Icons.add, color: ColorResource.primaryColor),
                                title: Text('Add custom: "$searchQuery"'),
                                onTap: () {
                                  setStateDialog(() {
                                    if (!tempSelected.contains(searchQuery)) {
                                      tempSelected.add(searchQuery);
                                      // We also add it to the local filteredItems temporarily or it just gets added to selected
                                    }
                                    searchQuery = ""; // Reset search after adding
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResource.primaryColor),
                          onPressed: () {
                            setState(() {
                              _selected = List.from(tempSelected);
                            });
                            widget.onChanged(_selected);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: _selected,
      validator: widget.validator,
      builder: (field) {
        return InkWell(
          onTap: _openMultiSelectDialog,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              errorText: field.errorText,
              suffixIcon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            isEmpty: _selected.isEmpty,
            child: _selected.isEmpty
                ? Text(
              "",
              style: TextStyle(color: Colors.grey.shade600),
            )
                : Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _selected
                  .map((e) => Chip(
                label: Text(e),
                backgroundColor: Colors.green.shade50,
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.red,
                ),
                onDeleted: () {
                  setState(() {
                    _selected.remove(e);
                  });
                  widget.onChanged(_selected);
                  field.didChange(_selected);
                },
              ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
