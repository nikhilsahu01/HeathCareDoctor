import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/api_service/app_url.dart';
import '../../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/utils/theams/color_resource.dart';
import '../../viewModel/appointments_details_viewModel.dart';
import '../reschedule_bottombar.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF preview
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
//
//
//
//
// class CompletedAppointmentsDetailsScreen extends StatefulWidget {
//   final String appointmentId;
//   final bool? isCancelledAppointment;
//
//   const CompletedAppointmentsDetailsScreen({
//     Key? key,
//     required this.appointmentId,
//     this.isCancelledAppointment = false,
//   }) : super(key: key);
//
//   @override
//   State<CompletedAppointmentsDetailsScreen> createState() => _CompletedAppointmentsDetailsScreenState();
// }
//
// class _CompletedAppointmentsDetailsScreenState extends State<CompletedAppointmentsDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<AppointmentDetailsViewModel>(context, listen: false)
//           .fetchAppointmentDetails(widget.appointmentId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResource.white,
//       appBar: CustomAppBar(title: "Appointment Details"),
//       body: Consumer<AppointmentDetailsViewModel>(
//         builder: (context, viewModel, _) {
//           if (viewModel.isLoading) {
//             return const Center(child: ThreeDotsLoader());
//           }
//
//           if (viewModel.errorMessage != null) {
//             return Center(child: Text(viewModel.errorMessage!));
//           }
//
//           final model = viewModel.appointmentDetails;
//           if (model == null) {
//             return const Center(child: Text("No data available."));
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: ColorResource.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Doctor Info Row
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundColor: Colors.transparent,
//                         child: CustomImageView(
//                           imagePath: '${AppUrl.baseUrl}/${model.user?.profileImage ?? ''}',
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               model.user?.name ?? "Doctor Name",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: ColorResource.darkText,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               model.category?.name ?? "Specialization",
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text.rich(
//                               TextSpan(
//                                 text: 'Booking ID: ',
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: "#${model.orderId ?? "--"}",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//                   const Divider(),
//
//                   /// Details Section
//                   _buildDetailRow("Date & Time", "${HelperMethods.formatAppointmentDate(model.appointmentDate ?? '')} | ${model.timeSlot ?? '--'}"),
//                   _buildDetailRow("Package", model.category?.name ?? "--"),
//                   _buildDetailRow("Booking For", model.patient?.name ?? "--"),
//                   const Divider(),
//                   _buildDetailRow("Amount", "₹599"), // Replace if you add amount in model
//
//                   const SizedBox(height: 16),
//
//                   /// Buttons Row
//                   if (widget.isCancelledAppointment == false) ...[
//                     CustomAppButton(
//                       label: "Add Review",
//                       onPressed: () async{
//                         // navSlideFromRight(context,ReviewSubmissionPage(appointmentId:model.sId??'' ,consultantName: model.vendor?.name ?? '',profileImage: model.vendor?.profileImage??'',));
//                       },
//                       textColor: Colors.white,
//                     ),
//                     const SizedBox(height: 12),
//
//                     /// Aftercare Plan Button
//                     CustomAppButton(
//                       label: "View Aftercare plan",
//                       onPressed: () async{
//                  // navSlideFromRight( context, AfterCareScreen());
//                       },
//                       // textColor: ColorResource.primaryColor,
//                       // borderColor: ColorResource.primaryColor,
//                     ),
//                   ] else ...[
//                     CustomAppButton(
//                       label: "Re-book",
//                       onPressed: () async{
//                         // showModalBottomSheet(
//                         //   context: context,
//                         //   isScrollControlled: true,
//                         //   shape: const RoundedRectangleBorder(
//                         //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                         //   ),
//                         //   builder: (context) => RescheduleBottomSheetScreen(vendorId:model.vendor?.sId ?? "",appointmentId: model.sId??'',isRebook:true,categoryId: model.category?.sId,patentId: model.user?.sId,type: model.type,),
//                         // );
//                       },
//                       textColor: Colors.white,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.end,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedAppointmentsDetailsScreen extends StatefulWidget {
  final String appointmentId;
  final String profileImage;
  final bool? isCancelledAppointment;

  const CompletedAppointmentsDetailsScreen({
    Key? key,
    required this.appointmentId,
    required this.profileImage,
    this.isCancelledAppointment = false,
  }) : super(key: key);

  @override
  State<CompletedAppointmentsDetailsScreen> createState() =>
      _CompletedAppointmentsDetailsScreenState();
}

class _CompletedAppointmentsDetailsScreenState
    extends State<CompletedAppointmentsDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AppointmentDetailsViewModel>(context, listen: false)
          .fetchAppointmentDetails(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.white,
      appBar: CustomAppBar(title: "Appointment Details"),
      body: Consumer<AppointmentDetailsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: ThreeDotsLoader());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          final model = viewModel.appointmentDetails;
          if (model == null) {
            return const Center(child: Text("No data available."));
          }
// ==================== Hardcoded Attachments (Replace with model later) ====================
          final List<Map<String, String>> attachments = [
            {"type": "image", "url": widget.profileImage, "name": "Prescription.jpg"},
            {"type": "pdf", "url": "https://example.com/reports/lab_report.pdf", "name": "Lab_Report.pdf"},
            {"type": "image", "url": "https://example.com/reports/scan1.jpg", "name": "MRI_Scan.jpg"},
            // Add more as per your model
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================== Doctor Card ====================
                Container(
                  padding: const EdgeInsets.all(16),  decoration: ShapeDecoration(
                  color: const Color(0xFFF0F4FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(16),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.06),
                  //       blurRadius: 10,
                  //       offset: const Offset(0, 4),
                  //     ),
                  //   ],
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        // alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 130,
                            width: 120,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageView(
                              imagePath:widget.profileImage,
                            //  '${AppUrl.baseUrl}/${model.user?.profileImage ?? ''}',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'VERIFIED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                      "Dr. ${  model.user?.name ?? "Adrian Sterong"}",
                        style: TextStyle(
                          color: const Color(0xFF171C20),
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                      Text(
                        model.category?.name ?? "Senior Neurologist • 12 Years Exp.",
                        style: TextStyle(
                          color: const Color(0xFF006492),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.star,    color: const Color(0xFFCA850C), size: 20),
                          SizedBox(width: 4),
                          Text(
                            '4.9 (120 reviews)',
                            style: TextStyle(
                              color: const Color(0xFFCA850C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================== Date & Time ====================
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  title: "DATE",
                  value: HelperMethods.formatAppointmentDate(
                      model.appointmentDate ?? ''),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.access_time,
                  title: "TIME",
                  value: model.timeSlot ?? '10:30 AM - 11:15 AM',
                ),

                const SizedBox(height: 24),

                // ==================== Patient Information ====================
                Text(
                  'Patient Information',
                  style: TextStyle(
                    color: const Color(0xFF171C20),
                    fontSize: 18,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.56,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                           CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.person, size: 28,color: Colors.black,),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "NAME",
                                      style: const TextStyle(color: Colors.grey,fontSize: 12),
                                    ),
                                    Text(
                                      model.patient?.name ?? "Marcus Chen",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                      ),
                                    ),

                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "AGE/GENDER",
                                      style: const TextStyle(color: Colors.grey,fontSize: 12),
                                    ),
                                    Text(
                                      "${model.patient?.age ?? 28}, Male",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        "Symptoms & Notes",
                        style: TextStyle(
                          color: const Color(0xFF006492),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        // padding: const EdgeInsets.only(
                        //   top: 14.75,
                        //   left: 16,
                        //   right: 16,
                        //   bottom: 16,
                        // ),
                        decoration: BoxDecoration(color: const Color(0xFFF0F4FA)),

                        child: Text(
                          '"Persistent headache localized\nbehind the left eye for 3 days.\nSensitivity to light and mild nausea."',
                          style: TextStyle(
                            color: const Color(0xFF171C20),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.63,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFF0F7FF),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Text(
                      //     model.notes ??
                      //         "Persistent headache localized behind the left eye for 3 days. Sensitivity to light and mild nausea.",
                      //     style: const TextStyle(height: 1.5),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== Payment Summary ====================
                const Text(
                  "Payment Summary",
                  style: TextStyle(
                    color: const Color(0xFF171C20),
                    fontSize: 18,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.56,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPaymentRow("Consultation Fee", "₹599"),
                      _buildPaymentRow("Booking Service Fee", "₹50"),
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Total Amount Paid",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "₹649",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              "TRANSACTION SUCCESS",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),const SizedBox(height: 24),

                // ==================== ATTACHMENTS SECTION ====================
                const Text(
                  "Attachments",
                  style: TextStyle(
                    color: Color(0xFF171C20),
                    fontSize: 18,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.56,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                    ],
                  ),
                  child: attachments.isEmpty
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No attachments available"),
                    ),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: attachments.length,
                    itemBuilder: (context, index) {
                      final file = attachments[index];
                      final isPdf = file['type'] == 'pdf';

                      return GestureDetector(
                        onTap: () => _showFullPreview(context, file),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: isPdf ? Colors.red[50] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isPdf
                                  ? const Icon(Icons.picture_as_pdf,
                                  size: 40, color: Colors.red)
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomImageView(
                                  imagePath: file['url']!,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              file['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // ==================== Action Buttons ====================
                if (widget.isCancelledAppointment == false) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text("Start Chat"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.videocam),
                          label: const Text("Start Video Call"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomAppButton(
                    label: "Add Review",
                    onPressed: ()async {
                      // navSlideFromRight(context, ReviewSubmissionPage(...));
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomAppButton(
                    label: "View Aftercare Plan",
                    onPressed: ()async {
                      // navSlideFromRight(context, AfterCareScreen());
                    },
                  ),
                ] else ...[
                  CustomAppButton(
                    label: "Re-book",
                    onPressed: () async{
                      // Rebook logic
                    },
                  ),
                ],

                const SizedBox(height: 20),

                // Cancel Appointment (only if not cancelled)
                if (widget.isCancelledAppointment == false)
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Cancel Appointment",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Widgets
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x26BEC7D1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A171C20),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const  Color(0x19006492),
            child: Icon(icon, color: ColorResource.primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color:     const Color(0xFF3F4850), fontSize: 13)),
              Text(
                value,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(amount, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
  // ===================== FULL SCREEN PREVIEW =====================
  void _showFullPreview(BuildContext context, Map<String, String> file) {
    final isPdf = file['type'] == 'pdf';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: CustomAppBar(title: file['name']!),
          // appBar: AppBar(
          //   title: Text(file['name']!),
          //   backgroundColor: Colors.black87,
          // ),
          backgroundColor: Colors.black,
          body: Center(
            child: isPdf
                ? FutureBuilder<File>(
              future: _loadPdfFromNetwork(file['url']!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PDFView(
                    filePath: snapshot.data!.path,
                  );
                } else if (snapshot.hasError) {
                  return const Text("Failed to load PDF", style: TextStyle(color: Colors.white));
                }
                return const CircularProgressIndicator(color: Colors.white);
              },
            )
                : InteractiveViewer(
              child: CustomImageView(
                imagePath: file['url']!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File> _loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}