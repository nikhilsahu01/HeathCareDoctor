import 'dart:io';

import '../../../../core/api_service/app_url.dart';
import '../../../../core/api_service/network_api_service.dart';
import '../model/doctors_category_model.dart';
import '../model/doctors_symtomps_categories_model.dart';
import '../model/qualification_tree_model.dart';

class RegistrationRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> signUpApi({
    required String name,
    required String mobile,
    required String countryCode,
    required String dob,
    required String gender,
    required List<String> category,
    required List<String> qualification,
    required String type,
    required String address,
    required List<String> department,
    required String yearOfExp,
    required String licOrRegNumber,
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
  }) async {
    try {
      final Map<String, String> fields = {
        "Name": name,
        "mobile": mobile,
        "countryCode": countryCode,
        "dob": dob,
        "gender": gender,
        // category and qualification mapped differently below
        "type": type,
        "address": address,
        "department": department.join(","),
        "yearOfExp": yearOfExp,
        "licOrRegNumber": licOrRegNumber,
        "state": state,
        "district": district,
        "country": country,
        "pincode": pincode,
        "inClinicAvailable": inClinicAvailable,
        "videoConsultAvailable": videoConsultAvailable,
        "inClinicFee": inClinicFee,
        "videoConsultFee": videoConsultFee,
      };

      // 🔹 Only add symptoms if not null/empty
      if (symptoms != null && symptoms.isNotEmpty) {
        for (int i = 0; i < symptoms.length; i++) {
          fields['symptoms[$i]'] = symptoms[i];
        }
      }

      if (category.isNotEmpty) {
        for (int i = 0; i < category.length; i++) {
          fields['category[$i]'] = category[i];
        }
      }

      if (qualification.isNotEmpty) {
        for (int i = 0; i < qualification.length; i++) {
          fields['qualification[$i]'] = qualification[i];
        }
      }

      final Map<String, File> files = {
        "profileImage": profileImage,
        "certificate": certificateFile,
      };

      final response = await _apiService.postMultipartRegisterApi(
        url: AppUrl.signUp,
        fields: fields,
        files: files,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DoctorsCategories> getDoctorsCategoriesApi() async {
    try {
      final response = await _apiService.getApi(AppUrl.doctorsCategory);
      print('DoctorsCategories:$response');
      return DoctorsCategories.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<SymptomsModel> getSymptomsApi() async {
    try {
      final response = await _apiService.getApi(AppUrl.symptomsList);
      print('getSymptomsApi:$response');
      return SymptomsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<QualificationTreeResponse> getQualificationTreeApi() async {
    try {
      final response = await _apiService.getApi(AppUrl.qualificationTree);
      print('getQualificationTreeApi:$response');
      return QualificationTreeResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
