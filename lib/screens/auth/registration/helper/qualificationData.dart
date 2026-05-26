// import 'package:flutter/material.dart';
//
// class QualificationSelector extends StatefulWidget {
//   final Function(String) onQualificationChanged;
//
//   const QualificationSelector({super.key, required this.onQualificationChanged});
//
//   @override
//   State<QualificationSelector> createState() => _QualificationSelectorState();
// }
//
// class _QualificationSelectorState extends State<QualificationSelector> {
//   String? selectedBase;        // MBBS or BDS
//   String? selectedPg;          // MD or MS
//   String? selectedSuper;       // DM or MCh specialization
//
//   final List<String> baseQualifications = ['MBBS', 'BDS'];
//
//   final List<String> pgDegrees = ['MD', 'MS'];
//
//   final Map<String, List<String>> superSpecializations = {
//     'MD': [
//       'Cardiology', 'Neurology', 'Gastroenterology', 'Nephrology',
//       'Endocrinology', 'Oncology', 'Hematology', 'Rheumatology',
//       'Critical Care', 'Infectious Diseases', 'Neonatology', 'Respiratory Medicine'
//     ],
//     'MS': [
//       'Cardiothoracic Surgery', 'Neurosurgery', 'Plastic Surgery', 'Urology',
//       'Pediatric Surgery', 'Surgical Oncology', 'Vascular Surgery',
//       'GI Surgery', 'Endocrine Surgery', 'Hepatobiliary Surgery'
//     ],
//   };
//
//   void _notifyChange() {
//     String qualification = "";
//
//     if (selectedBase != null) {
//       qualification = selectedBase!;
//     }
//     if (selectedPg != null) {
//       qualification += " | $selectedPg";
//     }
//     if (selectedSuper != null) {
//       qualification += " - $selectedSuper";
//     }
//
//     widget.onQualificationChanged(qualification);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Qualification",
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black),
//         ),
//         const SizedBox(height: 14),
//
//         // Level 1: MBBS / BDS (Mandatory)
//         DropdownButtonFormField<String>(
//           value: selectedBase,
//           decoration: const InputDecoration(
//             fillColor: Colors.white,
//             labelText: "Basic Qualification *",
//             border: OutlineInputBorder(),
//           ),
//           items: baseQualifications.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//           onChanged: (val) {
//             setState(() {
//               selectedBase = val;
//               selectedPg = null;
//               selectedSuper = null;
//             });
//             _notifyChange();
//           },
//           validator: (val) => val == null ? 'Basic qualification is required' : null,
//         ),
//
//         const SizedBox(height: 15),
//
//         // Level 2: MD / MS (Optional)
//         if (selectedBase != null)
//           DropdownButtonFormField<String>(
//             value: selectedPg,
//             decoration: const InputDecoration(
//               fillColor: Colors.white,
//               labelText: "Post Graduation (Optional)",
//               border: OutlineInputBorder(),
//             ),
//             items: pgDegrees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//             onChanged: (val) {
//               setState(() {
//                 selectedPg = val;
//                 selectedSuper = null;
//               });
//               _notifyChange();
//             },
//           ),
//
//         const SizedBox(height: 15),
//
//         // Level 3: Super Specialization (Optional)
//         if (selectedPg != null)
//           DropdownButtonFormField<String>(
//             value: selectedSuper,
//             decoration: const InputDecoration(
//               fillColor: Colors.white,
//               labelText: "Super Specialization (Optional)",
//               border: OutlineInputBorder(),
//             ),
//             items: superSpecializations[selectedPg]!
//                 .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                 .toList(),
//             onChanged: (val) {
//               setState(() => selectedSuper = val);
//               _notifyChange();
//             },
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class QualificationSelector extends StatefulWidget {
  final Function(String) onQualificationChanged;
  final String? initialValue;

  const QualificationSelector({
    super.key,
    required this.onQualificationChanged,
    this.initialValue,
  });

  @override
  State<QualificationSelector> createState() => _QualificationSelectorState();
}

class _QualificationSelectorState extends State<QualificationSelector> {
  String? selectedBase;      // MBBS or BDS
  String? selectedPg;        // MD/MS for MBBS OR MDS for BDS
  String? selectedSuper;

  final List<String> baseQualifications = ['MBBS', 'BDS'];

  // For MBBS → MD / MS
  final List<String> pgForMBBS = ['MD', 'MS'];

  // For BDS → MDS (Most common)
  final List<String> pgForBDS = ['MDS'];

  final Map<String, List<String>> superSpecializations = {
    'MD': [
      'Cardiology', 'Neurology', 'Gastroenterology', 'Nephrology', 'Endocrinology',
      'Oncology', 'Hematology', 'Rheumatology', 'Critical Care', 'Infectious Diseases',
      'Neonatology', 'Respiratory Medicine', 'Clinical Immunology'
    ],
    'MS': [
      'Cardiothoracic Surgery', 'Neurosurgery', 'Plastic Surgery', 'Urology',
      'Pediatric Surgery', 'Surgical Oncology', 'Vascular Surgery', 'GI Surgery',
      'Endocrine Surgery', 'Hepatobiliary Surgery'
    ],
    'MDS': [
      'Prosthodontics', 'Orthodontics', 'Periodontics', 'Oral Surgery',
      'Pedodontics', 'Conservative Dentistry', 'Oral Pathology', 'Oral Medicine'
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _parseInitialValue(widget.initialValue!);
    }
  }

  void _parseInitialValue(String value) {
    final parts = value.split('|').map((e) => e.trim()).toList();

    if (parts.isNotEmpty) {
      selectedBase = parts[0];

      if (parts.length > 1) {
        final pgPart = parts[1].split('-')[0].trim();
        selectedPg = pgPart;

        if (parts[1].contains('-')) {
          selectedSuper = parts[1].split('-')[1].trim();
        }
      }
    }
    _notifyChange();
  }

  List<String> get currentPgOptions {
    if (selectedBase == 'MBBS') return pgForMBBS;
    if (selectedBase == 'BDS') return pgForBDS;
    return [];
  }

  void _notifyChange() {
    String qualification = selectedBase ?? "";

    if (selectedPg != null) {
      qualification += " | $selectedPg";
    }
    if (selectedSuper != null) {
      qualification += " - $selectedSuper";
    }

    widget.onQualificationChanged(qualification);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Qualification",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(height: 15),

        // Level 1: MBBS or BDS
        DropdownButtonFormField<String>(
          value: baseQualifications.contains(selectedBase)
              ? selectedBase
              : null,

          decoration: const InputDecoration(
            fillColor: Colors.white,
            labelText: "Basic Qualification *",
            border: OutlineInputBorder(),
          ),

          items: baseQualifications
              .toSet() // removes duplicate values
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),

          onChanged: (val) {
            setState(() {
              selectedBase = val;
              selectedPg = null;
              selectedSuper = null;
            });

            _notifyChange();
          },

          validator: (val) =>
          val == null ? 'Basic qualification is required' : null,
        ),

        const SizedBox(height: 15),

        // Level 2: PG Degree (MD/MS for MBBS OR MDS for BDS)
        if (selectedBase != null)
          DropdownButtonFormField<String>(
            value: selectedPg,
            decoration: InputDecoration(
              fillColor: Colors.white,
              labelText: selectedBase == 'BDS'
                  ? "Post Graduation (MDS)"
                  : "Post Graduation (Optional)",
              border: const OutlineInputBorder(),
            ),
            items: currentPgOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              setState(() {
                selectedPg = val;
                selectedSuper = null;
              });
              _notifyChange();
            },
          ),

        const SizedBox(height: 15),

        // Level 3: Super Specialization
        if (selectedPg != null)
          DropdownButtonFormField<String>(
            value: selectedSuper,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              labelText: "Super Specialization (Optional)",
              border: OutlineInputBorder(),
            ),
            items: (superSpecializations[selectedPg] ?? []).map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            onChanged: (val) {
              setState(() => selectedSuper = val);
              _notifyChange();
            },
          ),
      ],
    );
  }
}