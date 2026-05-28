import 'dart:io';
import 'package:doctors/core/utils/custom_widgets/custom_appBar.dart';
import 'package:doctors/core/utils/custom_widgets/custom_app_button.dart';
import 'package:doctors/core/utils/custom_widgets/custom_inputFiled.dart';
import 'package:doctors/core/utils/theams/color_resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../view_model/profile_view_model.dart';

class AvailabilityTimingScreen extends StatefulWidget {
  const AvailabilityTimingScreen({super.key});

  @override
  State<AvailabilityTimingScreen> createState() =>
      _AvailabilityTimingScreenState();
}

class _AvailabilityTimingScreenState extends State<AvailabilityTimingScreen> {
  @override
  void initState() {
    super.initState();
    // fetch profile to load availability
    Future.microtask(
      () =>
          Provider.of<ProfileViewModel>(context, listen: false).fetchProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Schedule Availability"),
      body: SafeArea(
        child: Consumer<ProfileViewModel>(
          builder: (context, pro, _) {
            if (pro.isLoading) {
              return const Center(child: ThreeDotsLoader(color: ColorResource.primaryColor));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Removed Global time inputs
                  // Day-wise ExpansionTiles
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pro.days.length,
                    itemBuilder: (context, index) {
                      final day = pro.days[index];
                      final isAvailable = day["available"] as bool;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: const Color(0xffE2EDEE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day["day"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Switch(
                                value: isAvailable,
                                activeColor: const Color(0xff419FAD),
                                activeTrackColor: const Color(0xff419FAD).withOpacity(0.4),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.shade300,
                                onChanged: (val) {
                                  pro.toggleDay(index, val);
                                },
                              ),
                            ],
                          ),
                          children: isAvailable
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        // Quick Apply to All Days
                                        if (index == 0 || true) // Show on all to allow copy from any
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton.icon(
                                              onPressed: () {
                                                for (int i = 0; i < pro.days.length; i++) {
                                                  if (i != index && pro.days[i]["available"]) {
                                                    pro.days[i]["openingTime"] = day["openingTime"];
                                                    pro.days[i]["closingTime"] = day["closingTime"];
                                                    pro.days[i]["sessionTime"] = day["sessionTime"];
                                                    pro.days[i]["breakTime"] = day["breakTime"];
                                                    pro.days[i]["bufferTime"] = day["bufferTime"];
                                                    pro.days[i]["lunchStart"] = day["lunchStart"];
                                                    pro.days[i]["lunchEnd"] = day["lunchEnd"];
                                                  }
                                                }
                                                // Trigger rebuild
                                                pro.notifyListeners();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Copied ${day["day"]}\'s timings to all available days.')),
                                                );
                                              },
                                              icon: const Icon(Icons.copy, size: 16),
                                              label: const Text("Apply to all available days", style: TextStyle(fontSize: 12)),
                                            ),
                                          ),
                                        // Opening Time
                                        CustomTextFieldProfile(
                                          label: "Opening Time",
                                          initialValue: day["openingTime"],
                                          isReadOnly: true,
                                          onTap: () async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (time != null) {
                                              day["openingTime"] = time.format(context);
                                              pro.notifyListeners();
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        // Closing Time
                                        CustomTextFieldProfile(
                                          label: "Closing Time",
                                          initialValue: day["closingTime"],
                                          isReadOnly: true,
                                          onTap: () async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (time != null) {
                                              day["closingTime"] = time.format(context);
                                              pro.notifyListeners();
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFieldProfile(
                                                label: "Session Time (m)",
                                                initialValue: day["sessionTime"],
                                                keyboardType: TextInputType.number,
                                                onChanged: (val) {
                                                  day["sessionTime"] = val;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: CustomTextFieldProfile(
                                                label: "Break Time (m)",
                                                initialValue: day["breakTime"],
                                                keyboardType: TextInputType.number,
                                                onChanged: (val) {
                                                  day["breakTime"] = val;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        CustomTextFieldProfile(
                                          label: "Buffer Time (minutes)",
                                          initialValue: day["bufferTime"],
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            day["bufferTime"] = val;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFieldProfile(
                                                label: "Lunch Start",
                                                initialValue: day["lunchStart"],
                                                isReadOnly: true,
                                                onTap: () async {
                                                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                                  if (time != null) {
                                                    day["lunchStart"] = time.format(context);
                                                    pro.notifyListeners();
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: CustomTextFieldProfile(
                                                label: "Lunch End",
                                                initialValue: day["lunchEnd"],
                                                isReadOnly: true,
                                                onTap: () async {
                                                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                                  if (time != null) {
                                                    day["lunchEnd"] = time.format(context);
                                                    pro.notifyListeners();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                              : [],
                        ),
                      );
                    },
                  ),
        
                  const SizedBox(height: 24),
                  
                  // Mock Slot Validation
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100,
                      foregroundColor: Colors.orange.shade900,
                    ),
                    onPressed: () {
                      // Mock validation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No overlapping slots detected with current settings.')),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Validate Slots"),
                  ),
                  const SizedBox(height: 24),

                  // 🔹 Save Button
                  CustomAppButton(
                    label: 'Save Availability',
                    onPressed: () async{
                      // final selectedDays =
                      //
                      // debugPrint("Selected Days: $selectedDays");
                      // debugPrint("Opening: ${pro.openingTimeController.text}");
                      // debugPrint("Closing: ${pro.closingTimeController.text}");
                      // debugPrint("Break: ${pro.breakTimeController.text}");
                      // debugPrint(
                      //   "Lunch: ${pro.lunchStartController.text} - ${pro.lunchEndController.text}",
                      // );
        
                      pro.updateProfile(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
