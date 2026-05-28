import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../appointments/viewModel/appointments_viewModel.dart';

class FinancialRecordsScreen extends StatefulWidget {
  const FinancialRecordsScreen({super.key});

  @override
  State<FinancialRecordsScreen> createState() => _FinancialRecordsScreenState();
}

class _FinancialRecordsScreenState extends State<FinancialRecordsScreen> {
  bool _isCompletedSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AppointmentViewModel>(
        context,
        listen: false,
      );
      viewModel.fetchCompletedAppointments();
      viewModel.fetchCancelledAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF156C8A);
    const bgColor = Color(0xFFF4F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(title: 'Financial Records', isBack: true),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// 🔹 Toggle Buttons (Completed / Cancelled & Refunded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isCompletedSelected = true),
                    child: _toggleButton(
                      "Completed",
                      _isCompletedSelected,
                      primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isCompletedSelected = false),
                    child: _toggleButton(
                      "Cancelled/Refunded",
                      !_isCompletedSelected,
                      primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 List
          Expanded(
            child: Consumer<AppointmentViewModel>(
              builder: (context, viewModel, child) {
                if (_isCompletedSelected
                    ? viewModel.isLoadingCompleted
                    : viewModel.isLoadingCancelled) {
                  return const Center(child: ThreeDotsLoader());
                }

                final appointments =
                    _isCompletedSelected
                        ? viewModel.completedAppointments
                        : viewModel.cancelledAppointments;

                if (appointments.isEmpty) {
                  return Center(
                    child: Text(
                      "No ${_isCompletedSelected ? 'completed' : 'cancelled'} records.",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appt = appointments[index];

                    String formattedDate = '';
                    if (appt.appointmentDate != null) {
                      final d = DateTime.tryParse(appt.appointmentDate!);
                      if (d != null) {
                        formattedDate = DateFormat('dd MMM yyyy').format(d);
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Fee: ₹${appt.appointmentFee ?? 0}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorResource.primaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _isCompletedSelected
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  appt.status ?? "",
                                  style: TextStyle(
                                    color:
                                        _isCompletedSelected
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                appt.patientName ?? 'Unknown Patient',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$formattedDate | ${appt.timeSlot ?? ''}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration:
          isActive
              ? ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.48, -0.48),
                  end: Alignment(0.52, 1.48),
                  colors: [Color(0xFF006492), Color(0xFF2D9CDB)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              )
              : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryColor),
              ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
