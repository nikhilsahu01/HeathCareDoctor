
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/api_service/app_url.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../core/utils/custom_widgets/custom_inputFiled.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/helper_functions/valdationFunctions.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../view_model/profile_view_model.dart';



class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? profileImagePath;

  File? profileFile;
  Future<void> _selectDate(ProfileViewModel provider) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      provider.dobController.text =
          DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileViewModel>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: ColorResource.white,
          appBar: CustomAppBar(title: 'Personal Details'),
          body: provider.isLoading
              ? const Center(child: ThreeDotsLoader(color: ColorResource.primaryColor))
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left:20,right:20,bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // removed pending approval banner
                    GestureDetector(
                      onTap: () async {
                        final pickedImage = await HelperMethods.showImagePickerOptions(context);
                        if (pickedImage != null) {
                          final file = File(pickedImage.path);
                          setState(() {
                            profileFile = file;
                            _selectedImage = File(pickedImage.path);
                            profileImagePath = pickedImage.path;
                          });
                          Provider.of<ProfileViewModel>(context, listen: false)
                              .setProfileImage(file);
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 120,
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
                          radius: 60,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (provider.profileImageUrl != null && provider.profileImageUrl!.isNotEmpty
                              ? NetworkImage('${AppUrl.baseUrl}/${provider.profileImageUrl!}')
                              : const AssetImage('assets/images/appLogoUpdated1.png')) as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "Name",
                      controller: provider.nameController,
                      validator: justForEmpty,
                    ),
                    const SizedBox(height: 15),

                    CustomTextFieldProfile(
                      label: "Mobile",
                      controller: provider.mobileController,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: 15),

                    CustomTextFieldProfile(
                      label: "Date of Birth",
                      controller: provider.dobController,
                      isReadOnly: true,
                      onTap: () => _selectDate(provider),
                      suffixIcon: const Icon(Icons.calendar_month),
                      validator: justForEmpty,
                    ),
                    const SizedBox(height: 15),

                    CustomTextFieldProfile(
                      label: "Gender",
                      isDropdown: true,
                      dropdownItems: ['Male', 'Female', 'Other'],
                      selectedValue: provider.genderController.text.isNotEmpty
                          ? (provider.genderController.text.toLowerCase() == "male"
                          ? "Male"
                          : provider.genderController.text.toLowerCase() == "female"
                          ? "Female"
                          : "Other")
                          : null,
                      onChanged: (value) {
                        provider.genderController.text = value ?? "";
                      },
                      validator: justForEmpty,
                    ),

                    const SizedBox(height: 15),
                    CustomTextFieldProfile(
                      label: "Email ID",
                      controller: provider.emailController,
                      validator: justForEmpty,
                    ),
                    const SizedBox(height: 25),

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
                    const SizedBox(height: 15),
                    TextButton.icon(
                      onPressed: () {
                        _showTicketDialog(context, provider);
                      },
                      icon: const Icon(Icons.support_agent, color: ColorResource.primaryColor),
                      label: const Text(
                        "Raise Support Ticket",
                        style: TextStyle(color: ColorResource.primaryColor),
                      ),
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

  void _showTicketDialog(BuildContext context, ProfileViewModel provider) {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Raise Support Ticket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: "Subject"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController.text.trim().isNotEmpty && descriptionController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  provider.raiseSupportTicket(context, subjectController.text.trim(), descriptionController.text.trim());
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}


