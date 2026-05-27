import 'dart:async';
import 'package:doctors/core/utils/helper_functions/helpers_methods.dart';
import 'package:doctors/core/utils/navigation_helper.dart';
import 'package:doctors/core/utils/theams/color_resource.dart';
import 'package:doctors/screens/auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../model/doctors_category_model.dart';
import '../model/doctors_symtomps_categories_model.dart';
import '../repository/registration_repo.dart';

class RegistrationProvider extends ChangeNotifier {
  final RegistrationRepository _repository = RegistrationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? profileImage;
  File? certificateFile;

  // -------- Category State --------
  List<DoctorCategoryData> _categories = [];
  List<DoctorCategoryData> get categories => _categories;

  DoctorCategoryData? _selectedCategory;
  DoctorCategoryData? get selectedCategory => _selectedCategory;

  // -------- Symptoms State --------
  List<symptomsData> _symptoms = [];
  List<symptomsData> get symptoms => _symptoms;

  // expose just names for dropdown
  List<String> get symptomsList => _symptoms.map((s) => s.name ?? "").toList();

  // -------- File handling --------
  void setProfileImage(File file) {
    profileImage = file;
    notifyListeners();
  }

  void setCertificateFile(File file) {
    certificateFile = file;
    notifyListeners();
  }

  // -------- Fetch Categories --------
  Future<void> fetchDoctorCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = await _repository.getDoctorsCategoriesApi();
      _categories = res.data ?? [];
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------- Fetch Symptoms --------
  Future<void> fetchSymptomsApi() async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = await _repository.getSymptomsApi();
      _symptoms = res.data ?? [];
    } catch (e) {
      debugPrint("Error fetching getSymptomsApi: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------- Select Category --------
  void selectCategory(DoctorCategoryData category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // -------- Submit Registration --------
  Future<void> submitRegistration({
    required String name,
    required String mobile,
    required String countryCode,
    required String dob,
    required String gender,
    required String qualification,
    required String type,
    required String address,
    required List<String> departments,
    required String experience,
    required String license,
    required String state,
    required String district,
    required String country,
    required String pincode,
    required String inClinicAvailable,
    required String videoConsultAvailable,
    required String inClinicFee,
    required String videoConsultFee,
    List<String>? symptoms, // 🔹 made nullable
    required File profileImage,
    required File certificateFile,
    required BuildContext context,
  }) async {
    if (profileImage == null || certificateFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload profile image and certificate')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.signUpApi(
        name: name,
        mobile: mobile,
        countryCode: countryCode,
        dob: dob,
        gender: gender == 'Male'
            ? 'male'
            : gender == 'Female'
            ? 'female'
            : 'other',
        category: _selectedCategory!.sId ?? "",
        qualification: qualification,
        type: type,
        address: address,
        department: departments,
        yearOfExp: experience,
        licOrRegNumber: license,
        state: state,
        district: district,
        country: country,
        pincode: pincode,
        inClinicAvailable: inClinicAvailable,
        videoConsultAvailable: videoConsultAvailable,
        inClinicFee: inClinicFee,
        videoConsultFee: videoConsultFee,
        symptoms: symptoms,
        profileImage: profileImage,
        certificateFile: certificateFile,
      );
      HelperMethods.showFloatingToast(context, message: 'Registration Successful: ${res['message'] ?? ''}',color: ColorResource.green);
      navPush(context: context, page: const LoginScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed: ${e.toString()}')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
