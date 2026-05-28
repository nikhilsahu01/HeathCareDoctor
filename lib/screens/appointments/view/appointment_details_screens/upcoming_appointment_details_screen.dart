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
import '../cancel_appointments.dart';
import '../reschedule_bottombar.dart';
import '../../viewModel/appointments_viewModel.dart';

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
    // Future.microtask(() {
    //   Provider.of<AppointmentDetailsViewModel>(context, listen: false)
    //       .fetchAppointmentDetails(widget.appointmentId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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

          final data = viewModel.appointmentDetails;
          if (data == null) {
            return const Center(child: Text('No appointment details available.'));
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Appointment Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Doctor Info Row
                      Row(
                        children: [

                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.transparent,
                            child: CustomImageView(
                              imagePath: '${AppUrl.baseUrl}/${data.user?.profileImage ?? ''}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.user?.name ?? "Doctor Name",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (data.category?.name?.isNotEmpty ?? false)
                                      ? data.category!.name!
                                      : "Specialization",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Booking ID: ${data.orderId ?? '----'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.call, color: Colors.black87),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Date & Time
                      Text(
                        "${HelperMethods.formatAppointmentDate(data.appointmentDate ?? '')} | ${data.timeSlot ?? 'Time'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomAppButton(
                              label: "Cancel",
                              onPressed: () async{
                                navSlideFromRight( context, CancelAppointmentsScreen(appointmentId:data.orderId ??'',));
                              },
                              textColor: ColorResource.darkText,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomAppButton(
                              label: "Reschedule",
                              onPressed: ()async {
                                // showModalBottomSheet(
                                //   context: context,
                                //   isScrollControlled: true,
                                //   shape: const RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                //   ),
                                //   builder: (context) => RescheduleBottomSheetScreen(vendorId:data.vendor?.sId ?? "",appointmentId:  widget.appointmentId,),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
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
                ),

                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
