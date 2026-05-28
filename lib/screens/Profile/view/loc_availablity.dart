
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../core/utils/custom_widgets/custom_inputFiled.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../view_model/profile_view_model.dart';



class LocationAvailabilityScreen extends StatefulWidget {//Availability
  const LocationAvailabilityScreen({super.key});

  @override
  State<LocationAvailabilityScreen> createState() => _LocationAvailabilityScreenState();
}

class _LocationAvailabilityScreenState extends State<LocationAvailabilityScreen> {
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileViewModel>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final value =  Provider.of<ProfileViewModel>(context, listen: false).videoConsultAvailable;
    print(value);
    return Consumer<ProfileViewModel>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: ColorResource.white,
          appBar: CustomAppBar(title: 'Location & Availability'),
          body: provider.isLoading
              ? const Center(child: ThreeDotsLoader(color: ColorResource.primaryColor))
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFieldProfile(
                      label: "Clinic/Hospital Address",
                      controller: provider.hospitalAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'This field is required';
                        return null;
                      },
                      onTap: (){
                        provider.openMap(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "City",
                      controller: provider.cityController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'This field is required';
                        return null;
                      },
                      onTap: (){   provider.openMap(context);},
                    ),
                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "State",
                      controller: provider.stateController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'This field is required';
                        return null;
                      },
                      onTap: (){   provider.openMap(context);},

                    ),
                    const SizedBox(height: 15),

                    CustomTextFieldProfile(
                      label: (provider.pincodeController.text.trim().isEmpty)
                          ? "Postal Code"
                          : (provider.pincodeController.text.trim().length == 6
                          ? "Pincode"
                          : "Zip Code"),
                      controller: provider.pincodeController,
                      maxLength: 6,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Pincode is required';
                        if (val.trim().length != 6) return 'Pincode must be exactly 6 digits';
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onChanged: (val) async {
                        if (val != null && val.length == 6) {
                          final location = await HelperMethods.getLocationFromPincode(val);
                          if (location != null) {
                            provider.stateController.text = location["state"] ?? "";
                            provider.cityController.text = location["district"] ?? "";
                            provider.countryController.text = location["country"] ?? "";
                            provider.notifyListeners();
                          } else {
                            HelperMethods.showFloatingToast(context, message: 'Invalid or unknown pincode');
                          }
                        }
                        provider.notifyListeners(); // To update label (Postal Code/Pincode/Zip Code)
                      },
                    ),     const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "Country",
                      controller: provider.countryController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'This field is required';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onTap: (){   provider.openMap(context);},
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("In-clinic Availability", style: TextStyle(fontSize: 16)),
                        Switch(
                          value: provider.inClinicAvailable,
                          onChanged: (val) {
                            provider.inClinicAvailable = val;
                            provider.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if(provider.inClinicAvailable)...[
                      const SizedBox(height: 15),
                      CustomTextFieldProfile(
                        label: "In-Clinic Fee",
                        controller: provider.inClinicFee,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'This field is required';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Video consult Availability", style: TextStyle(fontSize: 16)),
                        Switch(
                          value: provider.videoConsultAvailable,
                          onChanged: (val) {
                            provider.videoConsultAvailable = val;
                            provider.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if(provider.videoConsultAvailable)...[
                      const SizedBox(height: 15),
                      CustomTextFieldProfile(
                        label: "Video Consultation Fee",
                        controller: provider.videoConsultFee,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'This field is required';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 15),
                    CustomAppButton(
                      label: provider.isLoading
                          ? "Saving..."
                          : "Update Profile",
                      isLoading: provider.isLoading,
                      onPressed: ()async {
                        if (_formKey.currentState!.validate()) {
                          provider.updateProfile(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


