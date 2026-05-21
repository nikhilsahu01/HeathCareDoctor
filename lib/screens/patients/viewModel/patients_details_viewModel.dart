import 'package:flutter/material.dart';

import '../model/patients_details_model.dart';
import '../repository/patients_repository.dart';


class PatientsDetailsViewModel extends ChangeNotifier {
  final AppointmentsRepository _repository = AppointmentsRepository();

  AppointmentDetailsData? _appointmentDetails;
  bool _isLoading = false;
  String? _errorMessage;

  AppointmentDetailsData? get appointmentDetails => _appointmentDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Future<void> fetchAppointmentDetails(String consultantId) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final model = await _repository.getAppointmentsDetailsApi(consultantId);
  //     if (model.status == true && model.data != null) {
  //       _appointmentDetails = model.data;
  //     } else {
  //       _errorMessage = model.message ?? 'Something went wrong.';
  //     }
  //   } catch (e) {
  //     _errorMessage = 'Failed to load appointment details.';
  //   }
  //
  //   _isLoading = false;
  //   notifyListeners();
  // }

  void reset() {
    _appointmentDetails = null;
    _errorMessage = null;
    _isLoading = false;
  }
}
