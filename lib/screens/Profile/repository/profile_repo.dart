import 'dart:io';

import '../../../core/api_service/app_url.dart';
import '../../../core/api_service/network_api_service.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  final _apiService = NetworkApiServices();

  // ---- GET Profile ----
  Future<DoctorsProfileDetails> getProfileApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.profile);
      print('Profile Response: $response');
      return DoctorsProfileDetails.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // ---- UPDATE Profile (PATCH with multipart) ----
  // Future<DoctorsProfileDetails> updateProfileApi({
  //   required Map<String, String> fields,
  //   required Map<String, File> files,
  // }) async {
  //   try {
  //     final response = await _apiService.patchMultipartApiWithToken(
  //       url: AppUrl.profile,
  //       fields: fields,
  //       files: files,
  //     );
  //     print('Update Profile Response: $response');
  //     return DoctorsProfileDetails.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<DoctorsProfileDetails> updateProfileApi({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    try {
      final response = await _apiService.patchMultipartApiWithToken(
        url: AppUrl.profile,
        fields: fields,
        files: files,
      );

      print('Update Profile Response: $response');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return DoctorsProfileDetails.fromJson(response['data']);
      } else {
        throw Exception("Invalid response format: $response");
      }
    } catch (e) {
      rethrow;
    }
  }
}
