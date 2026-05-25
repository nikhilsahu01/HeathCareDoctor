import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/custom_widgets/customMultipleSelectionWithChip.dart';
import '../../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../../core/utils/custom_widgets/custom_inputFiled.dart';
import '../../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../../core/utils/helper_functions/valdationFunctions.dart';
import '../../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../../core/utils/theams/color_resource.dart';
import '../helper/qualificationData.dart';
import '../model/doctors_category_model.dart';
import '../viewModel/registration_provider.dart';

class RegistrationScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? isoCode;
  final bool? mobAvailable;
  const RegistrationScreen({super.key,  this.countryCode,this.isoCode, this.mobileNumber,this.mobAvailable});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  File? profileFile;
  File? certificateFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController typeController = TextEditingController(text: "doctor");
  final TextEditingController addressController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityPinController = TextEditingController();
  final TextEditingController inClinicFeeController = TextEditingController();
  final TextEditingController videoFeeController = TextEditingController();
  final TextEditingController certificateController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();

  bool inClinicAvailable = false;
  bool videoConsultAvailable = false;
  String? profileImagePath;

  /// store selected symptom IDs
  List<String> selectedSymptomIds = [];

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.mobAvailable == true &&
        widget.mobileNumber != null &&
        widget.countryCode != null) {
      mobController.text = "${widget.countryCode}${widget.mobileNumber}";
    }

    // Fetch categories & symptoms when screen loads
    Future.microtask(() {
      final provider = Provider.of<RegistrationProvider>(context, listen: false);
      provider.fetchDoctorCategories();
      provider.fetchSymptomsApi();
      provider.fetchSpecializationsApi(); // MOCK
      provider.fetchDegreesApi(); // MOCK
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
    qualificationController.dispose();
    typeController.dispose();
    addressController.dispose();
    departmentController.dispose();
    experienceController.dispose();
    licenseController.dispose();
    stateController.dispose();
    districtController.dispose();
    countryController.dispose();
    cityPinController.dispose();
    inClinicFeeController.dispose();
    videoFeeController.dispose();
    certificateController.dispose();
    mobController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.white,
      appBar: CustomAppBar(title:'Doctor Registration',),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Center(
                //   child: Text(
                //     'Doctor Registration',
                //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.black),
                //   ),
                // ),
                // const SizedBox(height: 25),

                /// Profile image picker
                GestureDetector(
                  onTap: () async {
                    final pickedImage =
                    await HelperMethods.showImagePickerOptions(context);
                    if (pickedImage != null) {
                      final file = File(pickedImage.path);
                      setState(() {
                        profileFile = file;
                        _selectedImage = file;
                        profileImagePath = pickedImage.path;
                      });
                      Provider.of<RegistrationProvider>(context, listen: false)
                          .setProfileImage(file);
                    }
                  },
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage('assets/icons/personEnoty.png')
                      as ImageProvider,
                    ),
                  ),
                ),

                /// Name
                CustomTextField(
                    label: "Name",
                    controller: nameController,
                    validator: validateName),
                const SizedBox(height: 15),

                /// Category dropdown (Multi-select)
                Consumer<RegistrationProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading && provider.categories.isEmpty) {
                      return const Center(
                          child: ThreeDotsLoader(
                            color: ColorResource.primaryColor,
                          ));
                    }
                    return CustomMultiSelectDropdown(
                      label: "Select Categories",
                      items: provider.categories.map((c) => c.name ?? "").toList(),
                      selectedItems: provider.selectedCategories.map((c) => c.name ?? "").toList(),
                      onChanged: (selectedNames) {
                        // We need to sync selected categories back to the provider. 
                        // But CustomMultiSelectDropdown doesn't let us easily toggle one by one, 
                        // so we can clear and re-add or just manage it locally and push.
                        provider.selectedCategories.clear();
                        for (var name in selectedNames) {
                          final match = provider.categories.where((c) => c.name == name);
                          if (match.isNotEmpty) {
                            provider.selectedCategories.add(match.first);
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),

                /// Mobile
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 12),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: IntlPhoneField(
                      initialValue: widget.mobAvailable == true ? widget.mobileNumber : null,
                      initialCountryCode: widget.mobAvailable == true ? (widget.isoCode ?? 'IN') : 'IN',
                      readOnly: widget.mobAvailable ?? false,
                      enabled: !(widget.mobAvailable ?? false),
                      showDropdownIcon: true,
                      showCountryFlag: true, // Switched to true for better UX
                      dropdownIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF677294),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222B45),
                      ),
                      dropdownTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: const Color(0xFF419CAB),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: const Color(0xFF677294).withOpacity(0.5)),
                        filled: true,
                        fillColor: const Color(0xFFF0F4FA),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        counterText: '',
                      ),
                      onChanged: (phone) {
                        mobController.text = phone.number;
                        countryCodeController.text = phone.countryCode;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                /// DOB
                CustomTextField(
                  label: "Date of Birth",
                  controller: dobController,
                  isReadOnly: true,
                  onTap: _selectDate,
                  suffixIcon: const Icon(Icons.calendar_month),
                  validator: justForEmpty,
                ),
                const SizedBox(height: 15),

                /// Gender
                CustomTextField(
                  label: "Gender",
                  controller: genderController,
                  isDropdown: true,
                  dropdownItems: ['Male', 'Female', 'Other'],
                  validator: justForEmpty,
                ),
                const SizedBox(height: 15),
                // QualificationPicker(
                //   onSelected: (value) {
                //     qualificationController.text = value;
                //   },
                // ),
                const SizedBox(height: 15),
                /// Degree Dropdown (Mock)
                Consumer<RegistrationProvider>(
                  builder: (context, provider, _) {
                    return DropdownButtonFormField<String>(
                      value: provider.selectedDegree,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelText: "Select Degree",
                        border: OutlineInputBorder(),
                      ),
                      items: provider.degrees.map((deg) {
                        return DropdownMenuItem(
                          value: deg,
                          child: Text(deg),
                        );
                      }).toList(),
                      onChanged: (val) {
                        provider.setSelectedDegree(val);
                        if (val != null) qualificationController.text = val;
                      },
                      validator: (val) =>
                      val == null ? 'Please select a degree' : null,
                    );
                  },
                ),
                const SizedBox(height: 15),
                // CustomTextField(
                //     label: "Qualification",
                //     controller: qualificationController,
                //     validator: justForEmpty),
                const SizedBox(height: 15),

                CustomTextField(
                    label: "Address",
                    controller: addressController,
                    maxLines: 2,
                    validator: justForEmpty),
                const SizedBox(height: 15),

                CustomTextField(
                  label: "Department (comma separated)",
                  controller: departmentController,
                  validator: justForEmpty,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  label: "Years of Experience",
                  controller: experienceController,
                  validator: justForEmpty,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                    label: "License/Reg Number",
                    controller: licenseController,
                    validator: justForEmpty),
                const SizedBox(height: 15),

                /// Pincode -> auto-fill
                CustomTextField(
                  label: "Pincode",
                  controller: cityPinController,
                  validator: justForEmpty,
                  keyboardType: TextInputType.number,
                  onChanged: (val) async {
                    if (val.length == 6) {
                      final location =
                      await HelperMethods.getLocationFromPincode(val);
                      if (location != null) {
                        setState(() {
                          stateController.text = location["state"] ?? "";
                          districtController.text = location["district"] ?? "";
                          countryController.text = location["country"] ?? "";
                        });
                      } else {
                        HelperMethods.showFloatingToast(context,
                            message: 'Invalid or unknown pincode');
                      }
                    }
                  },
                ),
                const SizedBox(height: 15),

                CustomTextField(
                    label: "State",
                    controller: stateController,
                    validator: justForEmpty),
                const SizedBox(height: 15),

                CustomTextField(
                    label: "District",
                    controller: districtController,
                    validator: justForEmpty),
                const SizedBox(height: 15),

                CustomTextField(
                  label: "Country",
                  controller: countryController,
                  validator: justForEmpty,
                  isReadOnly: true,
                ),
                const SizedBox(height: 15),

                /// Certificate file
                CustomTextField(
                  label: 'Upload Certificate (PDF or Image)',
                  controller: certificateController,
                  isReadOnly: true,
                  onTap: () async {
                    final pickedFile =
                    await HelperMethods.showImagePickerOptions(context);
                    if (pickedFile != null) {
                      final file = File(pickedFile.path);
                      setState(() {
                        certificateFile = file;
                        certificateController.text =
                            pickedFile.path.split('/').last;
                      });
                      Provider.of<RegistrationProvider>(context, listen: false)
                          .setCertificateFile(file);
                    }
                  },
                  suffixIcon: const Icon(Icons.upload_file),
                ),
                const SizedBox(height: 15),

                /// Availability
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("In-Clinic Available",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                        value: inClinicAvailable,
                        onChanged: (val) =>
                            setState(() => inClinicAvailable = val ?? false),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Video Consult Available",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),
                        value: videoConsultAvailable,
                        onChanged: (val) =>
                            setState(() => videoConsultAvailable = val ?? false),
                      ),
                    ),
                  ],
                ),

                if (inClinicAvailable)
                  CustomTextField(
                      label: "In-Clinic Fee",
                      controller: inClinicFeeController,
                      validator: justForEmpty),
                if (videoConsultAvailable)
                  CustomTextField(
                      label: "Video Consult Fee",
                      controller: videoFeeController,
                      validator: justForEmpty),

                const SizedBox(height: 15),

                /// Symptoms dropdown
                Consumer<RegistrationProvider>(
                  builder: (context, provider, _) {
                    return CustomMultiSelectDropdown(
                      label: "Symptoms (optional)",
                      items: provider.symptoms.map((s) => s.name ?? "").toList(),
                      selectedItems: [],
                      onChanged: (selectedList) {
                        // map back names to IDs
                        selectedSymptomIds = provider.symptoms
                            .where((s) => selectedList.contains(s.name))
                            .map((s) => s.sId ?? "")
                            .toList();
                        print("Selected Symptom IDs: $selectedSymptomIds");
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),

                /// Specializations dropdown
                Consumer<RegistrationProvider>(
                  builder: (context, provider, _) {
                    return CustomMultiSelectDropdown(
                      label: "Specializations (optional)",
                      items: provider.specializations,
                      selectedItems: provider.selectedSpecializations,
                      onChanged: (selectedList) {
                        provider.setSelectedSpecializations(selectedList);
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),

                /// Submit button
                Consumer<RegistrationProvider>(
                  builder: (context, provider, _) {
                    return CustomAppButton(
                      label:
                      provider.isLoading ? "Registering..." : "Register",
                      isLoading: provider.isLoading,
                      onPressed: isSubmitting
                          ? () async{}
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          if (profileFile == null ||
                              certificateFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please upload profile image and certificate')),
                            );
                            return;
                          }

                          setState(() => isSubmitting = true);

                          await provider.submitRegistration(
                            name: nameController.text.trim(),
                            mobile: widget.mobileNumber ??
                                mobController.text.trim(),
                            countryCode: widget.countryCode ??
                                countryCodeController.text.trim(),
                            dob: dobController.text.trim(),
                            gender: genderController.text.trim(),
                            qualification:
                            qualificationController.text.trim(),
                            type: typeController.text,
                            address: addressController.text.trim(),
                            departments: departmentController.text
                                .split(',')
                                .map((e) => e.trim())
                                .toList(),
                            experience: experienceController.text.trim(),
                            license: licenseController.text.trim(),
                            state: stateController.text.trim(),
                            district: districtController.text.trim(),
                            country: countryController.text.trim(),
                            pincode: cityPinController.text.trim(),
                            inClinicAvailable:
                            inClinicAvailable.toString(),
                            videoConsultAvailable:
                            videoConsultAvailable.toString(),
                            inClinicFee: inClinicFeeController.text.trim(),
                            videoConsultFee: videoFeeController.text.trim(),
                            symptoms: selectedSymptomIds,
                            profileImage: profileFile!,
                            certificateFile: certificateFile!,
                            context: context,
                          );

                          setState(() => isSubmitting = false);
                        }
                      },
                      child: isSubmitting
                          ? const ThreeDotsLoader(color: Colors.white)
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
