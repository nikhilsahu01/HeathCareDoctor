import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/utils/theams/color_resource.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../viewModel/reschedule_viewModel.dart';

class CancelAppointmentsScreen extends StatefulWidget {
  final String appointmentId;

  const CancelAppointmentsScreen({super.key, required this.appointmentId});

  @override
  State<CancelAppointmentsScreen> createState() => _CancelAppointmentsScreenState();
}

class _CancelAppointmentsScreenState extends State<CancelAppointmentsScreen> {
  final List<CancelReason> reasons = [
    CancelReason(title: 'Schedule Change'),
    CancelReason(title: 'Unexpected Work'),
    CancelReason(title: 'Weather Condition'),
    CancelReason(title: 'Other', isOther: true),
  ];

  int? selectedIndex;
  final TextEditingController _otherReasonController = TextEditingController();


  void _onCancelPressed() async {
    String selectedReason = '';

    if (selectedIndex == null) {
      HelperMethods.showCustomSnackbar(context, message: 'Please choose a reason');
      return;
    }

    if (reasons[selectedIndex!].isOther) {
      selectedReason = _otherReasonController.text.trim();
      if (selectedReason.isEmpty) {
        HelperMethods.showCustomSnackbar(context, message: 'Please write your reason');
        return;
      }
    } else {
      selectedReason = reasons[selectedIndex!].title;
    }

    print("🧨 Selected Cancel Reason: $selectedReason");

    // final vm = Provider.of<RescheduleViewModel>(context, listen: false);
    // final success = await vm.cancelAppointment(
    //   appointmentId: widget.appointmentId,
    //   cancelReason: selectedReason,
    // );

    // if (success) {
      // showDialog(
      //   context: context,
        // builder: (_) => BookingCompletionDialogue(
        //   message: 'Your Appointment has been Cancelled.',
        //   buttonText: 'Back to home',
        //   imagePath: 'assets/icons/appointmentsCompletionIcon.png',
        // ),
      // );
    // } else {
    //   HelperMethods.showCustomSnackbar(context, message: 'Something went wrong');
    // }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResource.white,
      appBar: CustomAppBar(title: "Cancel"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please Select Reason For cancellation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(reasons.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged: (val) {
                  setState(() {
                    selectedIndex = val!;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(
                  reasons[index].title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                activeColor: ColorResource.primaryColor,
              );
            }),
            if (selectedIndex != null && reasons[selectedIndex!].isOther) ...[
              const Divider(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _otherReasonController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write Your Reason",
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            CustomAppButton(
              label: "Cancel Appointment",
              onPressed:()async{_onCancelPressed();} ,
            ),
          ],
        ),
      ),
    );
  }
}
class CancelReason {
  final String title;
  final bool isOther;

  CancelReason({required this.title, this.isOther = false});
}
