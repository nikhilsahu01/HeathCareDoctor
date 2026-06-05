import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api_service/app_url.dart';
import '../../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/custom_widgets/custom_image_view.dart';
import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/utils/theams/color_resource.dart';

import '../../viewModel/appointments_details_viewModel.dart';
import '../../viewModel/appointments_viewModel.dart';
import '../cancel_appointments.dart';
import '../reschedule_bottombar.dart';

class UpcomingAndCancelledAppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId; 

  const UpcomingAndCancelledAppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<UpcomingAndCancelledAppointmentDetailsScreen> createState() => _UpcomingAndCancelledAppointmentDetailsScreenState();
}

class _UpcomingAndCancelledAppointmentDetailsScreenState extends State<UpcomingAndCancelledAppointmentDetailsScreen> {
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
      appBar: CustomAppBar(title: "Appointments Details"),
      body: Consumer<AppointmentDetailsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: ThreeDotsLoader());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage ?? 'Error'));
          }

          final model = viewModel.appointmentDetails;
          if (model == null) {
            return const Center(child: Text('No appointment details available.'));
          }
          final List attachments = model.attachments ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================== Doctor Card ====================
                Container(
                  padding: const EdgeInsets.all(16),  
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF0F4FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          const SizedBox(
                            height: 130,
                            width: 120,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageView(
                              imagePath: '${AppUrl.baseUrl}/${model.user?.profileImage ?? ''}',
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
                      "Dr. ${model.user?.name ?? ""}",
                        style: const TextStyle(
                          color: Color(0xFF171C20),
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                      Text(
                        model.category?.name ?? "General",
                        style: const TextStyle(
                          color: Color(0xFF006492),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                const Text(
                  'Patient Information',
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
                            child: const Icon(Icons.person, size: 28,color: Colors.black,),
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
                                    const Text(
                                      "NAME",
                                      style: TextStyle(color: Colors.grey,fontSize: 12),
                                    ),
                                    Text(
                                      model.patient?.name ?? "",
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
                                    const Text(
                                      "AGE",
                                      style: TextStyle(color: Colors.grey,fontSize: 12),
                                    ),
                                    Text(
                                      "${model.patient?.age ?? '--'} Years",
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
                          color: Color(0xFF006492),
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
                        decoration: const BoxDecoration(color: Color(0xFFF0F4FA)),
                        child: Text(
                          model.notes ?? "No notes provided",
                          style: const TextStyle(
                            color: Color(0xFF171C20),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.63,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (model.latestHealthRecord != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    "Latest Health Record",
                    style: TextStyle(
                      color: Color(0xFF171C20),
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.56,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      final fileType = model.latestHealthRecord?.fileType ?? '';
                      final isPdf = fileType.toLowerCase().contains('pdf') ||
                          fileType.toLowerCase().contains('document') ||
                          (model.latestHealthRecord?.url ?? '').toLowerCase().endsWith('.pdf');
                      _showFullPreview(context, {
                        'type': isPdf ? 'pdf' : 'image',
                        'name': model.latestHealthRecord?.title ?? 'Health Record',
                        'url': model.latestHealthRecord?.url ?? '',
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorResource.primaryColor.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorResource.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.description,
                              color: ColorResource.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.latestHealthRecord?.title ?? "Health Record",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Uploaded on: ${HelperMethods.formatAppointmentDate(model.latestHealthRecord?.createdAt ?? '')}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ==================== Payment Summary ====================
                const Text(
                  "Payment Summary",
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
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPaymentRow("Consultation Fee", "₹${model.amount ?? 0}"),
                      _buildPaymentRow("Booking Service Fee", "₹0"),
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount Paid",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "₹${model.amount ?? 0}",
                            style: const TextStyle(
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

                const SizedBox(height: 24),

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
                                  imagePath: file['url'] ?? '',
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              file['name'] ?? '',
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                           // Cancel Action
                           navSlideFromRight( context, CancelAppointmentsScreen(appointmentId: widget.appointmentId));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Reschedule Action
                          // showModalBottomSheet(
                          //   context: context,
                          //   isScrollControlled: true,
                          //   shape: const RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          //   ),
                          //   builder: (context) => RescheduleBottomSheetScreen(vendorId:model.user?.id ?? "",appointmentId:  widget.appointmentId, isRebook: false, type: model.type, patentId: model.patient?.id),
                          // );
                          HelperMethods.showFloatingToast(context, message: 'Reschedule functionality coming soon');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorResource.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Reschedule",
                          style: TextStyle(
                            color: ColorResource.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Note: We use widget.appointmentId so only THIS appointment is completed
                      final success = await Provider.of<AppointmentViewModel>(context, listen: false)
                          .completeAppointment(widget.appointmentId);
                      if (success) {
                        HelperMethods.showFloatingToast(context, message: 'Appointment marked as Completed');
                        Navigator.pop(context);
                      } else {
                        HelperMethods.showFloatingToast(context, message: 'Failed to complete appointment');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResource.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Complete Appointment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  style: const TextStyle(color: Color(0xFF3F4850), fontSize: 13)),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
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
  void _showFullPreview(BuildContext context, Map<String, dynamic> file) {
    final isPdf = file['type'] == 'pdf';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: CustomAppBar(title: file['name'] ?? ''),
          backgroundColor: Colors.black,
          body: Center(
            child: isPdf
                ? FutureBuilder<File>(
              future: _loadPdfFromNetwork(file['url'] ?? ''),
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
                imagePath: file['url'] ?? '',
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
