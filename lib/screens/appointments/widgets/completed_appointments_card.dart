// import 'package:flutter/material.dart';
// import '../../../core/api_service/app_url.dart';
// import '../../../core/utils/custom_widgets/custom_image_view.dart';
// import '../../../core/utils/helper_functions/helpers_methods.dart';
// import '../../../core/utils/navigation_helper.dart';
// import '../../../core/utils/theams/color_resource.dart';
//
// import '../model/appointments_model.dart';
// import '../view/appointment_details_screens/complete_appointment_details_screen.dart';
//
//
// class CompletedAppointmentCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const CompletedAppointmentCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     final doctorName = model.patientName ?? 'Unknown Doctor';
//     final imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/250px-Image_created_with_a_mobile_phone.png';
//     final specialization = model.categoryName?? 'Unknown Specialization';
//     final time = model.timeSlot ?? 'N/A';
//
//     return GestureDetector(
//       onTap: () {
//         navSlideFromRight(
//           context,
//           CompletedAppointmentsDetailsScreen(appointmentId: model.appointmentId??''),
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
//                     // imagePath: '${AppUrl.baseUrl}/$imageUrl',
//                     imagePath: imageUrl,
//                     height: 56,
//                     width: 56,
//                     fit: BoxFit.cover,
//                     // placeHolder: 'assets/images/imageNotFound.png',
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
//                   "Completed",
//                   style: TextStyle(
//                     color: ColorResource.greyBorder,
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
//
// class CompletedAppointmentCard extends StatelessWidget {
//   final AppointmentsList model;
//
//   const CompletedAppointmentCard({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     // Premium Medical Palette
//     const primaryBlue = Color(0xFF419CAB);
//     const Color kSuccessGreen =  Color(0xFF419CAB);
//     // const Color kSuccessGreen = Color(0xFF0EBE7F);
//     const Color kTextPrimary = Color(0xFF333333);
//     const Color kTextSecondary = Color(0xFF677294);
//     const Color kBgLight = Color(0xFFF8FAFC);
//
//     final doctorName = model.patientName ?? 'Unknown Doctor';
//     final specialization = model.categoryName ?? 'Specialist';
//     final time = model.timeSlot ?? 'N/A';
//     final imageUrl = 'https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg?semt=ais_hybrid&w=740&q=80';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16,),
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
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(24),
//           onTap: () {
//             navSlideFromRight(
//               context,
//               CompletedAppointmentsDetailsScreen(
//                 appointmentId: model.appointmentId ?? '',
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Top Section: Doctor Profile & Status
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: kBgLight, width: 2),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(14),
//                         child: CustomImageView(
//                           imagePath: imageUrl,
//                           height: 60,
//                           width: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             doctorName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: kTextPrimary,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               letterSpacing: -0.5,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             specialization,
//                             style: const TextStyle(
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     /// Success Badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: kSuccessGreen.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Text(
//                         "Completed",
//                         style: TextStyle(
//                           color: kSuccessGreen,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child: Divider(height: 1, color: Color(0xFFF1F1F1)),
//                 ),
//
//                 /// Bottom Section: Date & Time Info
//                 Row(
//                   children: [
//                     _buildInfoItem(
//                       Icons.calendar_today_rounded,
//                       HelperMethods.formatAppointmentDate(model.appointmentDate ?? 'N/A'),
//                       kTextSecondary,
//                     ),
//                     const SizedBox(width: 24),
//                     _buildInfoItem(
//                       Icons.access_time_rounded,
//                       time,
//                       kTextSecondary,
//                     ),
//                     const Spacer(),
//                     // Re-book or Details icon
//                     const Icon(
//                       Icons.arrow_forward_ios_rounded,
//                       size: 14,
//                       color: Color(0xFFC4C4C4),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Helper widget for the Date/Time footer items
//   Widget _buildInfoItem(IconData icon, String label, Color color) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: color.withOpacity(0.7)),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }




class CompletedAppointmentCard extends StatelessWidget {
  final AppointmentsList model;

  const CompletedAppointmentCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final doctorName = model.patientName ?? 'Unknown Doctor';
    final specialization = model.categoryName ?? 'Specialist';
    final time = model.timeSlot ?? 'N/A';
    final date = HelperMethods.formatAppointmentDate(
        model.appointmentDate ?? 'N/A');

    final imageUrl = model.patientImage ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔵 LEFT TIMELINE
        Column(
          children: [
            /// Circle Icon
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color:Color(0xFF0F5B7F),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
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
                  color: Color(0xFF0F5B7F),
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

                              /// STATUS AND EARNINGS ROW
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "COMPLETED",
                                      style: TextStyle(
                                        color: Color(0xFF419CAB),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (model.netEarnings != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Earned: ₹${model.netEarnings}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
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
                        /// VIEW DETAILS BUTTON
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              navSlideFromRight(
                                context,
                                CompletedAppointmentsDetailsScreen(
                                  appointmentId:
                                  model.appointmentId ?? '',
                                  profileImage: imageUrl,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0F5B7F),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "View Details",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// ARROW ICON
                        Container(
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