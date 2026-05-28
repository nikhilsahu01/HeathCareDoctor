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
      final now = DateTime.now();
      _upcomingAppointments = (model.data?.appointments ?? [])
          .where((e) {
            if (e.status != 'Pending' && e.status != 'Confirmed') return false;
            try {
              // Format: e.appointmentDate is likely a date string, e.timeSlot like "10:30" or "10:30 AM"
              final dateString = e.appointmentDate ?? '';
              final timeString = e.timeSlot ?? '';
              if (dateString.isEmpty || timeString.isEmpty) return true; // keep if invalid data to avoid missing data

              // Attempt to parse date (assuming YYYY-MM-DD or similar standard format from DB)
              DateTime? apptDate;
              try {
                apptDate = DateTime.parse(dateString);
              } catch (_) {
                // If parsing fails, just keep it
                return true;
              }
              
              // Simplistic time check: we'll check if the day is in the past
              final apptDay = DateTime(apptDate.year, apptDate.month, apptDate.day);
              final todayDay = DateTime(now.year, now.month, now.day);
              
              if (apptDay.isBefore(todayDay)) return false; // Passed day
              
              // If it's today, check time roughly (assuming format like "HH:MM" or "HH:MM AM/PM")
              if (apptDay.isAtSameMomentAs(todayDay)) {
                 // Try to parse time
                 // This is a rough check. If timeSlot is "19:04 - 19:34", we take "19:04"
                 final timePart = timeString.split(' - ').first.trim();
                 // Time parsing is tricky without knowing format. Assuming HH:MM
                 int hour = 0;
                 int min = 0;
                 if (timePart.contains(RegExp(r'[aA][mM]|[pP][mM]'))) {
                    // AM/PM format
                    final isPm = timePart.toLowerCase().contains('pm');
                    final cleanTime = timePart.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
                    final parts = cleanTime.split(':');
                    if (parts.length == 2) {
                       hour = int.tryParse(parts[0]) ?? 0;
                       min = int.tryParse(parts[1]) ?? 0;
                       if (isPm && hour < 12) hour += 12;
                       if (!isPm && hour == 12) hour = 0;
                    }
                 } else {
                    // 24hr format
                    final parts = timePart.split(':');
                    if (parts.length == 2) {
                       hour = int.tryParse(parts[0]) ?? 0;
                       min = int.tryParse(parts[1]) ?? 0;
                    }
                 }
                 final apptTime = DateTime(now.year, now.month, now.day, hour, min);
                 // Allow a small grace period, e.g., 60 minutes after the start time
                 if (apptTime.add(const Duration(minutes: 60)).isBefore(now)) return false; 
              }
              
              return true;
            } catch (_) {
              return true; // keep on any error
            }
          })
          .toList();
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

  Future<bool> completeAppointment(String appointmentId) async {
    try {
      final success = await _repository.completeAppointmentApi(appointmentId);
      if (success) {
        // Refresh lists
        fetchUpcomingAppointments();
        fetchCompletedAppointments();
      }
      return success;
    } catch (e) {
      debugPrint("❌ Error completeAppointment: $e");
      return false;
    }
  }

  /// Fetch Completed Appointments
  Future<void> fetchCompletedAppointments() async {
    _isLoadingCompleted = true;
    notifyListeners();
    try {
      final model = await _repository.getCompletedAppointmentsListApi();
      _completedAppointments = (model.data?.appointments ?? [])
          .where((e) => e.status == 'Completed')
          .toList();
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
      _cancelledAppointments = (model.data?.appointments ?? [])
          .where((e) => e.status == 'Cancelled')
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching cancelled appointments: $e");
    } finally {
      _isLoadingCancelled = false;
      notifyListeners();
    }
  }
}
