import 'package:flutter/material.dart';

import '../model/appointments_model.dart';
import '../model/inviteDoctorModel.dart';
import '../repository/appointment_repository.dart';


import 'inviteDoctorModel.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentsRepository _repository = AppointmentsRepository();
  CheckDoctorExistingModel? checkDoctorExistingModel;
  InviteDoctorModel?inviteDoctorModel;
  // Upcoming
  List<AppointmentsList> _upcomingAppointments = [];
  bool _isLoadingUpcoming = false;
  bool _isLoadingInvite = false;

  // Completed
  List<AppointmentsList> _completedAppointments = [];
  bool _isLoadingCompleted = false;

  // Cancelled
  List<AppointmentsList> _cancelledAppointments = [];
  bool _isLoadingCancelled = false;

  // Getters
  List<AppointmentsList> get upcomingAppointments => _upcomingAppointments;
  List<AppointmentsList> get completedAppointments => _completedAppointments;
  List<AppointmentsList> get cancelledAppointments => _cancelledAppointments;

  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingInvite => _isLoadingInvite;
  bool get isLoadingCompleted => _isLoadingCompleted;
  bool get isLoadingCancelled => _isLoadingCancelled;

  /// Fetch Upcoming Appointments
  Future<void> fetchUpcomingAppointments() async {
    _isLoadingUpcoming = true;
    notifyListeners();
    try {
      final model = await _repository.getUpcomingAppointmentsListApi();
      _upcomingAppointments = model.data?.appointments ?? [];
    } catch (e) {
      debugPrint("❌ Error fetching upcoming appointments: $e");
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  Future<void> checkDoctorExistingApi({
    required String mobileNumber,
    required String appointmentId,
}) async {
    _isLoadingInvite = true;
    notifyListeners();
    try {
      final model = await _repository.checkDoctorExistingApi(mobileNumber:mobileNumber ,);
      checkDoctorExistingModel = model;
    await  inviteDoctorApi(appointmentId: appointmentId,inviteDoctor: checkDoctorExistingModel?.data?.sId??"69d8d6fe04846beb2c03c445");
    } catch (e) {
      debugPrint("❌ Error checkDoctorExistingApi  ,,,,,,,: $e");
    } finally {
      _isLoadingInvite = false;
      notifyListeners();
    }
  }  Future<void> inviteDoctorApi({
    required String inviteDoctor,
    required String appointmentId,
}) async {
    _isLoadingInvite = true;
    notifyListeners();
    try {
      final model = await _repository.inviteDoctorApi(inviteDoctor:inviteDoctor ,appointmentId:appointmentId);
      inviteDoctorModel = model;
    } catch (e) {
      debugPrint("❌ Error inviteDoctorApi...............: $e");
    } finally {
      _isLoadingInvite = false;
      notifyListeners();
    }
  }

  /// Fetch Completed Appointments
  Future<void> fetchCompletedAppointments() async {
    _isLoadingCompleted = true;
    notifyListeners();
    try {
      final model = await _repository.getCompletedAppointmentsListApi();
      _completedAppointments = model.data?.appointments ?? [];
    } catch (e) {
      debugPrint("❌ Error fetching completed appointments: $e");
    } finally {
      _isLoadingCompleted = false;
      notifyListeners();
    }
  }

  /// Fetch Cancelled Appointments
  Future<void> fetchCancelledAppointments() async {
    _isLoadingCancelled = true;
    notifyListeners();
    try {
      final model = await _repository.getCancelledAppointmentsListApi();
      _cancelledAppointments = model.data?.appointments ?? [];
    } catch (e) {
      debugPrint("❌ Error fetching cancelled appointments: $e");
    } finally {
      _isLoadingCancelled = false;
      notifyListeners();
    }
  }
}
