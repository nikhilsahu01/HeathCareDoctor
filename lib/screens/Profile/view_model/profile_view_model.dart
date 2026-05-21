import 'dart:convert';
import 'dart:io';
import 'package:doctors/core/utils/helper_functions/helpers_methods.dart';
import 'package:doctors/core/utils/theams/color_resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../mapPicker/ui/mapPickerScreen.dart';
import '../model/profile_model.dart';
import '../repository/profile_repo.dart';



class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();
  DoctorsProfileDetails? profileDetails;
  bool isLoading = false;
  String? profileImageUrl;

  DoctorsProfileDetails? get profileData => profileDetails;

  // Controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final languagesController = TextEditingController();
  final specializationController = TextEditingController();
  final countryRegistrationController = TextEditingController();
  final yearRegistrationController = TextEditingController();
  final qualificationController = TextEditingController();
  final yoxController = TextEditingController();
  final registrationNumber = TextEditingController();
  final laController = TextEditingController();
  final hospitalAddress = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController();
  final inClinicFee = TextEditingController();
  final sessionTimeController = TextEditingController();
  final videoConsultFee = TextEditingController();
  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();
  final breakTimeController = TextEditingController();
  final lunchStartController = TextEditingController();
  final lunchEndController = TextEditingController();

  File? profileFile;
  File? certificateFile;

  bool inClinicAvailable = false;
  bool videoConsultAvailable = false;

  /// Days (mapped from API `selectDays`)
  List<Map<String, dynamic>> days = [
    {"day": "Monday", "available": false},
    {"day": "Tuesday", "available": false},
    {"day": "Wednesday", "available": false},
    {"day": "Thursday", "available": false},
    {"day": "Friday", "available": false},
    {"day": "Saturday", "available": false},
    {"day": "Sunday", "available": false},
  ];

    void setProfileImage(File file) {
    profileFile = file;
    notifyListeners();
  }
  List<PlatformFile> selectedDocuments = [];

  void addDocuments(List<PlatformFile> files) {
    selectedDocuments.addAll(files);
    notifyListeners();
  }

  void removeDocument(PlatformFile file) {
    selectedDocuments.remove(file);
    notifyListeners();
  }

// Clear documents after successful upload if needed
  void clearDocuments() {
    selectedDocuments.clear();
    notifyListeners();
  }
  // ---------------- FETCH PROFILE ----------------
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profileDetails = await _repo.getProfileApi();

      if (profileDetails?.data != null) {
        final data = profileDetails!.data!;
        profileImageUrl = data.profileImage ?? "";
        nameController.text = data.name ?? '';
        mobileController.text = data.mobile ?? '';
        dobController.text = data.dob ?? '';
        genderController.text = data.gender ?? '';
        emailController.text = data.email ?? '';
        languagesController.text = data.symptoms?.join(", ") ?? '';

        specializationController.text = data.specialization ?? '';
        qualificationController.text = data.qualification ?? '';
        yoxController.text = data.yearOfExp ?? '';
        registrationNumber.text = data.licOrRegNumber ?? '';
        laController.text = data.licenseAuthority ?? '';

        hospitalAddress.text = data.address ?? '';
        inClinicFee.text = data.inClinicFee ?? '0';
        videoConsultFee.text = data.videoConsultFee ?? '0';
        cityController.text = data.city ?? '';
        stateController.text = data.state ?? '';
        pincodeController.text = data.pincode ?? '';
        inClinicAvailable = data.inClinicAvaialble ?? false;
        videoConsultAvailable = data.videoConsultAvailable ?? false;
        sessionTimeController.text = data.sessionTime?.trim() ?? '';

        openingTimeController.text = data.openingTime ?? '';
        closingTimeController.text = data.closingTime ?? '';
        breakTimeController.text = "${data.breakTime ?? ''}";
        lunchStartController.text = data.lunchStart ?? '';
        lunchEndController.text = data.lunchEnd ?? '';

        // 🔹 Map API selectDays to `days`
        if (data.selectDays != null) {
          for (var d in days) {
            final match =
            data.selectDays!.firstWhere((e) => e.day == d["day"], orElse: () => SelectDay(day: d["day"], available: false));
            d["available"] = match.available ?? false;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- UPDATE PROFILE ----------------
  Future<void> updateProfile(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      if (inClinicAvailable) {
        final fee = inClinicFee.text.trim();
        if (fee.isEmpty || fee == "0") {
          HelperMethods.showFloatingToast(
            context,
            message: "In-clinic Fee is required when In-clinic Availability is ON",
            color: ColorResource.red,
          );
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (videoConsultAvailable) {
        final fee = videoConsultFee.text.trim();
        if (fee.isEmpty || fee == "0") {
          HelperMethods.showFloatingToast(
            context,
            message: "Video Consultation Fee is required when Video Consultation Availability is ON",
            color: ColorResource.red,
          );
          isLoading = false;
          notifyListeners();
          return;
        }
      }
      // 🔹 Convert `days` into backend format
      final selectDaysData = days
          .map((d) => {
        "day": d["day"],
        "available": d["available"],
      })
          .toList();

      final fields = <String, String>{
        "Name": nameController.text.trim(),
        "mobile": mobileController.text.trim(),
        "dob": dobController.text.trim(),
        "gender": genderController.text.toLowerCase().trim(),
        "email": emailController.text.trim(),
        "languages": languagesController.text.trim(),
        "specialization": specializationController.text.trim(),
        "qualification": qualificationController.text.trim(),
        "yearOfExp": yoxController.text.trim(),
        "licOrRegNumber": registrationNumber.text.trim(),
        "licenseAuthority": laController.text.trim(),
        "address": hospitalAddress.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "videoConsultFee": videoConsultFee.text.trim(),
        "inClinicFee": inClinicFee.text.trim(),
        "pincode": pincodeController.text.trim(),
        "inClinicAvaialble": inClinicAvailable.toString(),
        "videoConsultAvailable": videoConsultAvailable.toString(),
        "sessionTime": sessionTimeController.text.trim(),
        "selectDays": jsonEncode(selectDaysData),
        "openingTime": openingTimeController.text.trim(),
        "closingTime": closingTimeController.text.trim(),
        "breakTime": breakTimeController.text.trim(),
        "lunchStart": lunchStartController.text.trim(),
        "lunchEnd": lunchEndController.text.trim(),
      };

      final files = <String, File>{};
      if (profileFile != null) files["profileImage"] = profileFile!;
      if (certificateFile != null) files["certificate"] = certificateFile!;

      profileDetails = await _repo.updateProfileApi(fields: fields, files: files);
      HelperMethods.showFloatingToast(
        context,
        message: 'Profile updated successfully!',
        color: ColorResource.green,
      );

      // 🔹 Refresh in background, don’t block user if parsing fails
      Future.microtask(() => fetchProfile());
    } catch (e) {
      // Error updating profile: type 'String' is not a subtype of type 'Map<String, dynamic>'
      debugPrint("Error updating profile: $e");//still triggering this
      HelperMethods.showFloatingToast(
        context,
        message: 'Failed to update profile',
        color: ColorResource.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- TOGGLE DAY ----------------
  void toggleDay(int index, bool value) {
    days[index]["available"] = value;
    notifyListeners();
  }double? latitude;
  double? longitude;
  Future<void> openMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );

    if (result != null) {
      hospitalAddress.text = result["address"] ?? "";

      cityController.text = result["city"] ?? "";
      stateController.text = result["state"] ?? "";
      pincodeController.text = result["pincode"] ?? "";
      countryController.text = result["country"] ?? "";

      latitude = result["lat"];
      longitude = result["lng"];

      notifyListeners();
    }
  }
}
