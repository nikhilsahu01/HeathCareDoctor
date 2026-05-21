import 'package:flutter/material.dart';
import '../../../core/api_service/app_url.dart';
import '../../../core/api_service/network_api_service.dart';
import '../model/patients_details_model.dart';
import '../model/patients_model.dart';

class AppointmentsRepository {
  final _apiService = NetworkApiServices();

  Future<AppointmentsListModel> getUpcomingAppointmentsListApi() async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.appointmentsList}?type=Pending');
      print('resssposssnscee:$response');
      return AppointmentsListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<AppointmentsListModel> getCompletedAppointmentsListApi() async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.appointmentsList}?type=Completed');
      print('resssposssnscee:$response');
      return AppointmentsListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<AppointmentsListModel> getCancelledAppointmentsListApi() async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.appointmentsList}?type=Cancelled');
      print('resssposssnscee:$response');
      return AppointmentsListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  // Future<AppointmentDetailsModel> getAppointmentsDetailsApi(String consultantId) async {
  //   try {
  //     final response = await _apiService.getApiWithToken('${AppUrl.appointmentDetails}/$consultantId');
  //     print('resssposssnscee:$response');
  //     return AppointmentDetailsModel.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<bool> rescheduleAppointment({
  //   required String id,
  //   required String newDate,
  //   required String newTime,
  //   required String rescheduleReason,
  // }) async {
  //   final body = {
  //     "newDate": newDate,
  //     "newTime": newTime,
  //     "rescheduleReason": rescheduleReason, // avoid hardcoded ''
  //   };
  //
  //   final url = '${AppUrl.rescheduleAppointment}/$id';
  //
  //   // 🔍 Print full request details
  //   debugPrint("📤 Reschedule Appointment Request:");
  //   debugPrint("➡️ URL: $url");
  //   debugPrint("➡️ Body: $body");
  //
  //   try {
  //     final response = await _apiService.postApiWithToken(body, url);
  //     debugPrint("✅ Response: $response");
  //     return response['status'] == true;
  //   } catch (e) {
  //     debugPrint("❌ Exception during reschedule request: $e");
  //     rethrow;
  //   }
  // }

  // Future<bool> cancelAppointment({
  //   required String id,
  //   required String cancelReason,
  // }) async {
  //   final body = {
  //     "cancellReason": cancelReason,
  //   };
  //   final url = '${AppUrl.cancelAppointment}/$id';
  //   try {
  //     final response = await _apiService.postApiWithToken(body, url);
  //     debugPrint("✅ Response: $response");
  //     return response['status'] == true;
  //   } catch (e) {
  //     debugPrint("❌ Exception during reschedule request: $e");
  //     rethrow;
  //   }
  // }
  // Future<bool> updateReminder({
  //   required String id,
  //
  // }) async {
  //   final body = {
  //     "updated": 'updatedReminder',//not needed
  //   };
  //   final url = '${AppUrl.updateReminder}/$id';
  //   try {
  //     final response = await _apiService.patchApiWithToken(body, url);
  //     debugPrint("✅ Response: $response");
  //     return response['status'] == true;
  //   } catch (e) {
  //     debugPrint("❌ Exception during reschedule request: $e");
  //     rethrow;
  //   }
  // }
}

