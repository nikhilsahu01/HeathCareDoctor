// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../core/utils/custom_widgets/custom_app_button.dart';
// import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../../core/utils/helper_functions/helpers_methods.dart';
// import '../../../core/utils/navigation_helper.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import '../viewModel/reschedule_viewModel.dart';
//
// class RescheduleBottomSheetScreen extends StatefulWidget {
//   final String vendorId;
//   final String appointmentId;
//   final String? patentId;
//   final String? categoryId;
//   final String? type;
//   final bool? isRebook;
//
//   const RescheduleBottomSheetScreen({super.key, required this.vendorId, required this.appointmentId,this.isRebook,this.type,this.categoryId,this.patentId});
//
//   @override
//   State<RescheduleBottomSheetScreen> createState() => _RescheduleBottomSheetScreenState();
// }
//
// class _RescheduleBottomSheetScreenState extends State<RescheduleBottomSheetScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<RescheduleViewModel>(context, listen: false).initDates(widget.vendorId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bookingType = widget.isRebook == true ? 'Re-Booking' : 'Reschedule';
//
//     return DraggableScrollableSheet(
//       initialChildSize: 0.55,
//       minChildSize: 0.4,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) {
//         return Consumer<RescheduleViewModel>(
//           builder: (context, vm, _) {
//             return Container(
//               color: ColorResource.white,
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 90),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       decoration: const BoxDecoration(
//                         color: ColorResource.white,
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                       ),
//                       child: SingleChildScrollView(
//                         controller: scrollController,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Swipe indicator
//                             Center(
//                               child: Container(
//                                 width: 60,
//                                 height: 6,
//                                 margin: const EdgeInsets.only(bottom: 20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade400,
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 4,
//                                       offset: Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             Text("Choose $bookingType Date",
//                                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 20),
//                             const Text("Day",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 12),
//
//                             // Days Row
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 children: List.generate(vm.availableDates.length, (index) {
//                                   final dateStr = vm.availableDates[index];
//                                   final date = DateTime.parse(dateStr);
//                                   final day = DateFormat('EEEE').format(date);
//                                   final dateFormatted = DateFormat('d MMM').format(date);
//                                   final isSelected = index == vm.selectedDayIndex;
//
//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 12),
//                                     child: GestureDetector(
//                                       onTap: () => vm.selectDay(index, widget.vendorId),
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(30),
//                                           border: Border.all(
//                                             color: isSelected
//                                                 ? ColorResource.primaryColor
//                                                 : Colors.grey.shade300,
//                                           ),
//                                           color: isSelected
//                                               ? ColorResource.primaryColor
//                                               : Colors.white,
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               day,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 13,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             Text(
//                                               dateFormatted,
//                                               style: TextStyle(
//                                                 color: isSelected
//                                                     ? ColorResource.primaryColor
//                                                     : Colors.black87,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//
//                             const SizedBox(height: 24),
//                             const Text("Time",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 12),
//
//                             vm.isLoading
//                                 ? const Center(child: ThreeDotsLoader())
//                                 // : vm.timeSlots.isEmpty
//                             //     ? Padding(
//                             //   padding: const EdgeInsets.symmetric(vertical: 24),
//                             //   child: Center(
//                             //     child: Text(
//                             //       'No time slots available on this date.',
//                             //       style: TextStyle(
//                             //         color: Colors.red.shade600,
//                             //         fontWeight: FontWeight.w600,
//                             //       ),
//                             //     ),
//                             //   ),
//                             // )
//                             //     : Wrap(
//                             //   spacing: 12,
//                             //   runSpacing: 12,
//                             //   children: List.generate(vm.timeSlots.length, (index) {
//                             //     final slot = vm.timeSlots[index];
//                             //     final isSelected = index == vm.selectedTimeIndex;
//                             //     final isBooked = slot.status?.toLowerCase() == 'booked';
//                             //     final label = "${slot.start ?? ''} - ${slot.end ?? ''}";
//                             //
//                             //     return GestureDetector(
//                             //       onTap: () {
//                             //         if (!isBooked) vm.selectTime(index);
//                             //       },
//                             //       child: Container(
//                             //         padding: const EdgeInsets.symmetric(
//                             //             horizontal: 18, vertical: 12),
//                             //         decoration: BoxDecoration(
//                             //           borderRadius: BorderRadius.circular(24),
//                             //           border: Border.all(
//                             //             color: isSelected
//                             //                 ? ColorResource.primaryColor
//                             //                 : Colors.grey.shade300,
//                             //           ),
//                             //           color: isBooked
//                             //               ? Colors.grey.shade200
//                             //               : isSelected
//                             //               ? ColorResource.primaryColor
//                             //               : Colors.white,
//                             //         ),
//                             //         child: Text(
//                             //           label,
//                             //           style: TextStyle(
//                             //             color: isBooked
//                             //                 ? Colors.grey
//                             //                 : isSelected
//                             //                 ? ColorResource.primaryColor
//                             //                 : Colors.black87,
//                             //             fontWeight: FontWeight.w600,
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     );
//                             //   }),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Fixed Bottom Buttons
//                   Positioned(
//                     left: 20,
//                     right: 20,
//                     bottom: 20,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: CustomAppButton(
//                             label: "Cancel",
//                             onPressed: () => navPop(context: context),
//                             // color: Colors.white,
//                             // textColor: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         // Expanded(
//                         //   child: CustomAppButton(
//                         //     label: "Confirm",
//                         //     onPressed: () async {
//                         //       if (vm.selectedTimeIndex == -1) {
//                         //         HelperMethods.showFloatingToast(
//                         //             context, message: "Please select a time slot");
//                         //         return;
//                         //       }
//                         //
//                         //       final selectedDate = vm.availableDates[vm.selectedDayIndex];
//                         //       final selectedSlot = vm.timeSlots[vm.selectedTimeIndex];
//                         //       final newTime =
//                         //           "${selectedSlot.start ?? ''} - ${selectedSlot.end ?? ''}";
//                         //
//                         //       if (widget.isRebook == false) {
//                         //         final success = await vm.rescheduleAppointment(
//                         //           appointmentId: widget.appointmentId,
//                         //           newDate: selectedDate,
//                         //           newTime: newTime,
//                         //         );
//                         //         if (success) {
//                         //           if (context.mounted) navPop(context: context);
//                         //           if (context.mounted) {
//                         //             // showDialog(
//                         //             //   context: context,
//                         //             //   builder: (_) => BookingCompletionDialogue(
//                         //             //     message: 'Your Appointment has been Updated',
//                         //             //     buttonText: 'Back to home',
//                         //             //     imagePath:
//                         //             //     'assets/icons/appointmentsCompletionIcon.png',
//                         //             //   ),
//                         //             // );
//                         //           }
//                         //         } else {
//                         //           HelperMethods.showFloatingToast(context,
//                         //               message: "Booking failed, please try again.");
//                         //         }
//                         //       } else {
//                         //         final success = await Provider.of<PatientsViewModel>(context, listen: false).bookAppointment(
//                         //           patientId: widget.patentId ?? '',
//                         //           vendorId: widget.vendorId,
//                         //           appointmentDate: selectedDate,
//                         //           timeSlot: newTime,
//                         //           reminders: [],
//                         //           type: widget.type ?? '',
//                         //           categoryId: widget.categoryId ?? '',
//                         //         );
//                         //
//                         //         if (success) {
//                         //           if (context.mounted) navPop(context: context);
//                         //           if (context.mounted) {
//                         //             showDialog(
//                         //               context: context,
//                         //               builder: (_) => BookingCompletionDialogue(
//                         //                 message: 'Your Appointment has been Updated',
//                         //                 buttonText: 'Back to home',
//                         //                 imagePath:
//                         //                 'assets/icons/appointmentsCompletionIcon.png',
//                         //               ),
//                         //             );
//                         //           }
//                         //         } else {
//                         //           HelperMethods.showFloatingToast(context,
//                         //               message: "Booking failed, please try again.");
//                         //         }
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
