import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_service/app_url.dart';
import '../../../core/coreServices/socket_service/join_call_provider.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../VideoCall/agoraVideoCall.dart';
import '../model/appointments_model.dart';
import '../viewModel/appointments_viewModel.dart';

class UpcomingAppointmentsCard extends StatefulWidget {
  final AppointmentsList model;
  final AppointmentViewModel provider;

  const UpcomingAppointmentsCard({
    super.key,
    required this.model,
    required this.provider,
  });

  @override
  State<UpcomingAppointmentsCard> createState() =>
      _UpcomingAppointmentsCardState();
}

class _UpcomingAppointmentsCardState extends State<UpcomingAppointmentsCard> {
  String? selectedMobile;

  @override
  Widget build(BuildContext context) {
    final vendorName = widget.model.patientName ?? 'Unknown Doctor';
    final specialization = widget.model.categoryName ?? 'Specialist';
    final imageUrl = (widget.model.patientImage != null && widget.model.patientImage!.isNotEmpty)
        ? (widget.model.patientImage!.startsWith('http') ? widget.model.patientImage! : '${AppUrl.baseUrl}/${widget.model.patientImage!}')
        : 'https://img.freepik.com/free-photo/businessman-formal-wear-professional-corporate-concept_53876-71166.jpg';

    final canJoin = context.watch<JoinCallNotifier>().canJoin(
      widget.model.appointmentId ?? '',
    );
    final formateDate = HelperMethods.formatAppointmentDate(
      widget.model.appointmentDate ?? 'N/A',
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT TIMELINE
        Column(
          children: [
            /// Circle Icon
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F5B7F),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 18,
              ),
            ),

            /// Vertical Line
            Container(width: 2, height: 170, color: Colors.grey.shade300),
          ],
        ),

        const SizedBox(width: 12),

        /// RIGHT CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DATE + TIME TEXT
              Text(
                "${formateDate} • ${widget.model.timeSlot ?? ''}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F5B7F),
                ),
              ),

              const SizedBox(height: 12),

              /// MAIN CARD
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.05),
                    ),
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
                                vendorName,
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
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "CONFIRMED",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (widget.model.appointmentFee != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Fee: ₹${widget.model.appointmentFee}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// BUTTON ROW
                    Row(
                      children: [
                        /// JOIN CALL BUTTON OR IN-CLINIC INDICATOR
                        if (widget.model.type == 'inClinic')
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.local_hospital, size: 18, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text("In-Clinic", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  canJoin ? () => _handleJoinCall(context) : null,
                              icon: const Icon(Icons.videocam, size: 18),
                              label: const Text("Join Call"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F5B7F),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(width: 10),

                        /// Invite hoga ye doctor  ICON
                        widget.model.inviteDoctor == null
                            ? GestureDetector(
                              onTap: () async {
                                await widget.provider.fetchDoctorList();

                                TextEditingController searchController =
                                    TextEditingController();

                                String? selectedMobile;

                                List<Map<String, String>> doctorList = widget.provider.availableDoctors.map((doc) {
                                  return {
                                    "name": doc["Name"]?.toString() ?? "Unknown Doctor",
                                    "mobile": doc["mobile"]?.toString() ?? "",
                                  };
                                }).toList();

                                List<Map<String, String>> filteredList =
                                    List.from(doctorList);

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text("Invite Doctor"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // ✅ Search Field
                                                TextField(
                                                  controller: searchController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            "Search doctor...",
                                                        border:
                                                            OutlineInputBorder(),
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                        ),
                                                      ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      filteredList =
                                                          doctorList
                                                              .where(
                                                                (doc) =>
                                                                    doc["name"]!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                          value
                                                                              .toLowerCase(),
                                                                        ) ||
                                                                    doc["mobile"]!
                                                                        .contains(
                                                                          value,
                                                                        ),
                                                              )
                                                              .toList();
                                                    });
                                                  },
                                                ),
                                            
                                                const SizedBox(height: 10),
                                            
                                                // ✅ Filtered List
                                                SizedBox(
                                                  height: 200,
                                                  width: double.maxFinite,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        filteredList.length,
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      final doc =
                                                          filteredList[index];
                                            
                                                      return RadioListTile<
                                                        String
                                                      >(
                                                        value: doc["mobile"]!,
                                                        groupValue:
                                                            selectedMobile,
                                                        title: Text(doc["name"]!),
                                                        subtitle: Text(
                                                          doc["mobile"]!,
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedMobile =
                                                                value;
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),

                                            ElevatedButton(
                                              onPressed: () async {
                                                // ✅ Validation
                                                if (selectedMobile == null) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Please select a mobile number",
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                Navigator.pop(
                                                  context,
                                                ); // dialog close

                                                // ✅ API Call (same logic)
                                                await widget.provider
                                                    .checkDoctorExistingApi(
                                                      mobileNumber:
                                                          selectedMobile!,
                                                      // 👈 dynamic
                                                      appointmentId:
                                                          widget
                                                              .model
                                                              .appointmentId ??
                                                          "",
                                                    );

                                                Navigator.pop(
                                                  context,
                                                ); // bottom sheet close
                                              },
                                              child: const Text("Send Invite"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset("assets/icons/doctor.png"),
                                ),
                                //   child: const Icon(Icons.person,size: 22,),
                              ),
                            )
                            : Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleJoinCall(context),
                                // 🔥 SAME FUNCTION
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  "Join Group Call",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleJoinCall(BuildContext context) async {
    final appointmentId = widget.model.appointmentId ?? '';

    // ✅ UNIQUE UID (VERY IMPORTANT)
    int uid = DateTime.now().millisecondsSinceEpoch % 100000;

    try {
      final response = await http.get(
        Uri.parse('${AppUrl.videoCall}/$appointmentId/$uid'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['data']['token'] ?? '';
        final channel = json['data']['channelName'] ?? appointmentId;

        if (token.isEmpty) {
          HelperMethods.showFloatingToast(
            context,
            message: "Token not generated",
          );
          return;
        }

        navSlideFromRight(
          context,
          AgoraVideoCallScreen(
            channelName: channel,
            token: token,
            uid: uid,
            appointmentId: appointmentId, isDoctor: true,
          ),
        );
      } else {
        HelperMethods.showFloatingToast(
          context,
          message: 'Failed to join call',
        );
      }
    } catch (e) {
      HelperMethods.showFloatingToast(context, message: 'Connection Error');
    }
  }
}
