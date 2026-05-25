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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pro.days.length,
                    itemBuilder: (context, index) {
                      final day = pro.days[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffE2EDEE),
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white)
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Color(0x22000000),
                          //     blurRadius: 4,
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
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
                                value: day["available"] as bool,
                                activeColor: Color(0xff419FAD), // thumb color (circle)
                                activeTrackColor: Color(0xff419FAD).withOpacity(0.4), // background
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.shade300,
                                onChanged: (val) {
                                  pro.toggleDay(index, val);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        
                  const SizedBox(height: 24),
        
                  // 🔹 Opening Time
                  CustomTextFieldProfile(
                    label: "Opening Time",
                    controller: pro.openingTimeController,
                    isReadOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        pro.openingTimeController.text = time.format(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldProfile(
                    label: "Closing Time",
                    controller: pro.closingTimeController,
                    isReadOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        pro.closingTimeController.text = time.format(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldProfile(
                    label: "Session Time (minutes)",
                    controller: pro.sessionTimeController,
                    keyboardType: TextInputType.number,
                  ),
                  // 🔹 Break Time (minutes)
                  const SizedBox(height: 16),
                  CustomTextFieldProfile(
                    label: "Break Time (minutes)",
                    controller: pro.breakTimeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldProfile(
                    label: "Buffer Time (minutes)",
                    controller: pro.bufferTimeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // 🔹 Lunch Start
                  CustomTextFieldProfile(
                    controller: pro.lunchStartController,
        
                    label: "Lunch Start Time",
        
                    isReadOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        pro.lunchStartController.text = time.format(context);
                      }
                    },
                  ),
        
                  const SizedBox(height: 16),
        
                  // 🔹 Lunch End
                  CustomTextFieldProfile(
                    label: 'Lunch End Time',
                    controller: pro.lunchEndController,
                    isReadOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        pro.lunchEndController.text = time.format(context);
                      }
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
