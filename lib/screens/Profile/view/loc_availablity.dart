
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../core/utils/custom_widgets/custom_inputFiled.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/helper_functions/valdationFunctions.dart';
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
                      validator: justForEmpty,
                      onTap: (){
                        provider.openMap(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "City",
                      controller: provider.cityController,
                      validator: justForEmpty,
                      onTap: (){   provider.openMap(context);},
                    ),
                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "State",
                      controller: provider.stateController,
                      validator: justForEmpty,
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
                      validator: justForEmpty,
                      keyboardType: TextInputType.number,
                      onTap: () {
                        provider.openMap(context);
                      },
                    ),     const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "Country",
                      controller: provider.countryController,
                      validator: justForEmpty,
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
                        validator: justForEmpty,
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
                        validator: justForEmpty,
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


