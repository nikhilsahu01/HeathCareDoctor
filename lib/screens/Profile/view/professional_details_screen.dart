import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';
import '../../../core/utils/custom_widgets/custom_inputFiled.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/helper_functions/valdationFunctions.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../../core/utils/custom_widgets/customMultipleSelectionWithChip.dart';
import '../../auth/registration/helper/qualificationData.dart';
import '../../auth/registration/viewModel/registration_provider.dart';
import '../view_model/profile_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api_service/app_url.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  const ProfessionalDetailsScreen({super.key});

  @override
  State<ProfessionalDetailsScreen> createState() =>
      _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
      Provider.of<RegistrationProvider>(context, listen: false).fetchQualificationTree();
      Provider.of<RegistrationProvider>(context, listen: false).fetchDoctorCategories();
      Provider.of<RegistrationProvider>(context, listen: false).fetchSymptomsApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: ColorResource.white,
          appBar: CustomAppBar(title: 'Professional Details'),
          body:
              provider.isLoading
                  ? const Center(
                    child: ThreeDotsLoader(color: ColorResource.primaryColor),
                  )
                  : SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<RegistrationProvider>(
                              builder: (context, regProvider, _) {
                                return QualificationSelector(
                                  treeNodes: regProvider.qualificationTree,
                                  initialValues: provider.qualificationController.text.isNotEmpty
                                      ? [provider.qualificationController.text]
                                      : [],
                                  onQualificationChanged: (qualificationStrings) {
                                    provider.qualificationController.text =
                                        qualificationStrings.join(" , ");
                                  },
                                );
                              }
                            ),
                            const SizedBox(height: 15),

                            Consumer<RegistrationProvider>(
                              builder: (context, regProvider, _) {
                                if (regProvider.isLoading && regProvider.categories.isEmpty) {
                                  return const Center(child: ThreeDotsLoader(color: ColorResource.primaryColor));
                                }
                                return CustomMultiSelectDropdown(
                                  label: "Select Categories (Specializations)",
                                  items: regProvider.categories.map((cat) => cat.name ?? "").toList(),
                                  selectedItems: provider.selectedCategoryNames,
                                  onChanged: (selectedList) {
                                    provider.selectedCategoryNames = selectedList;
                                    provider.selectedCategoryIds = selectedList.map((name) {
                                      final found = regProvider.categories.firstWhere(
                                          (cat) => cat.name == name,
                                          orElse: () => regProvider.categories.first // dummy
                                      );
                                      if (found.name == name) {
                                        return found.sId!;
                                      }
                                      return name; // send custom name
                                    }).toList();
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 15),

                            Consumer<RegistrationProvider>(
                              builder: (context, regProvider, _) {
                                List<String> displaySymptoms = provider.selectedSymptomNames.isNotEmpty 
                                    ? provider.selectedSymptomNames 
                                    : regProvider.symptoms
                                        .where((s) => provider.selectedSymptomIds.contains(s.sId))
                                        .map((s) => s.name ?? "")
                                        .toList();

                                return CustomMultiSelectDropdown(
                                  label: "Symptoms (optional)",
                                  items: regProvider.symptoms.map((s) => s.name ?? "").toList(),
                                  selectedItems: displaySymptoms,
                                  onChanged: (selectedList) {
                                    provider.selectedSymptomNames = selectedList;
                                    provider.selectedSymptomIds = selectedList.map((name) {
                                      final found = regProvider.symptoms.firstWhere(
                                          (s) => s.name == name,
                                          orElse: () => regProvider.symptoms.first // dummy
                                      );
                                      if (found.name == name) {
                                        return found.sId!;
                                      }
                                      return name; // send custom name
                                    }).toList();
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            // CustomTextFieldProfile(
                            //   label: "Specialization",
                            //   controller: provider.specializationController,
                            //   validator: justForEmpty,
                            // ),
                            // const SizedBox(height: 15),
                            // CustomTextFieldProfile(
                            //   label: "Country Registration",
                            //   controller:
                            //       provider.countryRegistrationController,
                            //   validator: justForEmpty,
                            // ),
                            // const SizedBox(height: 15),

                            CustomTextFieldProfile(
                              label: "Medical Registration Number",
                              controller: provider.registrationNumber,
                              isReadOnly: true,
                              validator: justForEmpty,
                            ),
                            const SizedBox(height: 15),
                            CustomTextFieldProfile(
                              label: "Year Of Registration",
                              controller: provider.yearRegistrationController,
                              keyboardType: TextInputType.number,
                              validator: justForEmpty,
                              onChanged: (val) {
                                int? year = int.tryParse(val ?? '');
                                if (year != null && year > 1900 && year <= DateTime.now().year) {
                                  provider.yoxController.text = (DateTime.now().year - year).toString();
                                }
                              },
                            ),
                            const SizedBox(height: 15),

                            CustomTextFieldProfile(
                              label: "Years of Experience",
                              controller: provider.yoxController,
                              validator: justForEmpty,
                              keyboardType: TextInputType.number,
                            ),

                            // const SizedBox(height: 15),
                            // const SizedBox(height: 25),

                            // ==================== NEW: Document Upload Section ====================
                            // ==================== Upload Section (Inside your Column) ====================

                            const SizedBox(height: 25),

// Main Container with Grey Border
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    // "Upload Medical Registration Documents",
                                    "View Upload Document",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // const SizedBox(height: 6),
                                  // const Text(
                                  //   "PDF only • Multiple files allowed • Max 10 MB each",
                                  //   style: TextStyle(
                                  //     fontSize: 13,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 20),

                                  if ((provider.profileData?.data?.certificate ?? "").isNotEmpty) ...[

                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final url = "${AppUrl.baseUrl}/${provider.profileData!.data!.certificate!.replaceAll('\\', '/')}";
                                          try {
                                            await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Could not open document')),
                                            );
                                          }
                                        },

                                        icon: const Icon(Icons.remove_red_eye),
                                        label: const Text("View Uploaded Document"),
                                        style: ElevatedButton.styleFrom(

                                          foregroundColor: Colors.white, backgroundColor: ColorResource.primaryColor,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                    // const Center(child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                    // const SizedBox(height: 15),
                                  ],


                                  // Dashed Border Upload Area (Clickable)
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //     await _pickDocuments(provider);
                                  //   },
                                  //   child: Container(
                                  //     width: double.infinity,
                                  //     height: 120,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.grey.shade50,
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       border: Border.all(
                                  //         color: Colors.grey.shade400,
                                  //         width: 1,
                                  //         style: BorderStyle.solid,
                                  //       ),
                                  //       // Dashed effect using custom decoration
                                  //     ),
                                  //     child: Column(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         Icon(
                                  //           Icons.cloud_upload_outlined,
                                  //           size: 40,
                                  //           color: Colors.grey.shade600,
                                  //         ),
                                  //         const SizedBox(height: 8),
                                  //         Text(
                                  //           "Tap to upload PDFs",
                                  //           style: TextStyle(
                                  //             fontSize: 15,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: Colors.grey.shade700,
                                  //           ),
                                  //         ),
                                  //         const SizedBox(height: 4),
                                  //         Text(
                                  //           "Maximum 10 MB per file",
                                  //           style: TextStyle(
                                  //             fontSize: 12,
                                  //             color: Colors.grey.shade500,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  //
                                  // const SizedBox(height: 16),

                                  // Selected Files List
                                  if (provider.selectedDocuments.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Selected Files:",
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        ...provider.selectedDocuments.map((file) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                            title: Text(
                                              file.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              "${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB",
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.close, color: Colors.red),
                                              onPressed: () => provider.removeDocument(file),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            // const SizedBox(height: 30),
                            //
                            // const SizedBox(height: 12),
                            //
                            // // Display selected files
                            // if (provider.selectedDocuments.isNotEmpty)
                            //   Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: provider.selectedDocuments.map((file) {
                            //       return ListTile(
                            //         contentPadding: EdgeInsets.zero,
                            //         leading: const Icon(Icons.picture_as_pdf,
                            //             color: Colors.red),
                            //         title: Text(
                            //           file.name,
                            //           style: const TextStyle(fontSize: 14),
                            //         ),
                            //         subtitle: Text(
                            //           "${(file.size / 1024 / 1024).toStringAsFixed(2)} MB",
                            //           style: const TextStyle(fontSize: 12),
                            //         ),
                            //         trailing: IconButton(
                            //           icon: const Icon(Icons.close, size: 20),
                            //           onPressed: () {
                            //             provider.removeDocument(file);
                            //           },
                            //         ),
                            //       );
                            //     }).toList(),
                            //   ),

                            const SizedBox(height: 30),
                            //Upload medical registration documents (PDF only accepted, multiple uploads allowed, maximum 10 MB)

                            // CustomTextFieldProfile(
                            //   label: "License Authority",
                            //   controller: provider.laController,
                            //   validator: justForEmpty,
                            // ),
                            // const SizedBox(height: 15),
                            CustomAppButton(
                              label:
                                  provider.isLoading
                                      ? "Saving..."
                                      : "Update Profile",
                              isLoading: provider.isLoading,
                              onPressed: () async {
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
  // ====================== Document Picker Function ======================
  Future<void> _pickDocuments(ProfileViewModel provider) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
        withData: false, // You can set true if you need bytes immediately
      );

      if (result != null) {
        List<PlatformFile> validFiles = [];

        for (var file in result.files) {
          final sizeInMB = file.size / (1024 * 1024);

          if (sizeInMB > 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${file.name} exceeds 10 MB limit"),
                backgroundColor: Colors.red,
              ),
            );
            continue;
          }
          validFiles.add(file);
        }

        if (validFiles.isNotEmpty) {
          provider.addDocuments(validFiles);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to pick files. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
