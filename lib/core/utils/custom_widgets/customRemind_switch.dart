// import 'package:flutter/material.dart';
//
// class CustomRemindMeSwitch extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   const CustomRemindMeSwitch({
//     super.key,
//     required this.value,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Text(
//           "Remind me",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Transform.scale(
//           scaleX: 0.9,
//           scaleY: 0.8,
//           child: Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.white,
//             activeTrackColor: Colors.lightGreenAccent,
//             inactiveThumbColor: Colors.grey.shade400,
//             inactiveTrackColor: Colors.grey.shade300,
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//         )
//       ],
//     );
//   }
// }
