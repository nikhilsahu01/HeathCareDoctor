// import 'package:flutter/material.dart';
// import '../../../core/api_service/app_url.dart';
// import '../../../core/utils/custom_widgets/custom_app_button.dart';
// import '../../../core/utils/custom_widgets/custom_image_view.dart';
// import '../../../core/utils/helper_functions/helpers_methods.dart';
// import '../../../core/utils/navigation_helper.dart';
// import '../../../core/utils/theams/color_resource.dart';
//
// import '../model/patients_model.dart';
//
//
// class CompletedAppointmentCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const CompletedAppointmentCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final name = model.patientName ?? 'N/A';
//     final age =  model.patientAge ?? 'N/A';
//     final gender = model.patientAge ?? 'N/A';
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
//                 imageUrl,
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
//           //         label: "View Details",
//           //         color: Colors.green,
//           //         onTap: () {},
//           //       ),
//           //     ),
//           //     Expanded(
//           //       child: CustomOutlineButton(
//           //         label: "Book Follow -Up",
//           //         color: Colors.blue,
//           //         onTap: () {},
//           //       ),
//           //     ),
//           //     Expanded(
//           //       child: CustomOutlineButton(
//           //         label: "Message Patient",
//           //         color: Colors.orange,
//           //         onTap: () {},
//           //       ),
//           //     ),
//           //   ],
//           // )
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../appointments/view/appointment_details_screens/complete_appointment_details_screen.dart';
import '../model/patients_model.dart';

class CompletedAppointmentCard extends StatelessWidget {
  final AppointmentsList model;

  const CompletedAppointmentCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Modern Medical Colors
    // const Color kSuccessGreen =  Color(0xFF419CAB);
    const Color kLightGrey = Color(0xFF677294);
    const Color kCardBg = Colors.white;

    final name = model.patientName ?? 'N/A';
    final age = model.patientAge ?? 'N/A';
    final gender = model.patientGender ?? 'N/A'; // Fixed potential logic error from your snippet
    final imageUrl = 'https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg?semt=ais_hybrid&w=740&q=80';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(15), // Softer, more modern corners
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Patient Avatar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ColorResource.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomImageView(
                    imagePath: imageUrl,
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// Patient Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF333333),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$gender • $age Years Old',
                      style: const TextStyle(
                        color: kLightGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Completed Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorResource.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: ColorResource.primaryColor),
                          SizedBox(width: 4),
                          Text(
                            "Completed",
                            style: TextStyle(
                              color: ColorResource.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: model.type == 'inClinic' ? Colors.orange.shade50 : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        model.type == 'inClinic' ? "In-Clinic" : "Video Call",
                        style: TextStyle(
                          color: model.type == 'inClinic' ? Colors.orange : Colors.purple,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Contact Action
              Material(
                color: const Color(0xFFF2F5F9),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () async {
                    if (model.userMobile != null && model.userMobile!.isNotEmpty) {
                      final Uri url = Uri.parse('tel:${model.userMobile}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not launch phone dialer')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phone number not available')),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.phone_in_talk_rounded,
                      size: 20,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Optional: Re-enable buttons with modern styling if needed

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    if (model.prescriptionFiles != null && model.prescriptionFiles!.isNotEmpty) {
                      final urlString = model.prescriptionFiles!.first;
                      // Ensure it's a valid url
                      final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'http://10.0.2.2:3000/$urlString'); // Or whatever the base URL is
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open report')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No report available for this appointment')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: GestureDetector

                    (
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CompletedAppointmentsDetailsScreen( appointmentId:
                        model.appointmentId ?? '',
                            profileImage: imageUrl,),));
                      },
                      child: const Text("View Report", style: TextStyle(color: Colors.black87))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResource.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Re-Book", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}