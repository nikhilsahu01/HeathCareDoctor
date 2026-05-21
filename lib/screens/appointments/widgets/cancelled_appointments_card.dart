// import 'package:flutter/material.dart';
// import '../../../core/api_service/app_url.dart';
// import '../../../core/utils/custom_widgets/custom_app_button.dart';
// import '../../../core/utils/custom_widgets/custom_image_view.dart';
// import '../../../core/utils/helper_functions/helpers_methods.dart';
// import '../../../core/utils/navigation_helper.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import '../model/appointments_model.dart';
// import '../view/appointment_details_screens/complete_appointment_details_screen.dart';
// import '../view/reschedule_bottombar.dart';
//
//
// class CancelledAppointmentsCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const CancelledAppointmentsCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final doctorName = model.patientName?? 'Unknown Doctor';
//     final imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/250px-Image_created_with_a_mobile_phone.png';
//     final specialization = model.categoryName?? 'Unknown Specialization';
//     final time = model.timeSlot ?? 'N/A';
//
//     return GestureDetector(
//       onTap: () {
//         navSlideFromRight(
//           context,
//        CompletedAppointmentsDetailsScreen(appointmentId: model.appointmentId??'',isCancelledAppointment:true),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: ColorResource.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: ColorResource.primaryColor, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Doctor Info Row
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.transparent,
//                   child: CustomImageView(
//                     imagePath: imageUrl,
//                     // imagePath: '${AppUrl.baseUrl}/$imageUrl',
//                     height: 56,
//                     width: 56,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       doctorName,
//                       style: const TextStyle(
//                         color: ColorResource.darkText,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     ),
//                     Text(
//                       specialization,
//                       style: const TextStyle(
//                         color: ColorResource.darkText,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 const Text(
//                   "Cancelled",
//                   style: TextStyle(
//                     color: ColorResource.red,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 14),
//
//             /// Date + Time Row
//             Container(
//               width: double.infinity,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 1,
//                     height: 40,
//                     color: Colors.white.withOpacity(0.5),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       decoration: const BoxDecoration(
//                         color: ColorResource.gradientLightBlue,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           bottomLeft: Radius.circular(6),
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         HelperMethods.formatAppointmentDate(model.appointmentDate ?? 'N/A'),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 40,
//                     color: Colors.white.withOpacity(0.5),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                     decoration: const BoxDecoration(
//                       color: ColorResource.gradientLightBlue,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(6),
//                         bottomRight: Radius.circular(6),
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       time,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // const SizedBox(height: 10),
//
//             /// Re-book Button
//             // CustomAppButton(
//             //
//             //   label: 'Re-book',
//             //   onPressed: () {
//             //     // showModalBottomSheet(
//             //     //   context: context,
//             //     //   isScrollControlled: true,
//             //     //   shape: const RoundedRectangleBorder(
//             //     //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             //     //   ),
//             //     //   builder: (context) => RescheduleBottomSheetScreen(vendorId:model.vendor?.sId ?? "",appointmentId: model.sId??'',isRebook:true,categoryId: model.category?.sId,patentId: model.patient,type: model.type,),
//             //     // );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../model/appointments_model.dart';
import '../view/appointment_details_screens/complete_appointment_details_screen.dart';
// import '../view/reschedule_bottombar.dart'; // Ensure this is imported for the Re-book logic
//
// class CancelledAppointmentsCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const CancelledAppointmentsCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     // Premium Design System Colors
//     const kPrimaryBlue =  Color(0xFF419CAB);
//     const Color kErrorRed = Color(0xFFEB5757);
//     // const Color kPrimaryBlue = Color(0xFF2E83F8);
//     const Color kTextPrimary = Color(0xFF222B45);
//     const Color kTextSecondary = Color(0xFF8F9BB3);
//     const Color kBorderColor = Color(0xFFF1F4F9);
//
//     final doctorName = model.patientName ?? 'Unknown Doctor';
//     final specialization = model.categoryName ?? 'Specialist';
//     final time = model.timeSlot ?? 'N/A';
//     final imageUrl = 'https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg?semt=ais_hybrid&w=740&q=80';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16, ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: Offset(0, 6),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () {
//                 navSlideFromRight(
//                   context,
//                   CompletedAppointmentsDetailsScreen(
//                     appointmentId: model.appointmentId ?? '',
//                     isCancelledAppointment: true,
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     /// Top Section: Doctor Info & Cancelled Badge
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: kBorderColor, width: 2),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(14),
//                             child: CustomImageView(
//                               imagePath: imageUrl,
//                               height: 56,
//                               width: 56,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 doctorName,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: kTextPrimary,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   letterSpacing: -0.5,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 specialization,
//                                 style: const TextStyle(
//                                   color: kTextSecondary,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         /// Cancelled Status Pill
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: kErrorRed.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Text(
//                             "Cancelled",
//                             style: TextStyle(
//                               color: kErrorRed,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     /// Middle Section: Date & Time Metadata
//                     Row(
//                       children: [
//                         _buildMetaItem(Icons.calendar_today_rounded,
//                             HelperMethods.formatAppointmentDate(model.appointmentDate ?? 'N/A')),
//                         const SizedBox(width: 16),
//                         _buildMetaItem(Icons.access_time_rounded, time),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// Bottom Section: Modern Re-book Action
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Business Logic Maintained: Implement Re-book action here
//                   debugPrint("Re-booking for: ${model.appointmentId}");
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kPrimaryBlue.withOpacity(0.08),
//                   foregroundColor: kPrimaryBlue,
//                   elevation: 0,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Re-book Appointment",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Small helper for metadata icons
//   Widget _buildMetaItem(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: const Color(0xFF8F9BB3)),
//         const SizedBox(width: 6),
//         Text(
//           text,
//           style: const TextStyle(
//             color: Color(0xFF677294),
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }



class CancelledAppointmentsCard extends StatelessWidget {
  final AppointmentsList model;

  const CancelledAppointmentsCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final doctorName = model.patientName ?? 'Unknown Doctor';
    final specialization = model.categoryName ?? 'Specialist';
    final time = model.timeSlot ?? 'N/A';
    final date = HelperMethods.formatAppointmentDate(
        model.appointmentDate ?? 'N/A');

    final imageUrl =
        'https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔴 LEFT TIMELINE
        Column(
          children: [
            /// Circle Icon
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB5757),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),

            /// Vertical Line
            Container(
              width: 2,
              height: 170,
              color: Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(width: 12),

        /// 🔷 RIGHT SIDE CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DATE + TIME TEXT
              Text(
                "$date • $time",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEB5757),
                ),
              ),

              const SizedBox(height: 12),

              /// MAIN CARD
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.05),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /// AVATAR
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(imageUrl),
                        ),

                        const SizedBox(width: 12),

                        /// NAME + SPECIALIZATION
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                specialization,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// STATUS BADGE
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "CANCELLED",
                                  style: TextStyle(
                                    color: Color(0xFFEB5757),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// ACTION ROW
                    Row(
                      children: [
                        /// RE-BOOK BUTTON
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // SAME LOGIC
                              debugPrint(
                                  "Re-booking for: ${model.appointmentId}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF419CAB).withOpacity(0.1),
                              foregroundColor: const Color(0xFF419CAB),
                              elevation: 0,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Re-book Appointment",
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// ARROW / DETAILS ICON
                        GestureDetector(
                          onTap: () {
                            navSlideFromRight(
                              context,
                              CompletedAppointmentsDetailsScreen(
                                appointmentId:
                                model.appointmentId ?? '',
                                isCancelledAppointment: true,
                                profileImage: imageUrl,
                              ),
                            );
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}