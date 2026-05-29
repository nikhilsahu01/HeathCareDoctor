import 'package:flutter/material.dart';
import '../../../core/api_service/app_url.dart';
import '../../../core/api_service/network_api_service.dart';
import '../model/appointments_details_model.dart';
import '../model/appointments_model.dart';
import '../model/inviteDoctorModel.dart';
import '../viewModel/inviteDoctorModel.dart';

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

  Future<dynamic> getAvailableDoctorsListApi() async {
    try {
      final response = await _apiService.postApiWithToken({}, AppUrl.commonDoctorList);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckDoctorExistingModel> checkDoctorExistingApi({
    required String mobileNumber,
    // required String appointmentId,
}) async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.commonDoctorList}?mobile=$mobileNumber');
      print('InviteDoctorModel:$response');
      return CheckDoctorExistingModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  // Future<SymptomsListModel> getSymptomsListApi(String symName) async {
  //   try {
  //     final response = await _apiService.getApiWithToken('${AppUrl.symptomsList}/$symName');
  //     print('resssposssnscee:$response');
  //     return SymptomsListModel.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<InviteDoctorModel> inviteDoctorApi({
    required String inviteDoctor,
    required String appointmentId,
}) async {
    try {
      var  data={
        "inviteDoctor":inviteDoctor,
        "_id":appointmentId,
      };
      final response = await _apiService.putApiWithToken(data,AppUrl.invite );
      print('InviteDoctorModel:$response');
      return InviteDoctorModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> completeAppointmentApi(String appointmentId) async {
    try {
      var data = {
        "_id": appointmentId,
        "status": "Completed"
      };
      final response = await _apiService.putApiWithToken(data, AppUrl.invite); // The route is actually for updating appointment despite the variable name AppUrl.invite.
      print('completeAppointmentApi:$response');
      return response['success'] == true;
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
  Future<AppointmentDetailsModel> getAppointmentsDetailsApi(String consultantId) async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.appointmentDetails}/$consultantId');
      print('resssposssnscee:$response');
      return AppointmentDetailsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

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

