import 'package:flutter/material.dart';
import '../model/qualification_tree_model.dart';

class QualificationSelector extends StatefulWidget {
  final List<QualificationNode> treeNodes;
  final Function(List<String>) onQualificationChanged;
  final List<String>? initialValues;

  const QualificationSelector({
    super.key,
    required this.treeNodes,
    required this.onQualificationChanged,
    this.initialValues,
  });

  @override
  State<QualificationSelector> createState() => _QualificationSelectorState();
}

class _QualificationSelectorState extends State<QualificationSelector> {
  List<String> selectedQualifications = [];
  
  // Current selection state for adding a new qualification
  List<QualificationNode?> currentPath = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedQualifications = List.from(widget.initialValues!);
    }
    _resetCurrentPath();
  }

  void _resetCurrentPath() {
    setState(() {
      currentPath = [null]; // Start with level 0
    });
  }

  void _notifyChange() {
    widget.onQualificationChanged(selectedQualifications);
  }

  void _addCurrentQualification() {
    if (currentPath.isEmpty || currentPath[0] == null) return;

    // Build the string representation (e.g., "MBBS | MD - Cardiology")
    String qStr = currentPath[0]!.name ?? "";
    if (currentPath.length > 1 && currentPath[1] != null) {
      qStr += " | ${currentPath[1]!.name}";
    }
    if (currentPath.length > 2 && currentPath[2] != null) {
      qStr += " - ${currentPath[2]!.name}";
    }

    if (!selectedQualifications.contains(qStr)) {
      setState(() {
        selectedQualifications.add(qStr);
      });
      _notifyChange();
    }
    _resetCurrentPath();
  }

  void _removeQualification(String q) {
    setState(() {
      selectedQualifications.remove(q);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Qualifications",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(height: 15),

        // Display selected qualifications as Chips
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedQualifications.map((q) {
            return Chip(
              label: Text(q, style: const TextStyle(fontSize: 12)),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeQualification(q),
              backgroundColor: Colors.blue.shade50,
            );
          }).toList(),
        ),
        if (selectedQualifications.isNotEmpty) const SizedBox(height: 15),

        // Dynamic Dropdowns for current selection path
        ...List.generate(currentPath.length, (index) {
          List<QualificationNode> options = [];
          if (index == 0) {
            options = widget.treeNodes;
          } else {
            options = currentPath[index - 1]?.children ?? [];
          }

          if (options.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: DropdownButtonFormField<QualificationNode>(
              value: currentPath[index],
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: index == 0 ? "Select Basic Degree" : (index == 1 ? "Select Post Graduation" : "Select Specialization"),
                border: const OutlineInputBorder(),
              ),
              items: options.map((node) {
                return DropdownMenuItem<QualificationNode>(
                  value: node,
                  child: Text(node.name ?? ''),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  // Truncate path to current index + 1
                  if (currentPath.length > index + 1) {
                    currentPath.removeRange(index + 1, currentPath.length);
                  }
                  currentPath[index] = val;
                  // If the selected node has children, add a null placeholder for the next level
                  if (val != null && val.children != null && val.children!.isNotEmpty) {
                    if (currentPath.length == index + 1) {
                      currentPath.add(null);
                    }
                  }
                });
              },
            ),
          );
        }),

        // Add Button
        if (currentPath.isNotEmpty && currentPath[0] != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addCurrentQualification,
              icon: const Icon(Icons.add),
              label: const Text("Add Qualification"),
            ),
          ),
      ],
    );
  }
}