import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../VideoCall/agoraVideoCall.dart';
import '../model/patients_model.dart';
import 'package:http/http.dart' as http;

//
// class NewAppointmentsCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const NewAppointmentsCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final name = model.patientName ?? 'N/A';
//     final age =  model.patientAge ??  'N/A';
//     final gender =  model.patientGender??'N/A';
//     final appointmentDate = model.appointmentDate ?? 'N/A';
//     final timeSlot = model.timeSlot ?? 'N/A';
//     final imageUrl =  'https://via.placeholder.com/150';
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorResource.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: CustomImageView(imagePath:
//                   imageUrl,
//                   height: 72,
//                   width: 72,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '$age Y/O $gender',
//                       style: const TextStyle(
//                         color: ColorResource.lightText,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "${HelperMethods.formatAppointmentDate(appointmentDate)} | $timeSlot",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color(0xFFF5F5F5),
//                 ),
//                 padding: const EdgeInsets.all(10),
//                 child: const Icon(
//                   Icons.call,
//                   size: 20,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           // const SizedBox(height: 20),
//           // /// Buttons Row
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Expanded(
//           //       child: CustomOutlineButton(
//           //         label: "Accept",
//           //         color: ColorResource.green,
//           //         onTap: () {},
//           //       ),
//           //     ),
//           //     Expanded(
//           //       child: CustomOutlineButton(
//           //         label: "View Profile",
//           //         color: ColorResource.primaryColor,
//           //         onTap: () {},
//           //       ),
//           //     ) ,
//           //     Expanded(
//           //       child: CustomOutlineButton(
//           //         label: "Reject",
//           //         color: ColorResource.darkRed,
//           //         onTap: () {},
//           //       ),
//           //     )
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
// }
class NewAppointmentsCard extends StatelessWidget {
  final AppointmentsList model;
  const NewAppointmentsCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    const accentColor =  Color(0xFF419CAB);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // --- AVATAR WITH STATUS ---
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Image(
                      image: NetworkImage('https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg?semt=ais_hybrid&w=740&q=80'),
                      height: 72,
                      width: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: ColorResource.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              // --- PATIENT INFO ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.patientName ?? 'Unknown Patient',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${model.patientAge} Years • ${model.patientGender}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // --- ACTION BUTTON ---
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.videocam_rounded, color: ColorResource.primaryColor, size: 20),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF1F1F1)),
          ),
          // --- TIME SLOT INFO ---
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(
                model.timeSlot ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorResource.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child:  Text(
                  'Confirmed',
                  style: TextStyle(
                    color: ColorResource.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: model.type == 'inClinic' ? Colors.orange.shade50 : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  model.type == 'inClinic' ? "In-Clinic" : "Video Call",
                  style: TextStyle(
                    color: model.type == 'inClinic' ? Colors.orange : Colors.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}